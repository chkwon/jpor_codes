using JuMP, NLopt
m = Model(solver=NLoptSolver(algorithm=:LD_SLSQP))

# NLOPT_LD_SLSQP: a sequential quadratic programming (SQP) algorithm
# For other available solvers from NLopt see:
# http://ab-initio.mit.edu/wiki/index.php/NLopt_Algorithms

@variable(m, x[1:2])
@NLobjective(m, Min, (x[1]-3)^3 + (x[2]-4)^2)
@NLconstraint(m, (x[1]-1)^2 + (x[2]+1)^3 + exp(-x[1]) <= 1)

solve(m)

println("** Optimal objective function value = ", getobjectivevalue(m))
println("** Optimal solution = ", getvalue(x))
