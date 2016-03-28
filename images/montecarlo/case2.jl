using Graphs, TikzGraphs, TikzPictures

adj = [
0 1 1 0 0 1 0 0 1 0 0 0 0 0 0 0 ;
0 0 1 1 0 0 0 1 1 0 0 1 0 1 1 1 ;
1 0 0 0 0 0 0 0 0 1 1 0 0 0 0 1 ;
1 1 0 0 1 1 1 1 0 1 1 0 1 0 0 1 ;
0 1 0 0 0 0 1 0 0 1 1 0 0 0 1 0 ;
1 0 0 0 0 0 0 0 1 0 0 1 0 0 0 0 ;
0 0 0 1 0 1 0 0 1 0 0 0 0 1 0 1 ;
1 0 0 0 0 0 0 0 1 1 1 0 0 1 0 0 ;
1 1 0 0 1 0 0 0 0 0 1 0 0 1 0 0 ;
1 1 0 0 1 1 0 0 1 0 0 0 1 0 1 0 ;
0 0 1 0 0 0 0 0 0 1 0 0 0 0 0 1
]

n = size(adj,1)

g = simple_graph(n)

for i=1:n
    for j=1:n
        if adj[i,j]==1
            add_edge!(g,i,j)
        end
    end
end

t = TikzGraphs.plot(g)
save(TEX("graph"), t)
