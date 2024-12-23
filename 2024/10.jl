Position = Tuple{Int,Int}
Summits = Set{Position}

store!(res, pos, val::Summits) = union!(get!(Set, res, pos), val)
store!(res, pos, val::Int) = setindex!(res, get(res, pos, 0) + val, pos)

function expand(dict::Dict{Position,T}, grid, level) where {T}
    res = Dict{Position,T}()
    for ((x, y), val) in dict
        for pos in [(x + 1, y), (x - 1, y), (x, y + 1), (x, y - 1)]
            if get(grid, pos, -1) == level
                store!(res, pos, val)
            end
        end
    end
    return res
end

init(::Type{Int}, pos) = 1
init(::Type{Summits}, pos) = Summits([pos])
score(val::Int) = val
score(val::Summits) = length(val)

open(ARGS[1]) do file
    grid = parse.(Int, reduce(hcat, collect.(readlines(file))))
    nines = Tuple.(findall(isequal(9), grid))
    for type in (Summits, Int)
        init_dict = Dict(nine => init(type, nine) for nine in nines)
        trailheads = foldl((d, l) -> expand(d, grid, l), 8:-1:0, init=init_dict)
        println(sum(score, values(trailheads)))
    end
end
