const directions = ((1, 0), (-1, 0), (0, 1), (0, -1))
const connections = Dict(
    '|' => [(1, 0), (-1, 0)],
    '-' => [(0, 1), (0, -1)],
    'J' => [(1, 0), (0, 1)],
    'F' => [(-1, 0), (0, -1)],
    'L' => [(1, 0), (0, -1)],
    '7' => [(-1, 0), (0, 1)],
    '.' => []
)

new_direction(pipe, direction) = direction == pipe[1] ? .-pipe[2] : .-pipe[1]
check_pipe(field, pos, dir) = checkbounds(Bool, field, pos...) && dir ∈ connections[field[pos...]]
find_pipe(field, pos) = directions[findfirst(dir -> check_pipe(field, pos .+ dir, dir), directions)]
function make_step(field, pos, dir)
    newdir = new_direction(connections[field[pos...]], dir)
    return pos .+ newdir, newdir
end

function build_fence(field, start)
    fence = Set{Tuple{Int,Int}}([start])
    dir = find_pipe(field, start)
    cur_pos, cur_dir = start .+ dir, dir
    while cur_pos != start
        push!(fence, cur_pos)
        cur_pos, cur_dir = make_step(field, cur_pos, cur_dir)
    end
    return fence
end

function outside(field, fence)
    inside = 0
    total_inside = 0
    closing_char = nothing
    open_close = Dict('7' => 'L', 'F' => 'J')
    for (ind, val) in pairs(field)
        if Tuple(ind) ∉ fence
            total_inside += inside
        elseif val == '-' || val == closing_char
            inside = 1 - inside
        end
        closing_char = get(open_close, val, closing_char)
    end
    return total_inside
end

open(ARGS[1]) do file
    field = vcat(reshape.(collect.(eachline(file)), 1, :)...)
    start = Tuple(findfirst(isequal('S'), field))
    fence = build_fence(field, start)
    part1 = length(fence) ÷ 2
    part2 = outside(field, fence)

    println("Part 1 : $part1")
    println("Part 2 : $part2")
end