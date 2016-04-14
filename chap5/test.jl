c = [-3; -2; -1; -5; 0; 0; 0]
A = [7 3 4 1 1 0 0 ;
     2 1 1 5 0 1 0 ;
     1 4 5 2 0 0 1 ]
b = [7; 3; 8]


c = Array{Float64}(c)
A = Array{Float64}(A)
b = Array{Float64}(b)


using MathProgBase, Gurobi
@time sol = linprog(c, A, '=', b, GurobiSolver(Method=0))

include("search_bfs.jl")
@time opt_x1, obj1 = searchBFS(c, A, b)

include("simplex_method.jl")
using SimplexMethod
@time opt_x2, obj2 = simplex_method(c, A, b)


println()
println("obj by MathProgBase.linprog  = ", sol.objval)
println("obj by search_extreme_points = ", obj1)
println("obj by simplex_method        = ", obj2)
println()
println("x*  by MathProgBase.linprog  = ", sol.sol)
println("x*  by search_extreme_points = ", opt_x1)
println("x*  by simplex_method        = ", opt_x2)
println()
