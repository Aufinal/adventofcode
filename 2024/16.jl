using DataStructures

const N = CartesianIndex(0, -1)
const E = CartesianIndex(1, 0)
const S = CartesianIndex(0, 1)
const W = CartesianIndex(-1, 0)
const turns = Dict(N => (E, W), S => (E, W), E => (N, S), W => (N, S))
PosDir = NTuple{2, CartesianIndex{2}}

function insert!(key, parent, score, queue, parents, scores)
    prev_score = get(scores, key, Inf)
    if score < prev_score
        scores[key] = score
        parents[key] = Set([parent])
        queue[key] = score
    elseif score == prev_score
        push!(parents[key], parent)
    end
end

function dijkstra(maze)
    queue = PriorityQueue{PosDir, Int}()
    start = (findfirst(isequal('S'), maze), E)
    parents = Dict{PosDir, Set{PosDir}}()
    scores = Dict{PosDir, Int}([start => 0])
    enqueue!(queue, start, 0)
    while !isempty(queue)
        ((pos, dir), score) = dequeue_pair!(queue)
        maze[pos] == 'E' && return ((pos, dir), parents, score)
        if maze[pos + dir] != '#'
           insert!((pos+dir, dir), (pos, dir), score+1, queue, parents, scores)
        end
        for new_dir in turns[dir]
            insert!((pos, new_dir), (pos, dir), score+1000, queue, parents, scores)
        end
    end
end

function parents_union(parents, pos)
    to_add = Set([pos])
    tiles = Set{CartesianIndex{2}}()
    while !isempty(to_add)
        union!(tiles, pos for (pos, dir) in to_add)
        to_add = union((get(parents, t, Set()) for t in to_add)...)
    end
    return tiles
end

open(ARGS[1]) do file
    maze = reduce(hcat, collect.(readlines(file)))
    (pos_end, parents, score_end) = dijkstra(maze)
    println(score_end)
    tiles = parents_union(parents, pos_end)
    println(length(tiles))
end