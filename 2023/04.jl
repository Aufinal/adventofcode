parse_numbers(numbers) = parse.(Int, split(numbers))
score(n::Int) = iszero(n) ? 0 : 2^(n - 1)
score(c::String) = score(n_winners(c))

function n_winners(card::String)
    winning, mine = split(chopprefix(card, r"Card\s+\d+:"), "|") .|> parse_numbers
    return length(winning ∩ mine)
end

function total_cards(cards)
    card_counts = ones(Int, length(cards))
    for (i, card) in enumerate(cards)
        card_counts[i+1:i+n_winners(card)] .+= card_counts[i]
    end
    return sum(card_counts)
end

open(ARGS[1]) do file
    cards = readlines(file)
    part1 = sum(score, cards)
    part2 = total_cards(cards)

    println("Part one : ", part1)
    println("Part two : ", part2)
end