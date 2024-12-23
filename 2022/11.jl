struct Monkey{T<:Function}
    items::Vector{Int}
    operation::T
    test_div::Int
    if_true::Int
    if_false::Int
end

function parse_monkey(str)
    lines = strip.(split(str, "\n"))
    starting_items = parse.(Int, split(chopprefix(lines[2], "Starting items: "), ", "))
    operation = eval(Meta.parse("old -> " * last(split(lines[3], " = "))))
    test_div = parse(Int, last(split(lines[4])))
    if_true = parse(Int, last(split(lines[5])))
    if_false = parse(Int, last(split(lines[6])))
    
    return Monkey(starting_items, operation, test_div, if_true, if_false)
end

function inspect!(monkey, monkeys, reduce_worry, modulo)
    for item in monkey.items
        worry = Base.invokelatest(monkey.operation, item)
        worry = reduce_worry ? worry ÷ 3 : worry % modulo
        to_monkey = iszero(worry % monkey.test_div) ? monkey.if_true : monkey.if_false
        push!(monkeys[to_monkey + 1].items, worry)
    end
    empty!(monkey.items)
end

function run_monkeys(monkeys, n_iter, reduce_worry)
    n_inspected = zeros(Int, length(monkeys))
    modulo = prod(monkey -> monkey.test_div, monkeys)
    for _ in 1:n_iter, (i, monkey) in enumerate(monkeys)
        n_inspected[i] += length(monkey.items)
        inspect!(monkey, monkeys, reduce_worry, modulo)
    end
    return prod(partialsort(n_inspected, 1:2, rev=true))
end

open(ARGS[1]) do file
    monkeys = parse_monkey.(split(read(file, String), "\n\n"))
    monkeys2 = deepcopy(monkeys)
    println(run_monkeys(monkeys, 20, true))
    println(run_monkeys(monkeys2, 10000, false))
end
