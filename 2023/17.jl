struct Crucible
    pos::Tuple{Int,Int}
    dir::Tuple{Int,Int}
    steps_remaining::Int
end

turn((x, y)) = iszero(x) ? [(1, 0), (-1, 0)] : [(0, 1), (0, -1)]
function next_steps(c::Crucible)
    steps = [Crucible(c.pos .+ dir, dir, 3) for dir in turn(c.dir)]
    if !iszero(c.steps_remaining)
        push!(steps, Crucible(c.pos .+ c.dir, c.dir, c.steps_remaining - 1))
    end
    return steps
end

function solve(c::Crucible, field::AbstractMatrix{Int})
    visited
end

open(ARGS[1]) do file
    field = parse.(Int, hcat(collect.(eachline(file))...))
    c = Crucible((1, 1), (1, 0), 3)
    part1 = solve(c, field)
    println("Part 1 : $part1")
    # println("Part 2 : $part2")
end
