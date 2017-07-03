# Importing packages
using LightGraphs

# Retrieves 0-1 'x' vector from the 'state'
function getShortestX(state, start_node, end_node, origin, destination)
  _x = zeros(Int, length(start_node))
  _path = enumerate_paths(state, destination)

  for i=1:length(_path)-1
    _start = _path[i]
    _end = _path[i+1]

    for j=1:length(start_node)
      if start_node[j]==_start && end_node[j]==_end
        _x[j] = 1
        break
      end
    end

  end
  _x
end


# Data Preparation
network_data_file = "simple_network.csv"
network_data = readcsv(network_data_file,  header=true)
data = network_data[1]
header = network_data[2]

start_node = round.(Int64, data[:,1])
end_node = round.(Int64, data[:,2])
c = data[:,3]

origin = 1
destination = 5

# number of nodes and number of links
no_node = max( maximum(start_node), maximum(end_node) )
no_link = length(start_node)

# Creating a graph
graph = Graph(no_node)
distmx = Inf*ones(no_node, no_node)

# Adding links to the graph
for i=1:no_link
  add_edge!(graph, start_node[i], end_node[i])
  distmx[start_node[i], end_node[i]] = c[i]
end

# Run Dijkstra's Algorithm from the origin node to all nodes
state = dijkstra_shortest_paths(graph, origin, distmx)

# Retrieving the shortest path
path = enumerate_paths(state, destination)
println("The shortest path is:", path)

# Retrieving the 'x' variable in a 0-1 vector
x = getShortestX(state, start_node, end_node, origin, destination)
println("x vector:", x)

# The cost of shortest path
println("Cost is $(state.dists[destination])") # directly from state
println("Cost is $(dot(c, x))")                # c'x in scalar
println("Cost is $(c' * x)")                   # c'x in 1x1 array
