function parse_line(line)
    node, left, right = String.(match(r"(\w+) = \((\w+), (\w+)\)", line))
    return node => (left, right)
end

next(tree, pos, c) = pos = c == 'L' ? tree[pos][1] : tree[pos][2]

function tree_find(tree, path, start, condition)
    cur_pos = start
    n_steps = 0
    for c in Iterators.cycle(path)
        n_steps += 1
        cur_pos = next(tree, cur_pos, c)
        condition(cur_pos) && (return n_steps)
    end
end

function find_cycle(tree, path, start, condition)
    cur_pos = start
    n_steps = 0
    visited = Dict{Tuple{Int,String},Int}()
    while true
        for (i, c) in enumerate(path)
            if haskey(visited, (i, cur_pos))
                cycle_start = visited[(i, cur_pos)]
                cycle_length = n_steps - cycle_start
                targets = [n for ((_, pos), n) in visited if n ≥ cycle_start && condition(pos)]
                return (cycle_length, cycle_start, targets)
            end
            visited[(i, cur_pos)] = n_steps
            n_steps += 1
            cur_pos = next(tree, cur_pos, c)
        end
    end
end

function chinese_remainder(remainders, moduli)
    Π = lcm(moduli...)
    sol = mod(sum(a * invmod(Π ÷ n, n) * (Π ÷ n) for (n, a) in zip(moduli, remainders)), Π)

    return sol, Π
end

function solve(lengths, min_sol, targets)
    sol, Π = chinese_remainder(lengths, targets)
    return sol + Π * ceil(Int, min_sol / Π)
end

open(ARGS[1]) do file
    path = readuntil(file, "\n\n")
    tree = Dict(parse_line.(eachline(file)))

    part1 = tree_find(tree, path, "AAA", isequal("ZZZ"))
    println("Part one : ", part1)

    start_nodes = filter(endswith('A'), collect(keys(tree)))
    cycles = collect(find_cycle(tree, path, start, endswith("Z")) for start in start_nodes)
    lengths, starts, target_lists = zip(cycles...) # don't do that for large arrays !!!
    min_steps = maximum(starts)
    part2 = minimum(t -> solve(lengths, min_steps, t), Iterators.product(target_lists...))
    println("Part two : ", part2)
end