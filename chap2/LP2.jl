using JuMP, GLPK
m = Model(GLPK.Optimizer

c = [ 1; 2; 5]
A = [-1  1  3;
      1  3 -7]
b = [-5; 10]

@variable(m, x[1:3] >= 0)
@objective(m, Max, sum( c[i]*x[i] for i in 1:3) )

@constraint(m, constraint[j in 1:2], sum( A[j,i]*x[i] for i in 1:3 ) <= b[j] )
@constraint(m, bound, x[1] <= 10)

JuMP.optimize!(m)


println("Optimal Solutions:")
for i in 1:3
  println("x[$i] = ", JuMP.value(x[i]))
end

println("Dual Variables:")
for j in 1:2
  println("dual[$j] = ", JuMP.shadow_price(constraint[j]))
end
