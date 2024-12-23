function parse_color(game, color)
    matches = eachmatch(Regex("(\\d+) $color"), game)
    return maximum(m -> parse(Int, first(m)), matches)
end

parse_game(game) = parse_color.(game, ("red", "green", "blue"))

open(ARGS[1]) do file
    games = parse_game.(readlines(file))
    part1 = sum(findall(t -> all(t .≤ (12, 13, 14)), games))
    part2 = sum(prod, games)

    println("Part one : ", part1)
    println("Part two : ", part2)
end