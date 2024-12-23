const rep = ('T' => 'a', 'J' => 'b', 'Q' => 'c', 'K' => 'd', 'A' => 'e')
const rep_jokers = ('T' => 'a', 'J' => '1', 'Q' => 'c', 'K' => 'd', 'A' => 'e')
encode(hand; jokers=false) = replace(hand, (jokers ? rep_jokers : rep)...)

function score(hand; jokers=false)
    counts = Dict{Char,Int}()
    for c in hand
        counts[c] = get(counts, c, 0) + 1
    end
    if jokers
        n_jokers = pop!(counts, 'J', 0)
        count_values = isempty(counts) ? [0] : values(counts)
        type = 10 * (maximum(count_values) + n_jokers) - length(count_values)
    else
        type = 10 * maximum(values(counts)) - length(counts)
    end
    return (type, encode(hand, jokers=jokers))
end

function process(line)
    hand, bid = split(line)
    return hand, parse(Int, bid)
end

open(ARGS[1]) do file
    processed_lines = process.(readlines(file))
    hands, bids = first.(processed_lines), last.(processed_lines)
    scores = score.(hands, jokers=false)
    scores_jokers = score.(hands, jokers=true)
    part1 = sum(prod, zip(bids, invperm(sortperm(scores))))
    part2 = sum(prod, zip(bids, invperm(sortperm(scores_jokers))))
    println("Part one : ", part1)
    println("Part two : ", part2)
end