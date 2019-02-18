using LinearAlgebra

function primal_path_following(c,A,b,x0;
            mu=0.9, alpha=0.9, epsilon=1e-9, max_iter=1000)
  # Preparing variables for the trajectories
  x1_traj = []
  x2_traj = []

  # Initialization
  x = x0
  e = ones(length(x),1)
  n = length(x)
  m = length(b)

  for i=1:max_iter
    # Recording the trajectories of x1 and x2
    push!(x1_traj, x[1])
    push!(x2_traj, x[2])

    # Computing
    X = Diagonal(x)
    mu = alpha * mu

    # Solving the linear system
    LHS = [ mu*inv(X)^2       -A'     ;
               A          zeros(m,m)  ]
    RHS = [ mu*inv(X)*e - c ;
            zeros(m,1) ]
    sol = LHS \ RHS

    # Update
    d = sol[1:n]
    p = sol[n+1:end]
    x = x + d
    s = c - A'*p

    # Optimality check
    if dot(s,x) < epsilon
      break
    end
  end

  return x1_traj, x2_traj
end
