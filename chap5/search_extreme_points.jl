
function isnonnegative(x::Array{Float64})
    return length( x[ x .< 0] ) == 0
end

function search_extreme_points(c, A, b)
    m, n = size(A)
    @assert rank(A) == min(m,n)

    obj = Inf
    opt_x = zeros(n)
    for b_idx in combinations(1:n, m)
        B = A[:, b_idx]
        c_B = c[b_idx]

        x_B = inv(B) * b

        if isnonnegative(x_B)
            z = dot(c_B, x_B)
            if z < obj
                obj = z
                opt_x = zeros(n)
                opt_x[b_idx] = x_B
            end
        end

        println("Basis:", b_idx)
        println("\t x_B = ", x_B)
        println("\t nonnegative? ", isnonnegative(x_B))
        if isnonnegative(x_B)
            println("\t obj = ", dot(c_B, x_B))
        end

    end

    return opt_x, obj
end
