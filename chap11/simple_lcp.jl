a = 10; b = 1; c1 = 3; c2 = 4

using Complementarity, JuMP
m = MCPModel()

@variable(m, q1 >= 0)
@variable(m, q2 >= 0)

@mapping(m, F1, - (a - c1 - 2b*q1 - b*q2) )
@mapping(m, F2, - (a - c2 - 2b*q2 - b*q1) )

@complementarity(m, F1, q1)
@complementarity(m, F2, q2)

solveMCP(m)
@show result_value(q1)
@show result_value(q2)

status = solveMCP(m, solver=:NLsolve)
@show result_value(q1)
@show result_value(q2)
