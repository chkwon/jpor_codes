using Optim

function f_line(lambda)
    x_new = x_bar + lambda*d_bar
    return (2x_new[1] - 3)^4 + (3x_new[1] - x_new[2])^2
end

x_bar = [2.0, 3.0]
d_bar = [-1.0, 0.0]

opt = optimize(f_line, 0.0, 1.0, method=:golden_section)

println("optimal lambda = ", opt.minimum)
println("optimal f(x+lambda*d) = ", opt.f_minimum)
