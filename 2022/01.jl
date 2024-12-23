open(ARGS[1]) do file
    curr = 0
    largest = zeros(Int, 3)

    for line in eachline(file)
        if isempty(line)
            (min, idx) = findmin(largest)
            if curr > min
                largest[idx] = curr
            end

            curr = 0
        else
            curr += parse(Int, line)
        end
    end

    println("Part one : ", maximum(largest))
    println("Part two : ", sum(largest))
end