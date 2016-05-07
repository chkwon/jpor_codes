using Optim

function f_line(x_bar, d_bar, lambda)
    x_new = x_bar + lambda*d_bar
    return (2x_new[1] - 3)^4 + (3x_new[1] - x_new[2])^2
end

x_bar = [2.0, 3.0]
d_bar = [-1.0, 0.0]

opt = optimize( lambda -> f_line(x_bar, d_bar, lambda),
                             0.0, 1.0, method=GoldenSection())

println("optimal lambda = ", opt.minimum)
println("optimal f(x+lambda*d) = ", opt.f_minimum)
