# Importing packages
using JuMP, GLPK, DelimitedFiles

# Data Preparation
network_data_file = "simple_network.csv"
network_data = readdlm(network_data_file, ',', header=true)
data = network_data[1]
header = network_data[2]

start_node = round.(Int64, data[:,1])
end_node = round.(Int64, data[:,2])
c = data[:,3]
u = data[:,4]

network_data2_file = "simple_network_b.csv"
network_data2 = readdlm(network_data2_file, ',', header=true)
data2 = network_data2[1]
hearder2 = network_data2[2]

b = data2[:,2]

# number of nodes and number of links
no_node = max( maximum(start_node), maximum(end_node) )
no_link = length(start_node)

# Creating a graph
nodes = 1:no_node
links = Tuple( (start_node[i], end_node[i]) for i in 1:no_link )
c_dict = Dict( zip(links, c) )
u_dict = Dict( zip(links, u) )

# Preparing an optimization model
mcnf = Model(with_optimizer(GLPK.Optimizer))

# Defining decision variables
@variable(mcnf, 0<= x[link in links] <= u_dict[link])

# Setting the objective
@objective(mcnf, Min, sum( c_dict[link] * x[link] for link in links)  )

# Adding the flow conservation constraints
for i in nodes
  @constraint(mcnf, sum(x[(ii,j)] for (ii,j) in links if ii==i )
                  - sum(x[(j,ii)] for (j,ii) in links if ii==i ) == b[i])
end

print(mcnf)
JuMP.optimize!(mcnf)
obj = JuMP.objective_value(mcnf)
x_star = JuMP.result_value.(x)

println("The optimal objective function value is = $obj")
println(x_star.data)
