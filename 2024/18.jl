using DataStructures

const grid_size = 71
const n_bytes = 1024

parse_byte(line) = CartesianIndex((1 .+ parse.(Int, split(line, ',')))...)
const directions = [(1, 0), (-1, 0), (0, 1), (0, -1)]
manhattan(x, y) = sum(abs, x .- y)

function Astar(grid)
    start, exit = (1, 1), size(grid)
    queue = PriorityQueue{NTuple{2,Int},Int}()
    distances = Dict{NTuple{2,Int},Int}(start => 0)
    enqueue!(queue, start => 0)

    while !isempty(queue)
        pos = dequeue!(queue)
        pos == exit && return distances[pos]
        for dir in directions
            new_pos = pos .+ dir
            new_dist = distances[pos] + 1
            if iszero(get(grid, new_pos, 1)) && new_dist < get(distances, new_pos, Inf)
                distances[new_pos] = new_dist
                queue[new_pos] = new_dist + manhattan(new_pos, exit)
            end
        end
    end
end

function dichotomy(bytes)
    grid = zeros(Int, (grid_size, grid_size))
    low, high = firstindex(bytes), lastindex(bytes)
    while high > low + 1
        cur = (high + low) ÷ 2
        grid[bytes[(cur+1):end]] .= 0
        grid[bytes[1:cur]] .= 1
        low, high = isnothing(Astar(grid)) ? (low, cur) : (cur, high)
    end
    return Tuple(bytes[high]) .- 1
end

open(ARGS[1]) do file
    grid = zeros(Int, (grid_size, grid_size))
    bytes = parse_byte.(readlines(file))
    grid[bytes[begin:n_bytes]] .= 1
    println(Astar(grid))
    println(dichotomy(bytes))
end