a = 10; b = 1; c = [3, 4]

using Complementarity, JuMP
m = MCPModel()

@variable(m, q[1:2] >= 0)
@mapping(m, F[i in 1:2], - (a - c[i] - 2b*q[i] - b*q[i%2+1]) )
@complementarity(m, F, q)

solveMCP(m)
@show result_value.(q)

status = solveMCP(m, solver=:NLsolve)
@show result_value.(q)
