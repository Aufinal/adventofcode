using DataStructures
const Box = OrderedDict{String,Int}

hash_step(h::Int, c::Char) = 17 * (h + Int(c)) % 256
full_hash(str::AbstractString) = foldl(hash_step, str, init=0)

function operate!(boxes, str)
    ops = split(str, ['=', '-']; keepempty=false)
    if length(ops) == 2
        label, focal = ops
        boxes[full_hash(label)+1][label] = parse(Int, focal)
    else
        label = ops[1]
        delete!(boxes[full_hash(label)+1], label)
    end
end

function fill_boxes(operations)
    boxes = [Box() for _ in 1:256]
    foreach(op -> operate!(boxes, op), operations)
    return boxes
end

sum_box(box) = sum(prod, enumerate(values(box)), init=0)
sum_boxes(boxes) = sum(((i, b),) -> i * sum_box(b), enumerate(boxes))

open(ARGS[1]) do file
    line = readchomp(file)
    operations = split(line, ',')
    part1 = sum(full_hash, operations)
    boxes = fill_boxes(operations)
    part2 = sum_boxes(boxes)

    println("Part 1 : $part1")
    println("Part 2 : $part2")
end