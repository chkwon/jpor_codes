function generate_sample_path(adj_mtx, origin, destination)
  # Make a copy of adj_mtx
  adj_copy = copy(adj_mtx)

  # Initializing variables
  path = [origin]
  g = 1
  current = origin

  # Disconnect origin from all other nodes
  adj_copy[:, origin] = 0

  while current != destination
    # Find all nodes connected to current
    V = find(adj_copy[current,:])
    if length(V)==0
      break
    end

    # Choose a node randomly and add to path
    next = rand(V)
    path = [path; next]

    # Update variables for the next iteration
    current = next
    adj_copy[:, next] = 0
    g = g / length(V)
  end

  I = 0
  if path[end]==destination
    I = 1
  end

  return I, g
end
