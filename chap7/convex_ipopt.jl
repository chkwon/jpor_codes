using JuMP, Ipopt
m = Model(solver=IpoptSolver())

@defVar(m, x[1:2])
@setObjective(m, Min, (x[1]-3)^2 + (x[2]-4)^2)
@addConstraint(m, (x[1]-1)^2 + (x[2]+1)^2 <= 1)

solve(m)

println("** Optimal objective function value = ", getObjectiveValue(m))
println("** Optimal solution = ", getValue(x))
