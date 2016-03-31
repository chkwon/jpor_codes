using JuMP
using Gurobi
m = Model(solver=GurobiSolver())

c = [ 1; 2; 5]
A = [-1  1  3;
      1  3 -7]
b = [-5; 10]

@defVar(m, x[1:3] >= 0)
@setObjective(m, Max, sum{ c[i]*x[i], i=1:3} )

@addConstraint(m, constraint[j=1:2], sum{ A[j,i]*x[i], i=1:3 } <= b[j] )

@addConstraint(m, bound, x[1] <= 10)

solve(m)

print(m)

println("Optimal Solutions:")
for i=1:3
    println("x[$i] = ", getValue(x[i]))
end

println("Dual Variables:")
for j=1:2
    println("dual[$j] = ", getDual(constraint[j]))
end
