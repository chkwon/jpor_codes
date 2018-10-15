function minimal_cost_network_flow(nodes, links, c_dict, u_dict, b)
  mcnf = Model(with_optimizer(GLPK.Optimizer()))

  @variable(mcnf, 0<= x[link in links] <= u_dict[link])

  @objective(mcnf, Min, sum( c_dict[link] * x[link] for link in links)  )

  for i in nodes
    @constraint(mcnf, sum(x[(ii,j)] for (ii,j) in links if ii==i )
                    - sum(x[(j,ii)] for (j,ii) in links if ii==i ) == b[i])
  end

  JuMP.optimize!(mcnf)
  obj = JuMP.objective_value(mcnf)
  x_star = JuMP.result_value.(x)

  return x_star, obj
end
