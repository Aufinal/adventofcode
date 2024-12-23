open(ARGS[1]) do file
    l1 = []
    l2 = []
    for line in eachline(file)
        a1, a2 = parse.(Int, split(line))
        append!(l1, a1)
        append!(l2, a2)
    end
    println(sum(abs, sort(l1) - sort(l2)))

    d = Dict()
    for x in l2
        d[x] = get(d, x, 0) + 1
    end
    println(sum(x -> x * get(d, x, 0), l1))
end