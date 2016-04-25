using JuMP, Gurobi, PyPlot

# Solving the p-median problem by Lagrangian Relaxation
p = 3

# Reading demand data
d, header = readcsv("demand.csv",  header=true)

# Reading transportation cost data
data = readcsv("cost.csv")
c = data[2:end, 2:end]
c = convert(Array{Float64,2}, c)

# the length of 'd' and the number of columns in 'c' must match
@assert length(d) == size(c,2)

locations = 1:size(c,1) # the set, I
customers = 1:length(d) # the set, J


function optimal(p)
    m = Model(solver=GurobiSolver())

    @defVar(m, x[i in locations, j in customers] >= 0)
    @defVar(m, y[i in locations], Bin)

    @setObjective(m, Min, sum{ d[j]*c[i,j]*x[i,j],
                                 i in locations, j in customers} )

    for j in customers
        @addConstraint(m, sum{ x[i,j], i in locations} == 1)
    end

    @addConstraint(m, sum{ y[i], i in locations} == p)

    for i in locations
        for j in customers
            @addConstraint(m, x[i,j] <= y[i] )
        end
    end

    solve(m)

    Z_opt = getObjectiveValue(m)
    x_opt = getValue(x)
    y_opt = getValue(y)

    return Z_opt, x_opt, y_opt
end



function lower_bound(lambda, p)
    # Step 1: Computing v
    v = Array{Float64}(size(locations))
    for i in locations
        v[i] = 0
        for j in customers
            v[i] = v[i] + min(0, d[j]*c[i,j] - lambda[j] )
        end
    end

    # Step 2: Sorting v from the most negative to zero
    idx = sortperm(v)

    # Step 3: Determine y
    y = zeros(Int, size(locations))
    y[idx[1:p]] = 1

    # Step 4: Determine x
    x = zeros(Int, length(locations), length(customers))
    for i in locations
        for j in customers
            if y[i]==1 && d[j]*c[i,j]-lambda[j]<0
                x[i,j] = 1
            end
        end
    end

    # Computing the Z_D(lambda^k)
    Z_D = 0.0
    for j in customers
        Z_D = Z_D + lambda[j]
        for i in locations
            Z_D = Z_D + d[j]*c[i,j]*x[i,j] - lambda[j]*x[i,j]
        end
    end

    return Z_D, x, y
end



function upper_bound(y)
    # Computing x, given y
    x = zeros(Int, length(locations), length(customers))
    for j in customers
        idx = indmin( c[:,j] + (1-y)*maximum(c) )
        x[idx,j] = 1
    end

    # Computing Z
    Z = 0.0
    for i in locations
        for j in customers
            Z = Z + d[j]*c[i,j]*x[i,j]
        end
    end
    return Z, x
end


# The maximum number of iterations allowed
MAX_ITER = 10000

# To track the upper and lower bounds
UB = Array{Float64}(0)
LB = Array{Float64}(0)

# The best-known upper and lower bounds
Z_UB = Inf
Z_LB = -Inf

# The best-known feasible solutions
x_best = zeros(length(locations), length(customers))
y_best = zeros(length(locations))

# Initial multiplier
lambda = zeros(size(customers))

# Finding the exact optimal solution
Z_opt, x_opt, y_opt = optimal(p)

for k=1:MAX_ITER
    # Obtaining the lower and upper bounds
    Z_D, x_D, y = lower_bound(lambda, p)
    Z, x = upper_bound(y)

    # Updating the upper bound
    if Z < Z_UB
        Z_UB = Z
        x_best = x
        y_best = y
    end

    # Updating the lower bound
    if Z_D > Z_LB
        Z_LB = Z_D
    end

    # Adding the bounds from the current iteration to the record
    push!(UB, Z)
    push!(LB, Z_D)

    # Determining the step size and updating the multiplier
    theta = 1.0
    residual = 1 - transpose(sum(x_D, 1))
    t = theta * (Z_UB - Z_D) / sum(residual.^2)
    lambda = lambda + t * residual

    # Computing the optimality gap
    opt_gap = (Z_UB-Z_LB) / Z_UB
    if opt_gap < 0.000001
        break
    end
end



iter = 1:length(LB)
fig = figure()

# Plotting two datasets
plot(iter, LB, color="red", linewidth=2.0, linestyle="-",
   marker="o", label="Lower Bound")
plot(iter, UB, color="blue", linewidth=2.0, linestyle="-.",
   marker="D", label="Upper Bound")

# Labeling axes
xlabel(L"iteration clock $k$", fontsize="xx-large")
ylabel("Bounds", fontsize="xx-large")

# Putting the legend and determining the location
legend(loc="lower right", fontsize="x-large")

# Add grid lines
grid(color="#DDDDDD", linestyle="-", linewidth=1.0)
tick_params(axis="both", which="major", labelsize="x-large")

# Title
title("Lower and Upper Bounds")
savefig("iterations.png")
savefig("iterations.pdf")
close(fig)
