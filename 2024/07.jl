function parse_line(line)
    target, numbers = split(line, ':')
    numbers = parse.(Int, split(numbers))

    return parse(Int, target), numbers
end

concat(n1, n2) = n1 * 10^ndigits(n2) + n2

function gen_all(numbers)
    n0, rest = Iterators.peel(numbers)
    res = Set{Int}([n0])
    sizehint!(res, 2^(length(numbers) - 1))
    for n in rest
        res = union(res .+ n, res .* n, concat.(res, n))
    end
    return res
end

is_valid(target, numbers) = target ∈ gen_all(numbers)

open(ARGS[1]) do file
    problems = parse_line.(readlines(file))
    println(sum(first, filter(splat(is_valid), problems)))
end
