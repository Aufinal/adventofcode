function contains((a, b, c, d))
    return (a ≤ c && d ≤ b) || (c ≤ a && b ≤ d)
end

function overlaps((a, b, c, d))
    return c ≤ b && a ≤ d
end

open(ARGS[1]) do file
    scores = sum(eachline(file)) do line
        shifts = parse.(Int, split(line, ['-', ',']))
        [contains(shifts), overlaps(shifts)]
    end

    println(scores)
end