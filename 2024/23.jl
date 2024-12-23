Clique = Set{String}

function parse_graph(file)
    neighbors = Dict{String,Set{String}}()
    for line in eachline(file)
        u, v = split(line, '-')
        push!(get!(neighbors, u, Set()), v)
        push!(get!(neighbors, v, Set()), u)
    end
    return neighbors
end

function find_triangles(graph, char)
    nodes = filter(startswith(char), keys(graph))
    triangles = [0, 0, 0]
    for node in nodes, n1 in graph[node], n2 in graph[node]
        if n1 ∈ graph[n2]
            count = startswith(n1, char) + startswith(n2, char)
            triangles[count+1] += 1
        end
    end
    return sum(((i, c),) -> c ÷ (2 * i), enumerate(triangles))
end

is_clique(s, graph) = all(u == v || u ∈ graph[v] for u in s for v in s)


function max_clique(graph, candidates, cur_max)
    length(candidates) ≤ cur_max && return nothing
    is_clique(candidates, graph) && return candidates
    m = cur_max - 1
    best = nothing
    for v in candidates
        new = filter(>(v), candidates ∩ graph[v])
        mc = max_clique(graph, new, m)
        if !isnothing(mc)
            m = length(mc)
            best = union(mc, [v])
        end
    end
    return best
end
max_clique(graph) = max_clique(graph, Set(keys(graph)), 0)

open(ARGS[1]) do file
    graph = parse_graph(file)
    println(find_triangles(graph, 't'))
    @time res = max_clique(graph)
    println(join(sort(collect(res)), ','))
end