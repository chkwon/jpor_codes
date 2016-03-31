using JuMP
using Gurobi

# Preparing an optimization model
m = Model(solver=GurobiSolver())

# Declaring variables
@defVar(m, 0<= x1 <=10)
@defVar(m, x2 >=0)
@defVar(m, x3 >=0)

# Setting the objective
@setObjective(m, Max, x1 + 2x2 + 5x3)

# Adding constraints
@addConstraint(m, constraint1, -x1 +  x2 + 3x3 <= -5)
@addConstraint(m, constraint2,  x1 + 3x2 - 7x3 <= 10)

# Printing the prepared optimization model
print(m)

# Solving the optimization problem
solve(m)

# Printing the optimal solutions obtained
println("Optimal Solutions:")
println("x1 = ", getValue(x1))
println("x2 = ", getValue(x2))
println("x3 = ", getValue(x3))

# Printing the optimal dual variables
println("Dual Variables:")
println("dual1 = ", getDual(constraint1))
println("dual2 = ", getDual(constraint2))
