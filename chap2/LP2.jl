using JuMP
using Gurobi
m = Model(solver=GurobiSolver())

c = [ 1; 2; 5]
A = [-1  1  3;
      1  3 -7]
b = [-5; 10]

@variable(m, x[1:3] >= 0)
@objective(m, Max, sum{ c[i]*x[i], i=1:3} )

@constraint(m, constraint[j=1:2], sum{ A[j,i]*x[i], i=1:3 } <= b[j] )

@constraint(m, bound, x[1] <= 10)

solve(m)

print(m)

println("Optimal Solutions:")
for i=1:3
    println("x[$i] = ", getvalue(x[i]))
end

println("Dual Variables:")
for j=1:2
    println("dual[$j] = ", getdual(constraint[j]))
end
