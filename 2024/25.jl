match(key, lock) = all(≤(7), key + lock)


open(ARGS[1]) do file
    keys = []
    locks = []

    for pattern in split(read(file, String), "\n\n")
        matrix = reduce(hcat, collect.(split(pattern, "\n")))
        heights = count(isequal('#'), matrix, dims=2)
        if matrix[1, 1] == '#'
            push!(keys, heights)
        else
            push!(locks, heights)
        end
    end

    println(sum(splat(match), Iterators.product(keys, locks)))
end