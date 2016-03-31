using JuMP
using Gurobi
m = Model(solver=GurobiSolver())

c = [ 1; 2; 5]
A = [-1  1  3;
      1  3 -7]
b = [-5; 10]

index_x = 1:3
index_constraints = 1:2

@defVar(m, x[index_x] >= 0)
@setObjective(m, Max, sum{ c[i]*x[i], i in index_x} )

@addConstraint(m, constraint[j in index_constraints],
                  sum{ A[j,i]*x[i], i in index_x } <= b[j] )

@addConstraint(m, bound, x[1] <= 10)

solve(m)

print(m)

println("Optimal Solutions:")
for i in index_x
    println("x[$i] = ", getValue(x[i]))
end

println("Dual Variables:")
for j in index_constraints
    println("dual[$j] = ", getDual(constraint[j]))
end
