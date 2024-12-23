open(ARGS[1]) do file
    score1 = 0
    score2 = 0
    for line in eachline(file)
        opp = line[1] - 'A' + 1
        me = line[3] - 'X' + 1

        score1 += me + 3 * mod(me - opp + 1, 3)
        score2 += 3 * me + mod(opp + me, 3) - 2
    end

    println(score1)
    println(score2)
end