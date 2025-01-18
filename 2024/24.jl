const functions = Dict("OR" => |, "AND" => &, "XOR" => ⊻)

function parse_init(line)
    var, val = split(line, ": ")
    return var => parse(Int, val)
end

function parse_rule(line)
    lhs, rhs = split(line, " -> ")
    return rhs => Tuple(split(lhs))
end

function compute(var, inits, rules, memory)
    haskey(inits, var) && return inits[var]
    get!(memory, var) do
        lhs, fun, rhs = rules[var]
        return functions[fun](compute(lhs, inits, rules, memory), compute(rhs, inits, rules, memory))
    end
end

iseq(t1, t2) = t1 == t2 || t1 == reverse(t2)
is_partial((x, op), (x2, op2, y2)) = (op == op2) && (x == x2 || x == y2)
find_partial(rules, partial) = findfirst(r -> is_partial(partial, r), rules)
other(z, (x, op, y)) = (z == x) ? y : x

twopad(x) = lpad(string(x), 2, '0')

function build_adder(rules, n_bits)
    swaps = []
    swap!(x, y) = begin
        append!(swaps, (x, y))
        (rules[x], rules[y]) = (rules[y], rules[x])
    end

    sums_inp = fill("", n_bits + 1)
    carries_inp = fill("", n_bits + 1)

    for (u, (x, op, y)) in rules
        if x[2:3] == y[2:3]
            n = tryparse(Int, x[2:3])
            isnothing(n) && continue
            if op == "XOR"
                sums_inp[n+1] = u
            else
                carries_inp[n+1] = u
            end
        end
    end


    for j in 2:n_bits
        is_ok = false
        while !is_ok
            c_mid = find_partial(rules, (sums_inp[j], "AND"))
            c_out = find_partial(rules, (carries_inp[j], "OR"))
            z_out = "z$(twopad(j))"
            theory = (sums_inp[j+1], "XOR", c_out)
            if isnothing(c_out)
                # carries_inp[j] is wrong
                p = find_partial(rules, (c_mid, "OR"))
                true_carry = other(c_mid, rules[p])
                swap!(true_carry, carries_inp[j])
                carries_inp[j] = true_carry
            elseif !iseq(rules[z_out], theory)
                # c_out or z_out wrong
                p = find_partial(rules, (sums_inp[j+1], "XOR"))
                if !isnothing(p)
                    true_cout = other(sums_inp[j+1], rules[p])
                    if true_cout == c_out
                        # z_out wrong
                        swap!(p, z_out)
                    else
                        # c_out wrong
                        swap!(c_out, true_cout)
                    end
                else
                    # sums_inp[j+1] is wrong
                    p = find_partial(rules, (c_out, "XOR"))
                    true_sum = other(c_out, rules[p])
                    swap!(true_sum, sums_inp[j+1])
                    sums_inp[j+1] = true_sum
                end
            else
                is_ok = true
            end
        end
    end
    println(join(sort(unique(swaps)), ','))
end

open(ARGS[1]) do file
    inits = Dict(parse_init.(split(readuntil(file, "\n\n"), "\n")))
    rules = Dict(parse_rule.(readlines(file)))
    n_bits = length(inits) ÷ 2 - 1
    build_adder(rules, n_bits)

    # zs = sort(collect(filter(startswith('z'), keys(rules))), rev=true)
    # res = join(map(z -> compute(z, inits, rules, Dict()), zs))

    # println(parse(Int, res, base=2))
end