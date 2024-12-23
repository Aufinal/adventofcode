parse_pattern(pattern) = hcat(collect.(split(pattern))...)
mirror_size(pattern, mirror, dim) = min(size(pattern, dim) - mirror, mirror)

function get_mirror_indices(pattern, mirror, dim)
    l = mirror_size(pattern, mirror, dim)
    range1, range2 = mirror-l+1:mirror, mirror+l:-1:mirror+1
    return dim == 1 ? ((range1, Colon()), (range2, Colon())) : ((Colon(), range1), (Colon(), range2))
end

function count_diff(pattern, mirror, dim)
    idx1, idx2 = get_mirror_indices(pattern, mirror, dim)
    @views sum(pattern[idx1...] .!= pattern[idx2...])
end
find(pattern, dim; diff=0) = something(findfirst(m -> count_diff(pattern, m, dim) == diff, 1:size(pattern, dim)-1), 0)
score(pattern; diff=0) = 100 * find(pattern, 2; diff=diff) + find(pattern, 1; diff=diff)

open(ARGS[1]) do file
    patterns = parse_pattern.(split(read(file, String), "\n\n"))
    part1 = sum(score, patterns)
    part2 = sum(p -> score(p; diff=1), patterns)

    println("Part 1 : $part1")
    println("Part 2 : $part2")
end