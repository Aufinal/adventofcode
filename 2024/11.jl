function update(stone)
    iszero(stone) && return (1,)
    n = ndigits(stone)
    return iseven(n) ? divrem(stone, 10^(n÷2)) : (stone * 2024,)
end

function update_stones(stones)
    res = Dict{Int, Int}()
    for (stone, c) in stones
        for new_stone in update(stone)
            res[new_stone] = get(res, new_stone, 0) + c
        end
    end
    return res
end

iterated(f, n) = x -> foldl(|>, Iterators.repeated(f, n), init=x)

open(ARGS[1]) do file
    stones = parse.(Int, split(readline(file)))
    stones = Dict(stone => 1 for stone in stones)
    part1_stones = iterated(update_stones, 25)(stones)
    part2_stones = iterated(update_stones, 50)(part1_stones)
    println(sum(values(part1_stones)))
    println(length(part2_stones))
    println(sum(values(part2_stones)))
end