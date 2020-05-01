using JuMP, GLPK
m = Model(GLPK.Optimizer)

c = [ 1; 2; 5]
A = [-1  1  3;
      1  3 -7]
b = [-5; 10]

index_x = 1:3
index_constraints = 1:2

@variable(m, x[index_x] >= 0)
@objective(m, Max, sum( c[i]*x[i] for i in index_x) )

@constraint(m, constraint[j in index_constraints],
               sum( A[j,i]*x[i] for i in index_x ) <= b[j] )

@constraint(m, bound, x[1] <= 10)

JuMP.optimize!(m)

println("Optimal Solutions:")
for i in index_x
  println("x[$i] = ", JuMP.value(x[i]))
end

println("Dual Variables:")
for j in index_constraints
  println("dual[$j] = ", JuMP.shadow_price(constraint[j]))
end
