# code/chap5/tranpsortation1.jl
using JuMP, Gurobi

# Reading the data file and preparting arrays
data_file = "transportation.csv"
data = readcsv(data_file)

supply_nodes = data[3:end, 2]
s = data[3:end, 1]

demand_nodes = collect(data[2, 3:end])
d = collect(data[1, 3:end])

c = data[3:end, 3:end]

# Converting arrays to dictionaries
s_dict = Dict( zip( supply_nodes, s) )
d_dict = Dict( zip( demand_nodes, d) )

c_dict = Dict()
for i in 1:length(supply_nodes)
    for j in 1:length(demand_nodes)
        c_dict[supply_nodes[i], demand_nodes[j]] = c[i,j]
    end
end

# Preapring an Optimization Model
tp = Model(solver=GurobiSolver())

@defVar(tp, x[supply_nodes, demand_nodes] >= 0)
@setObjective(tp, Min, sum{c_dict[i,j]*x[i,j],
                              i in supply_nodes, j in demand_nodes})
for i in supply_nodes
    @addConstraint(tp, sum{x[i,j], j in demand_nodes} == s_dict[i] )
end
for j in demand_nodes
    @addConstraint(tp, sum{x[i,j], i in supply_nodes} == d_dict[j] )
end

print(tp)
solve(tp)
x_star = getValue(x)
