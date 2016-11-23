include("generate_sample_path.jl")

adj_mtx = [
0 1 1 1 0 ;
1 0 1 0 1 ;
1 1 1 1 1 ;
1 0 1 0 1 ;
0 1 1 1 0
]
origin = 1
destination = 5

N = 100
estimate = 0
for i in 1:N
  I, g = generate_sample_path(adj_mtx, origin, destination)
  estimate += I / g
end
estimate = estimate / N

println("estimate = ", estimate)

adj_mtx = [
0 1 1 0 0 1 0 0 1 0 0 0 0 0 0 0 ;
0 0 1 1 0 0 0 1 1 0 0 1 0 1 1 1 ;
1 0 0 0 0 0 0 0 0 1 1 0 0 0 0 1 ;
1 1 0 0 1 1 1 1 0 1 1 0 1 0 0 1 ;
0 1 0 0 0 0 1 0 0 1 1 0 0 0 1 0 ;
1 0 0 0 0 0 0 0 1 0 0 1 0 0 0 0 ;
0 0 0 1 0 1 0 0 1 0 0 0 0 1 0 1 ;
1 0 0 0 0 0 0 0 1 1 1 0 0 1 0 0 ;
1 1 0 0 1 0 0 0 0 0 1 0 0 1 0 0 ;
1 1 0 0 1 1 0 0 1 0 0 0 1 0 1 0 ;
0 0 1 0 0 0 0 0 0 1 0 0 0 0 0 1 ;
0 0 1 1 1 1 0 1 0 0 1 0 1 1 0 1 ;
1 1 0 0 1 1 0 0 0 0 0 0 0 1 0 0 ;
0 0 1 0 1 1 1 0 1 0 0 1 0 0 1 0 ;
1 0 0 0 0 0 0 0 0 0 0 1 1 0 0 1 ;
1 1 0 1 0 0 0 1 0 0 1 0 0 0 0 0
]
origin = 1
destination = size(adj_mtx,1)

N = 1000
estimate = 0
for i in 1:N
  I, g = generate_sample_path(adj_mtx, origin, destination)
  estimate += I / g
end
estimate = estimate / N

println("estimate = ", estimate)
