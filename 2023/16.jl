struct Beam
    pos::Tuple{Int,Int}
    dir::Tuple{Int,Int}
end

function turn_split(b::Beam, c::Char)
    if c == '-' && b.dir[2] == 0
        return [Beam(b.pos, (0, 1)), Beam(b.pos, (0, -1))]
    elseif c == '|' && b.dir[1] == 0
        return [Beam(b.pos, (1, 0)), Beam(b.pos, (-1, 0))]
    elseif c == '/'
        return [Beam(b.pos, (-b.dir[2], -b.dir[1]))]
    elseif c == '\\'
        [Beam(b.pos, (b.dir[2], b.dir[1]))]
    else
        return [b]
    end
end
turn_split(b::Beam, field::AbstractMatrix{Char}) = turn_split(b, field[b.pos...])

function mark!(visited, (old_x, old_y), (new_x, new_y))
    range_x, range_y = range(minmax(old_x, new_x)...), range(minmax(old_y, new_y)...)
    union!(visited, Iterators.product(range_x, range_y))
end

function advance!(b::Beam, visited, field::AbstractMatrix{Char})
    dim, perp = iszero(b.dir[1]) ? (1, 2) : (2, 1)
    find_func = b.dir[perp] == -1 ? findprev : findnext
    next_idx = find_func(!isequal('.'), selectdim(field, dim, b.pos[dim]), b.pos[perp] + b.dir[perp])
    some_idx = something(next_idx, b.dir[perp] == -1 ? 1 : size(field, dim))
    new_pos = dim == 1 ? (b.pos[1], some_idx) : (some_idx, b.pos[2])
    mark!(visited, b.pos, new_pos)

    return isnothing(next_idx) ? nothing : Beam(new_pos, b.dir)
end

function one_step!(beams, visited, field)
    turned_beams = vcat(turn_split.(beams, Ref(field))...)
    return filter(!isnothing, advance!.(turned_beams, Ref(visited), Ref(field)))
end

function simulate(beam, field)
    beams = [beam]
    memory = Set{Beam}()
    visited = Set{Tuple{Int,Int}}()
    while !isempty(beams)
        union!(memory, beams)
        beams = filter(∉(memory), one_step!(beams, visited, field))
    end
    return length(visited)
end

function select_dim(field, dir, dim)
    n = size(field, dim)
    if dir[dim] == 0
        return 1:n
    else
        return [dir[dim] == 1 ? 1 : n]
    end
end
select_side(field, dir) = Iterators.product(select_dim(field, dir, 1), select_dim(field, dir, 2))
starting_beams(field) = [Beam(pos, dir) for dir in [(0, 1), (0, -1), (1, 0), (-1, 0)] for pos in select_side(field, dir)]

open(ARGS[1]) do file
    field = vcat(reshape.(collect.(eachline(file)), 1, :)...)
    start_beams = starting_beams(field)
    part1 = simulate(Beam((1, 1), (0, 1)), field)
    part2 = maximum(b -> simulate(b, field), start_beams)
    println("Part 1 : $part1")
    println("Part 2 : $part2")
end
