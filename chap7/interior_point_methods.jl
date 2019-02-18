include("affine_scaling.jl")
include("primal_path_following.jl")

c = [-1, -1, 0, 0]
A = [1 2 1 0 ;
     2 1 0 1 ]
b = [3, 3]

# Initial Starting Solution
x1 = 0.5
x2 = 0.03
# x0 = [0.5, 0.03, 2.44, 1.97]
x0 = [x1, x2, 3-x1-2*x2, 3-2*x1-x2]

x1_traj, x2_traj = affine_scaling(c, A, b, x0)


using PyPlot
fig = figure()
plot(x1_traj, x2_traj, "o-", label="Affine Scaling")
legend(loc="upper right")
savefig("affine_scaling.pdf")
savefig("affine_scaling.png")
close(fig)





c = [-1, -1, 0, 0]
A = [1 2 1 0 ;
     2 1 0 1 ]
b = [3, 3]

# Initial Starting Solution
x1 = 0.5
x2 = 0.03
# x0 = [0.5, 0.03, 2.44, 1.97]
x0 = [x1, x2, 3-x1-2*x2, 3-2*x1-x2]

x1_traj_a, x2_traj_a = affine_scaling(c, A, b, x0)
x1_traj_p, x2_traj_p = primal_path_following(c, A, b, x0)

using PyPlot
fig = figure()
plot(x1_traj_a, x2_traj_a, "o-", label="Affine Scaling")
plot(x1_traj_p, x2_traj_p, "*-", label="Primal Path Following")
legend(loc="upper right")
savefig("primal_path_following.pdf")
savefig("primal_path_following.png")
close(fig)
