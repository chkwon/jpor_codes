using Complementarity, JuMP

arcs = 1:5
paths = 1:3

delta = [ 1 0 0 ;
          0 1 1 ;
          0 1 0 ;
          1 1 0 ;
          0 0 1 ]
A = [25, 25, 75, 25, 25]
B = [0.01, 0.01, 0.001, 0.01, 0.01]

Q = 100

m = MCPModel()

@variable(m, h[paths] >= 0)
@variable(m, u >= 0)

@mapping(m, excess_cost[p in paths],
    sum(delta[a,p]*(A[a] + B[a]*(sum(delta[a,pp]*h[pp] for pp in paths))^2)
        for a in arcs) - u )
@mapping(m, excess_demand, sum(h[p] for p in paths) - Q)

@complementarity(m, excess_cost, h)
@complementarity(m, excess_demand, u)

status = solveMCP(m)

@show result_value.(h)
@show result_value(u)
