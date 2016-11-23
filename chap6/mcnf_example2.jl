using JuMP, Gurobi

# Include the function definition of `minimal_cost_network_flow`
include("mcnf.jl")

# Data Preparation

network_data_file = "simple_network.csv"
network_data = readcsv(network_data_file,  header=true)
data = network_data[1]
header = network_data[2]

start_node = round(Int64, data[:,1])
end_node = round(Int64, data[:,2])
c = data[:,3]
u = data[:,4]

network_data2_file = "simple_network_b.csv"
network_data2 = readcsv(network_data2_file,  header=true)
data2 = network_data2[1]
hearder2 = network_data2[2]

b = data2[:,2]

no_node = max( maximum(start_node), maximum(end_node) )
no_link = length(start_node)

# Creating a graph
nodes = 1:no_node
links = Array{Tuple{Int, Int}}(no_link)
c_dict = Dict()
u_dict = Dict()
for i=1:no_link
  links[i] = (start_node[i], end_node[i])
  c_dict[(start_node[i], end_node[i])] = c[i]
  u_dict[(start_node[i], end_node[i])] = u[i]
end

# Solve the minimal-cost network-flow problem by a function call
x_star, obj, status = minimal_cost_network_flow(nodes, links, c_dict, u_dict, b)

println("min_cost = $obj, status = $status")
