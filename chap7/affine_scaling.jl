using LinearAlgebra

function affine_scaling(c,A,b,x0; beta=0.5, epsilon=1e-9, max_iter=1000)

    # Preparing variables for the trajectories
    x1_traj = []
    x2_traj = []

    # Initialization
    x = x0

    for i in 1:max_iter
      # Recording the trajectories of x1 and x2
      push!(x1_traj, x[1])
      push!(x2_traj, x[2])

      # Computing
      X = Diagonal(x)
      p = inv(A*X^2*A')*A*X^2*c
      r = c - A'*p

      # Optimality check
      if minimum(r) >= 0  &&  dot(x,r) < epsilon
        break
      end

      # Update
      x = x - beta * X^2 * r / norm(X*r)
    end

    return x1_traj, x2_traj
end
