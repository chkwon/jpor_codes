using JuMP, Gurobi
m = Model(solver=GurobiSolver())

@defVar(m, 0 <= x <= 2 )
@defVar(m, 0 <= y <= 30 )

@setObjective(m, Max, 5x + 3*y )

@addConstraint(m, 1x + 5y <= 3.0 )

print(m)

status = solve(m)

println("Objective value: ", getObjectiveValue(m))
println("x = ", getValue(x))
println("y = ", getValue(y))
