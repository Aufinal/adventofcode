function evolve(n)
    n = n ⊻ (n << 6) % (1 << 24)
    n = n ⊻ (n >> 5) % (1 << 24)
    n = n ⊻ (n << 11) % (1 << 24)
end

function evolve_arr(init, n)
    arr = zeros(Int, n + 1)
    arr[1] = init
    accumulate!((n, _) -> evolve(n), arr, arr)
    return arr
end

function seqs(arr)
    arr .%= 10
    diffs = diff(arr)
    d = Dict{NTuple{4,Int},Int}()
    for i in 5:lastindex(arr)
        get!(d, Tuple(@view diffs[i-4:i-1]), arr[i])
    end
    return d
end



open(ARGS[1]) do file
    # _, diffs = evolve_arr(123, 20)

    arrs = map(n -> evolve_arr(n, 2000), parse.(Int, eachline(file)))
    println(sum(last, arrs))
    seq_dicts = map(seqs, arrs)
    all_keys = union((Set(keys(d)) for d in seq_dicts)...)
    println([get(d, (-2, 1, -1, 3), 0) for d in seq_dicts])
    println(argmax(all_keys) do key
        sum(d -> get(d, key, 0), seq_dicts)
    end)
end