using JuMP, GLPK, DelimitedFiles

# Reading the data file and preparting arrays
data_file = "transportation.csv"
data = readdlm(data_file, ',')

supply_nodes = data[3:end, 2]
s = data[3:end, 1]

demand_nodes = collect(data[2, 3:end])
d = collect(data[1, 3:end])

c = data[3:end, 3:end]

# Converting arrays to dictionaries
s_dict = Dict(supply_nodes .=> s)
d_dict = Dict(demand_nodes .=> d)
c_dict = Dict( (supply_nodes[i], demand_nodes[j]) => c[i,j]
          for i in 1:length(supply_nodes), j in 1:length(demand_nodes) )

# Preparing an Optimization Model
tp = Model(with_optimizer(GLPK.Optimizer))

@variable(tp, x[supply_nodes, demand_nodes] >= 0)
@objective(tp, Min, sum(c_dict[i,j]*x[i,j]
                    for i in supply_nodes, j in demand_nodes))
for i in supply_nodes
  @constraint(tp, sum(x[i,j] for j in demand_nodes) == s_dict[i] )
end
for j in demand_nodes
  @constraint(tp, sum(x[i,j] for i in supply_nodes) == d_dict[j] )
end

print(tp)
JuMP.optimize!(tp)
obj = JuMP.objective_value(tp)
x_star = JuMP.value.(x)

for s in supply_nodes, d in demand_nodes
    println("from $s to $d: ", x_star[s, d])
end
