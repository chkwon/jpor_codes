using DelimitedFiles

# Data Preparation
network_data_file = "simple_network.csv"
network_data = readdlm(network_data_file, ',', header=true)
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

# Preparing sets and variables
N = Set(1:no_node)
links = Tuple( (start_node[i], end_node[i]) for i in 1:no_link )
A = Set(links)
c_dict = Dict( zip(links, c) )


function my_dijkstra(N, A, c_dict)
    # Preparing an array
    w = Array{Float64}(undef, no_node)

    # Step 0
    w[origin] = 0
    X = Set{Int}([origin])
    Xbar = setdiff(N, X)

    # Iterations for Dijkstra's algorithm
    while !isempty(Xbar)
      # Step 1
      XX = Set{Tuple{Int,Int}}()
      for i in X, j in Xbar
        if (i,j) in A
          push!(XX, (i,j))
        end
      end

      # Step 2
      min_value = Inf
      q = 0
      for (i,j) in XX
        if w[i] + c_dict[(i,j)] < min_value
          min_value = w[i] + c_dict[(i,j)]
          q = j
        end
      end

      # Step 3
      w[q] = min_value
      push!(X, q)

      # Step 4
      Xbar = setdiff(N, X)
    end

    return w
end


w = my_dijkstra(N, A, c_dict)

println("The length of node $origin to node $destination is: ", w[destination])
