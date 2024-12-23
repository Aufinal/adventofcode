using Memoization

@memoize function make(pattern, towels)
    isempty(pattern) && return 1
    prefixes = filter(t -> startswith(pattern, t), towels)
    return sum(t -> make(pattern[length(t)+1:end], towels), prefixes; init=0)
end

open(ARGS[1]) do file
    towels = split(readuntil(file, "\n\n"), ", ")
    res = map(p -> make(p, towels), eachline(file))
    println(sum(!iszero, res))
    println(sum(res))
end