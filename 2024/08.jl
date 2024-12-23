pairs(s) = [(a, b) for a in s for b in s if a < b]

function new_antennas(a1, a2, grid; all=true)
    dir = a1 .- a2
    max_len = minimum(size(grid) .÷ abs.(dir))
    range = all ? (-max_len:max_len) : (-1, 2)
    new = Set(@. a2 + k * dir for k in range)
    return filter(a -> checkbounds(Bool, grid, a...), new)
end

function initial_antennas(grid)
    antennas = Dict{Char,Vector{Tuple{Int,Int}}}()
    for I in findall(!isequal('.'), grid)
        freq = grid[I]
        push!(get!(antennas, freq, []), Tuple(I))
    end
    return antennas
end

open(ARGS[1]) do file
    grid = reduce(hcat, collect.(readlines(file)))
    init = initial_antennas(grid)
    all_antennas = union((new_antennas(a1, a2, grid) for as in values(init)
                          for (a1, a2) in pairs(as))...)
    println(length(all_antennas))
end
