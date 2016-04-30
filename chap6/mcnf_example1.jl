# Importing packages
using JuMP, Gurobi

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

# number of nodes and number of links
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

# Preparing an optimization model
mcnf = Model(solver=GurobiSolver())

# Defining decision variables
@variable(mcnf, 0<= x[link in links] <= u_dict[link])

# Setting the objective
@objective(mcnf, Min, sum{ c_dict[link] * x[link], link in links}  )

# Adding the flow conservation constraints
for i in nodes
    @constraint(mcnf, sum{x[(ii,j)], (ii,j) in links; ii==i }
                       - sum{x[(j,ii)], (j,ii) in links; ii==i } == b[i])
end

print(mcnf)
status = solve(mcnf)
println("The solution status is: $status")
obj = getobjectivevalue(mcnf)
x_star = getvalue(x)

println("The optimal objective function value is = $obj")
println(x_star)
