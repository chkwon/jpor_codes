using JuMP, Ipopt
m = Model(solver=IpoptSolver())

@variable(m, x[1:2])
@NLobjective(m, Min, (x[1]-3)^3 + (x[2]-4)^2)
@NLconstraint(m, (x[1]-1)^2 + (x[2]+1)^3 + exp(-x[1]) <= 1)

solve(m)

println("** Optimal objective function value = ", getobjectivevalue(m))
println("** Optimal solution = ", getvalue(x))
