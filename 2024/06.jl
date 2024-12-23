Base.get(a::Matrix{T}, c::Complex{Int64}, default::T) where {T} = get(a, reim(c), default)
ind2com(idx) = complex(Tuple(idx)...)

function run_guard(grid, start_pos)
    pos = start_pos
    dir = -im
    visited = Set{Complex{Int}}()

    while checkbounds(Bool, grid, real(pos), imag(pos))
        push!(visited, pos)
        while get(grid, pos + dir, '.') == '#'
            dir *= im
        end
        pos += dir
    end
    return length(visited)
end

function detect_cycle(grid, new_obstacle, start_pos)
    new_obstacle = ind2com(new_obstacle)
    pos = start_pos
    dir = -im
    visited = Set{Tuple{Complex{Int},Complex{Int}}}()
    sizehint!(visited, 10000)
    while checkbounds(Bool, grid, real(pos), imag(pos))
        (pos, dir) ∈ visited && return true
        push!(visited, (pos, dir))
        while pos + dir == new_obstacle || get(grid, pos + dir, '.') == '#'
            dir *= im
        end
        pos += dir
    end
    return false
end

find_all_cycles(grid, start_pos) = sum(obs -> detect_cycle(grid, obs, start_pos), findall(isequal('.'), grid))

open(ARGS[1]) do file
    grid = reduce(hcat, collect.(readlines(file)))
    start_pos = ind2com(findfirst(isequal('^'), grid))
    @time part1 = run_guard(grid, start_pos)
    @time part2 = find_all_cycles(grid, start_pos)
    println(part1)
    println(part2)
end
