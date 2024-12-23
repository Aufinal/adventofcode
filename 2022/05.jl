function move!(qty, from, to, stacks, rev=true)
    trans = rev ? reverse : identity
    l = length(stacks[from])
    append!(stacks[to], trans(splice!(stacks[from], l-qty+1:l)))
end

open(ARGS[1]) do file
    stacks = Vector{Vector{Char}}([[] for i in 1:9])
    while (line = readline(file)) != ""
        for i in 1:9
            isletter(line[4i-2]) && pushfirst!(stacks[i], line[4i-2])
        end
    end
    stacks2 = deepcopy(stacks)

    moves = map(line -> filter(!isnothing, tryparse.(Int, split(line))), eachline(file))
    foreach(move -> move!.(move..., [stacks, stacks2], [true, false]), moves)
    println(join(last.(stacks)))
    println(join(last.(stacks2)))
end