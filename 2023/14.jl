function tilt!(v::AbstractVector{Char}, dir)
    n = length(v)
    iter_range = dir == 1 ? (1:n) : (n:-1:1)
    cur_place = first(iter_range)
    for i in iter_range
        if v[i] == '#'
            cur_place = i + dir
        elseif v[i] == 'O'
            v[i] = '.'
            v[cur_place] = 'O'
            cur_place += dir
        end
    end
end
tilt!(field::Matrix{Char}, dim, dir) = foreach(i -> tilt!(selectdim(field, dim, i), dir), 1:size(field, dim))
cycle!(field::Matrix{Char}) = foreach(dir -> tilt!(field, dir...), [(1, 1), (2, 1), (1, -1), (2, -1)])
weight(field::Matrix{Char}) = sum(x -> size(field, 2) - x[2] + 1, findall(isequal('O'), field))

function run_cycles(field, n_cycles)
    memory = Vector{Matrix{Char}}()
    cur_field = field
    idx = nothing
    while isnothing(idx)
        push!(memory, cur_field)
        cur_field = copy(cur_field)
        cycle!(cur_field)
        idx = findfirst(isequal(cur_field), memory)
    end
    nth_cycle = idx + (n_cycles - idx + 1) % (length(memory) - idx + 1)
    return weight(memory[nth_cycle])
end

open(ARGS[1]) do file
    field = hcat(collect.(eachline(file))...)
    field_copy = copy(field)
    tilt!(field_copy, 1, 1)
    part1 = weight(field_copy)
    part2 = run_cycles(field, 1000000000)

    println("Part 1 : $part1")
    println("Part 2 : $part2")
end