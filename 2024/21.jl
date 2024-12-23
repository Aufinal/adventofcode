const coords_num = Dict([
    '0' => (1, 0),
    'A' => (2, 0),
    ('0' + i => ((i + 2) % 3, 1 + (i - 1) ÷ 3) for i in 1:9)...
])
const coords_arr = Dict([
    '^' => (1, 1),
    '>' => (2, 0),
    '<' => (0, 0),
    'v' => (1, 0),
    'A' => (2, 1)
])

const dx_dict = Dict([-1 => '<', 0 => 'A', 1 => '>'])
const dy_dict = Dict([-1 => 'v', 0 => 'A', 1 => '^'])

function shortest(p1, p2, best_paths, forbidden)
    dx, dy = p2 .- p1
    cx = dx_dict[sign(dx)]
    cy = dy_dict[sign(dy)]

    b1 = best_paths[('A', cx)] + best_paths[(cx, cy)] + best_paths[(cy, 'A')]
    b2 = best_paths[('A', cy)] + best_paths[(cy, cx)] + best_paths[(cx, 'A')]
    presses = abs(dx) + abs(dy) - 2
    if p1 .+ (dx, 0) == forbidden
        return b2 + presses
    elseif p1 .+ (0, dy) == forbidden
        return b1 + presses
    else
        return min(b1, b2) + presses
    end
end
shortest_arr(c1, c2, best_paths) = shortest(coords_arr[c1], coords_arr[c2], best_paths, (0, 1))
shortest_num(c1, c2, best_paths) = shortest(coords_num[c1], coords_num[c2], best_paths, (0, 0))

function update(best_paths)
    return Dict((c1, c2) => shortest_arr(c1, c2, best_paths) for c1 in keys(coords_arr) for c2 in keys(coords_arr))
end

type(code, best_paths) = last(foldl(((key, acc), new_key) -> (new_key, acc + shortest_num(key, new_key, best_paths)), code, init=('A', 0)))
score(code, best_paths) = type(code, best_paths) * parse(Int, code[1:end-1])

open(ARGS[1]) do file
    best_paths = Dict((c1, c2) => 1 for c1 in keys(coords_arr) for c2 in keys(coords_arr))
    for _ in 1:25
        best_paths = update(best_paths)
    end

    println(sum(x -> score(x, best_paths), readlines(file)))
end