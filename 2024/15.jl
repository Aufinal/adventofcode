showcompact(a) = foreach(i -> println(join(a[:, i])), 1:size(a, 2))

const N = CartesianIndex(0, -1)
const E = CartesianIndex(1, 0)
const S = CartesianIndex(0, 1)
const W = CartesianIndex(-1, 0)
const directions = Dict('^' => N, '>' => E, 'v' => S, '<' => W)

function move1!(grid, pos, move)
    dir = directions[move]
    if grid[pos + dir] ==  '.'
        grid[pos] = '.'
        grid[pos + dir] = '@'
        return pos + dir
    elseif grid[pos + dir] == 'O'
        n = 2
        while grid[pos + n * dir] == 'O'
            n += 1
        end
        next_pos = pos + n * dir
        grid[next_pos] == '#' && return pos
        grid[next_pos] = 'O'
        grid[pos + dir] = '@'
        grid[pos] = '.'
        return pos + dir
    else
        return pos
    end
end

function push_horiz!(grid, box, dir)
    n = 2
    while grid[box + n * dir] ∈ ['[', ']']
        n += 1
    end
    grid[box + n * dir] == '#' && return false
    Imin, Imax = minmax(box + dir, box + n * dir)
    grid[Imin:Imax] = repeat(['[', ']'], n ÷ 2)
    return true
end

function push_vert!(grid, boxes, dir)
    test_walls = collect(I + k*E + dir for I in boxes for k in 0:1)
    test_boxes = collect(I + k*E + dir for I in boxes for k in -1:1)
    any(isequal('#'), grid[test_walls]) && return false
    new_boxes = test_boxes[findall(isequal('['), grid[test_boxes])]
    if isempty(new_boxes) || push_vert!(grid, new_boxes, dir)
        for I in boxes
            grid[I] = '.'
            grid[I + E] = '.'
            grid[I + dir] = '['
            grid[I + E + dir] = ']'
        end
        return true
    end
    return false
end

function push!(grid, box, dir)
    if dir ∈ (E, W)
        return push_horiz!(grid, box, dir)
    elseif grid[box] == '['
        return push_vert!(grid, [box], dir)
    else
        return push_vert!(grid, [box+W], dir)
    end
end

function move2!(grid, pos, move)
    dir = directions[move]
    if grid[pos + dir] ==  '.'
        grid[pos] = '.'
        grid[pos + dir] = '@'
        return pos + dir
    elseif grid[pos + dir] ∈ ['[', ']'] && push!(grid, pos+dir, dir)
        grid[pos] = '.'
        grid[pos + dir] = '@'
        return pos + dir
    else
        return pos
    end
end

score(I) = 100 * (I[2] - 1) + I[1] - 1

open(ARGS[1]) do file
    grid_str = readuntil(file, "\n\n")
    grid2_str = replace(grid_str, '#' => "##", 'O' => "[]", '.' => "..", '@' => "@.")
    grid = reduce(hcat, collect.(split(grid_str, '\n')))
    grid2 = reduce(hcat, collect.(split(grid2_str, '\n')))
    init = findfirst(isequal('@'), grid)
    init2 = findfirst(isequal('@'), grid2)
    moves = join(readlines(file))
    pos = foldl((p, m) -> move1!(grid, p, m), moves, init=init)
    println(sum(score, findall(isequal('O'), grid)))
    pos = foldl((p, m) -> move2!(grid2, p, m), moves, init=init2)
    println(sum(score, findall(isequal('['), grid2)))
end