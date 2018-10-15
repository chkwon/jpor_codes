using JuMP, Gurobi
m = Model(with_optimizer(Gurobi.Optimizer))

@variable(m, x[1:2])
@objective(m, Min, (x[1]-3)^2 + (x[2]-4)^2)
@constraint(m, (x[1]-1)^2 + (x[2]+1)^2 <= 1)

JuMP.optimize!(m)

println("** Optimal objective function value = ", JuMP.objective_value(m))
println("** Optimal solution = ", JuMP.result_value.(x))
