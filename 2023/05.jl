const Range = UnitRange{Int}
const Rule = Pair{Range,Int}
const Map = Vector{Rule}

apply(input::Range, (source, shift)::Rule) = (input ∩ source) .+ shift
apply(input::Range, m::Map) = filter(!isempty, apply.(Ref(input), m))
apply(input::Vector{Range}, m::Map) = vcat(apply.(input, Ref(m))...)
apply(input::Vector{Range}, mv::Vector{Map}) = reduce(apply, mv, init=input)

function parse_range(r_str)
    (dest, source_start, source_len) = parse.(Int, split(r_str))
    return source_start:source_start+source_len-1 => dest - source_start
end

function parse_map(m_str)
    map = parse_range.(split(m_str, "\n", keepempty=false)[2:end])
    min_range = minimum(x -> x.first.start, map)
    max_range = maximum(x -> x.first.stop, map)
    push!(map, 0:min_range-1 => 0, max_range+1:typemax(Int) => 0)
    return map
end

function parse_file(file_str)
    seed_str, map_strs... = split(file_str, "\n\n")
    seeds = parse.(Int, split(seed_str)[2:end])
    maps = parse_map.(map_strs)
    return seeds, maps
end

open(ARGS[1]) do file
    seeds, maps = parse_file(read(file, String))
    init1 = [seed:seed for seed in seeds]
    init2 = [start:start+shift for (start, shift) in Iterators.partition(seeds, 2)]
    part1 = minimum(minimum, apply(init1, maps))
    part2 = minimum(minimum, apply(init2, maps))

    println("Part one : ", part1)
    println("Part two : ", part2)
end
