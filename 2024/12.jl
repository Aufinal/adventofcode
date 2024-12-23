using DataStructures
Position = CartesianIndex{2}

const N = CartesianIndex(1, 0)
const E = CartesianIndex(0, 1)
const S = CartesianIndex(-1, 0)
const W = CartesianIndex(0, -1)
const directions = [N, E, S, W]
const coins = [(N, E), (E, S), (S, W), (W, N)]

neighbors(I) = [I + d for d in directions]
good_neighbors(I, grid) = filter(J -> get(grid, J, '.') == grid[I], neighbors(I))
is_convex_coin(I, grid, (d1, d2)) = grid[I] != get(grid, I + d1, '.') && grid[I] != get(grid, I + d2, '.')
is_concave_coin(I, grid, (d1, d2)) = (grid[I] == get(grid, I + d1, '.') == get(grid, I + d2, '.')
                                      &&
                                      grid[I] != grid[I+d1+d2])
is_coin(I, grid, c) = is_concave_coin(I, grid, c) || is_convex_coin(I, grid, c)
count_coins(I::Position, grid) = count(c -> is_coin(I, grid, c), coins)

function explore_region(grid, start_pos)
    region = Set([start_pos])
    ns = good_neighbors(start_pos, grid)
    perimeter = 4 - length(ns)
    area = 1
    sides = count_coins(start_pos, grid)
    queue = Queue{Position}()
    foreach(x -> enqueue!(queue, x), good_neighbors(start_pos, grid))
    while !isempty(queue)
        I = dequeue!(queue)
        I ∈ region && continue
        push!(region, I)
        ns = good_neighbors(I, grid)
        perimeter += 4 - length(ns)
        area += 1
        sides += count_coins(I, grid)
        foreach(x -> enqueue!(queue, x), good_neighbors(I, grid))
    end

    return (region, perimeter, area, sides)
end

function scores(grid)
    to_visit = Set(CartesianIndices(grid))
    part1 = 0
    part2 = 0
    while !isempty(to_visit)
        pos = pop!(to_visit)
        (region, perimeter, area, sides) = explore_region(grid, pos)
        setdiff!(to_visit, region)
        part1 += perimeter * area
        part2 += sides * area
    end

    return (part1, part2)
end

open(ARGS[1]) do file
    grid = reduce(hcat, collect.(readlines(file)))
    part1, part2 = scores(grid)
    println(part1)
    println(part2)
end