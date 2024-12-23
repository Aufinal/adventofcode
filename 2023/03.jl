struct PartSymbol
    x::Int
    y::Int
    symbol::Char
end

struct PartNumber <: Number
    x::UnitRange{Int}
    y::Int
    number::Int
end
number(p::PartNumber) = p.number

struct Line
    numbers::Set{PartNumber}
    symbols::Set{PartSymbol}
end
Line() = Line(Set(), Set())

extend(u::UnitRange{Int}) = (u.start-1):(u.stop+1)
isadjacent(p1::PartSymbol, p2::PartNumber) = p1.x ∈ extend(p2.x)
isadjacent(p1::PartNumber, p2::PartSymbol) = isadjacent(p2, p1)
isadjacent(p1::PartSymbol, p2::PartSymbol) = abs(p2.x - p1.x) ≤ 1
isadjacent(p1::PartNumber, p2::PartNumber) = !isdisjoint(p1.x, extend(p2.x))
isadjacent(p::Union{PartNumber, PartSymbol}) = Base.Fix2(isadjacent, p)

function parse_line((line_no, line_str))
    cur_number = 0
    x_prev = 0
    line = Line()
    for (x, c) in enumerate(line_str)
        if isdigit(c)
            cur_number = 10*cur_number + parse(Int, c)
        else
            if !iszero(cur_number)
                push!(line.numbers, PartNumber(x_prev+1:x-1, line_no, cur_number))
                cur_number = 0
            end
            x_prev = x
            if c != '.'
                push!(line.symbols, PartSymbol(x, line_no, c)) 
            end
        end
    end
    if !iszero(cur_number)
        push!(line.numbers, PartNumber(x_prev+1:length(line_str), line_no, cur_number))
    end
    return line
end

function build_adjacency(lines::Vector{Line})
    adj_dict = Dict{PartSymbol, Set{PartNumber}}()
    for (idx, line) in enumerate(lines)
        numbers = union((lines[i].numbers for i in max(idx-1, 1):min(idx+1, length(lines)))...)
        for symbol in line.symbols
            adj_dict[symbol] = filter(isadjacent(symbol), numbers)
        end
    end
    return adj_dict
end

open(ARGS[1]) do file
    lines = parse_line.(enumerate(eachline(file)))
    adj_dict = build_adjacency(lines)
    part1 = union(values(adj_dict)...) .|> number |> sum

    gears = filter(p -> p.first.symbol == '*' && length(p.second) == 2, adj_dict) |> values
    part2 = sum(g -> prod(number, g), gears)
    println("Part one : ", part1)
    println("Part two : ", part2)
end