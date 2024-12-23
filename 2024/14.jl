function parse_robot(line)
    m = match(r"p=(\d+),(\d+) v=([+-]?\d+),([+-]?\d+)", line)
    x1, x2, v1, v2 = parse.(Int, m.captures)
    return (x1, x2), (v1, v2)
end

run_for((x, v), size, n_steps) = (@. mod(x + n_steps * v, size), v)
run_for(rs::Vector, size, n_steps) = map(r -> run_for(r, size, n_steps), rs)

function count_quadrants(robots, (n, m))
    counts = [0, 0, 0, 0]
    for ((x, y), _) in robots
        (2x == n-1 || 2y == m-1) && continue
        counts[2 * (2x > n) + (2y > m) + 1] += 1
    end
    return prod(counts)
end

function display_board(robots, size)
    grid = zeros(Int, size)
    for ((x, y), _) in robots
        grid[x+1, y+1] += 1
    end
    n, m = size
    for y in 1:m
        for x in 1:n
            print(iszero(grid[x, y]) ? ' ' : '█')
        end
        println()
    end
end

function vars(robots)
    ms = sum(r -> collect(r[1]), robots) / length(robots)
    msq = sum(r -> collect(r[1].^2), robots) / length(robots)
    return msq - ms.^2
end

function christmas_tree(robots, size)
    rcopy = copy(robots)
    (m, n) = size
    mp = maximum(size)
    xs = zeros(mp)
    ys = zeros(mp)
    for i in 1:mp
        robots = run_for(robots, size, 1)
        xs[i], ys[i] = vars(robots)
    end
    a, b = argmin(xs), argmin(ys)
    sol = mod(a * invmod(n, m) * n + b * invmod(m, n) * m, m * n)
    robots = run_for(rcopy, size, sol)
    display_board(robots, size)
    println(sol)
end

open(ARGS[1]) do file
    robots = parse_robot.(eachline(file))
    size = (101, 103)
    println(count_quadrants(run_for(robots, size, 100), size))
    christmas_tree(robots, size)
end