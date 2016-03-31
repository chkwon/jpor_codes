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



function minimal_cost_network_flow(nodes, links, c_dict, u_dict, b)
