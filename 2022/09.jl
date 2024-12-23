function follow(pos_h, pos_t)
    if maximum(abs.(pos_h .- pos_t)) ≤ 1
        return pos_t
    else
        return @. pos_t + sign(pos_h - pos_t)
    end
end

function do_path(lines, n_segments)
    directions = Dict("R" => (1, 0), "L" => (-1, 0), "U" => (0, 1), "D" => (0, -1))
    snake = fill((0, 0), n_segments)
    visited_positions = Set{Tuple{Int,Int}}()

    for line in lines
        dir, len = split(line)
        direction = directions[dir]
        for _ in 1:parse(Int, len)
            snake[1] = snake[1] .+ direction
            for segment in 2:n_segments
                snake[segment] = follow(snake[segment-1], snake[segment])
            end
            push!(visited_positions, snake[end])
        end
    end
    return length(visited_positions)
end

open(ARGS[1]) do file
    lines = readlines(file)
    println(do_path(lines, 2))
    println(do_path(lines, 10))
end