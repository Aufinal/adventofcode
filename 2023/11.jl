line_to_vec(line) = collect(line) .== '#'
sum_dist(v) = sum(abs(x-y) for x in v for y in v) ÷ 2
expand(x, offset, multiplier) = x + multiplier * offset[x]
sum_expand(x, offset, multiplier) = expand(x, offset, multiplier) |> sum_dist 

open(ARGS[1]) do file
    universe = hcat(line_to_vec.(eachline(file))...)
    empty_cols = cumsum(vec(.!any(universe, dims=1)))
    empty_rows = cumsum(vec(.!any(universe, dims=2)))
    base_galaxies = Tuple.(findall(universe))
    x, y = first.(base_galaxies), last.(base_galaxies)
    part1 = sum_expand(x, empty_rows, 2) + sum_expand(y, empty_cols, 2)
    part2 = sum_expand(x, empty_rows, 10^6) + sum_expand(y, empty_cols, 10^6)
    println("Part 1 : $part1")
    println("Part 2 : $part2")
end