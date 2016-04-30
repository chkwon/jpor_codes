using JuMP
using Gurobi

# Preparing an optimization model
m = Model(solver=GurobiSolver())

# Declaring variables
@variable(m, 0<= x1 <=10)
@variable(m, x2 >=0)
@variable(m, x3 >=0)

# Setting the objective
@objective(m, Max, x1 + 2x2 + 5x3)

# Adding constraints
@constraint(m, constraint1, -x1 +  x2 + 3x3 <= -5)
@constraint(m, constraint2,  x1 + 3x2 - 7x3 <= 10)

# Printing the prepared optimization model
print(m)

# Solving the optimization problem
solve(m)

# Printing the optimal solutions obtained
println("Optimal Solutions:")
println("x1 = ", getvalue(x1))
println("x2 = ", getvalue(x2))
println("x3 = ", getvalue(x3))

# Printing the optimal dual variables
println("Dual Variables:")
println("dual1 = ", getdual(constraint1))
println("dual2 = ", getdual(constraint2))
