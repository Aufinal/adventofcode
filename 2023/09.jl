function find_endpoints(list::Vector{Int})
    if allequal(list)
        return [list[1], list[1]]
    else
        @views f, l = find_endpoints(list[2:end] - list[1:length(list)-1])
        return [list[1] - f, list[end] + l]
    end
end

find_endpoints(list::String) = find_endpoints(parse.(Int, split(list)))

open(ARGS[1]) do file
    lines = readlines(file)
    part2, part1 = sum(find_endpoints, lines)

    println("Part 1 : $part1")
    println("Part 2 : $part2")
end