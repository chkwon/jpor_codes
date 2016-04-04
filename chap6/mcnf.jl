function minimal_cost_network_flow(nodes, links, c_dict, u_dict, b)
    mcnf = Model(solver=GurobiSolver())

    @defVar(mcnf, 0<= x[link in links] <= u_dict[link])

    @setObjective(mcnf, Min, sum{ c_dict[link] * x[link], link in links}  )

    for i in nodes
        @addConstraint(mcnf, sum{x[(ii,j)], (ii,j) in links; ii==i }
                           - sum{x[(j,ii)], (j,ii) in links; ii==i } == b[i])
    end

    status = solve(mcnf)
    obj = getObjectiveValue(mcnf)
    x_star = getValue(x)

    return x_star, obj, status
end
