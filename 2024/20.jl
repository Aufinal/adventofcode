using DataStructures

const N = CartesianIndex(0, -1)
const E = CartesianIndex(1, 0)
const S = CartesianIndex(0, 1)
const W = CartesianIndex(-1, 0)
const directions = (N, E, S, W)
Position = CartesianIndex{2}

manhattan(x, y) = abs(x[1] - y[1]) + abs(y[2] - x[2])

function find_path(maze)
    pos = findfirst(isequal('S'), maze)
    path = [pos]
    dir = nothing
    while maze[pos] != 'E'
        dir = only(filter(d -> (-d != dir) && maze[pos+d] != '#', directions))
        pos += dir
        push!(path, pos)
    end
    return path
end

function find_cheats(distances, max_dist)
    cheats = []
    for (p1, d1) in distances, (p2, d2) in distances
        d = manhattan(p1, p2)
        if d ≤ max_dist && d2 - d1 > d
            gained = d2 - d1 - d
            push!(cheats, (d, gained))
        end
    end
    return cheats
end


open(ARGS[1]) do file
    maze = reduce(hcat, collect.(readlines(file)))
    path = find_path(maze)
    println(length(path))
    distances = Dict(pos => length(path) - i for (i, pos) in enumerate(path))
    cheats = find_cheats(distances, 20)
    println(count(((d, g),) -> d ≤ 2 && g ≥ 100, cheats))
    println(count(((d, g),) -> g ≥ 100, cheats))
end