using JuMP, Ipopt
m = Model(solver=IpoptSolver())

@variable(m, x[1:2])
@objective(m, Min, (x[1]-3)^2 + (x[2]-4)^2)
@constraint(m, (x[1]-1)^2 + (x[2]+1)^2 <= 1)

solve(m)

println("** Optimal objective function value = ", getobjectivevalue(m))
println("** Optimal solution = ", getvalue(x))
