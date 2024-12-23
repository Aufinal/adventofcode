function fill_grid!(file, grid)
    lineno = 0
    for line in eachline(file)
        grid[lineno+=1, :] = parse.(Int, collect(line))
    end
    return grid
end

open(ARGS[1]) do file
    n = 99
    grid = zeros(Int, n, n)
    fill_grid!(file, grid)
    can_see = zeros(Int, size(grid))
    scores = ones(Int, size(grid))
    for i in 1:n, j in 1:n
        directions = ([0, 1], [1, 0], [-1, 0], [0, -1])
        for direction in directions
            pos = [i, j] + direction
            score = 1
            while checkbounds(Bool, grid, pos...) && grid[pos...] < grid[i, j]
                score += 1
                pos += direction
            end
            if !checkbounds(Bool, grid, pos...)
                can_see[i, j] = 1
                score -= 1
            end
            scores[i, j] *= score
        end
    end

    println(sum(can_see))
    println(maximum(scores[2:end-1, 2:end-1]))
end