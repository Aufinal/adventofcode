function priority(c)
    return islowercase(c) ? c - 'a' + 1 : c - 'A' + 27
end

open(ARGS[1]) do file
    score1 = 0
    score2 = 0

    for lines in Iterators.partition(eachline(file), 3)
        score1 += sum(lines) do line
            h = length(line) ÷ 2
            sum(priority, intersect(line[begin:h], line[h+1:end]))
        end
        score2 += sum(priority, intersect(lines...))
    end

    println(score1)
    println(score2)
end