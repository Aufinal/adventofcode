function parse_rules(rules)
    orders = Dict{Int,Set{Int}}()
    for rule in eachsplit(rules, '\n')
        lhs, rhs = parse.(Int, split(rule, '|'))
        push!(get!(orders, lhs, Set{Int}()), rhs)
    end
    return orders
end

parse_update(u) = parse.(Int, split(u, ','))  

cmp_from_dict(dict) = return (x, y) -> y ∈ get(dict, x, Set{Int}())
is_sorted(dict) = return u -> issorted(u, lt=cmp_from_dict(dict))
sort_by_dict(dict) = return u -> sort(u, lt=cmp_from_dict(dict))

middle(v) = v[1 + length(v)÷2]

open(ARGS[1]) do file
    orders = parse_rules(readuntil(file, "\n\n"))
    updates = map(parse_update, readlines(file))
    println(sum(middle, filter(is_sorted(orders), updates)))
    println(sum(middle ∘ sort_by_dict(orders), filter(!is_sorted(orders), updates)))
end
