using JuMP, NLopt
m = Model(solver=NLoptSolver(algorithm=:LD_SLSQP))

# NLOPT_LD_SLSQP: a sequential quadratic programming (SQP) algorithm
# For other available solvers from NLopt see:
# http://ab-initio.mit.edu/wiki/index.php/NLopt_Algorithms

@defVar(m, x[1:2])
@setNLObjective(m, Min, (x[1]-3)^3 + (x[2]-4)^2)
@addNLConstraint(m, (x[1]-1)^2 + (x[2]+1)^3 + exp(-x[1]) <= 1)

solve(m)

println("** Optimal objective function value = ", getObjectiveValue(m))
println("** Optimal solution = ", getValue(x))
