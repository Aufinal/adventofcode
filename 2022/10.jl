open(ARGS[1]) do file
    X = 1
    score = next_op = next_add = 0
    crt = zeros(Bool, 40, 6)

    for i in 0:239
        if i%40 == 20
            score += i * X
        end

        if i == next_op
            cmd, args... = split(readline(file))
            next_op += cmd == "noop" ? 1 : 2
            X += next_add
            next_add = cmd == "noop" ? 0 : parse(Int, args[1])
        end
        crt[i+1] = abs(i%40 - X) ≤ 1
    end

    println(score)
    for i in 1:6
        for j in 1:40
            print(crt[j, i] ? '█' : ' ')
        end
        println()
    end
end