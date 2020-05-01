# Importing packages
using JuMP, GLPK, Distributions

# Product Data
no_products = 6
products = 1:no_products
p = [150; 100; 120; 80; 250; 170]
mu = [30; 60; 20; 80; 30; 40]
sigma = [5; 7; 2; 4; 3; 9]

# Resource Data
no_resources = 2
resources = 1:no_resources
x = [110; 230]

# A_ij = 1, if resource i is used by product j
A = [ 1 1 0 0 1 1 ;
      0 0 1 1 1 1 ]


# Solving the deterministic LP problem
function DLP(x, D)
  m = Model(GLPK.Optimizer)
  @variable(m, y[products] >= 0)
  @objective(m, Max, sum( p[j]*y[j] for j in products) )

  # Resource Constraint
  @constraint(m, rsc_const[i in 1:no_resources],
          sum( A[i,j]*y[j] for j in products) <= x[i]  )

  # Upper Bound
  @constraint(m, bounds[j in 1:no_products], y[j] <= D[j] )

  JuMP.optimize!(m)
  pi_val = JuMP.shadow_price.(rsc_const)
  return pi_val
end

# Generating N samples
N = 100
samples = Array{Float64}(undef, no_products, N)
for j in products
  samples[j,:] = rand( Normal(mu[j], sigma[j]), N)
end

# Obtain the dual variable for each sample
pi_samples = Array{Float64}(undef, no_resources, N)
for k in 1:N
  pi_samples[:,k] = DLP(x, samples[:,k])
end

# Compute the average
pi_estimate = sum(pi_samples, dims=2) / N
println("** pi estimate = ",  pi_estimate')
