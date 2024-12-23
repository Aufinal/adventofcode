function count_wins((time, record))
    Δ = sqrt(time^2 - 4 * record)
    return floor(Int, (time + Δ) / 2) - ceil(Int, (time - Δ) / 2) + 1
end

open(ARGS[1]) do file
    raw_times, raw_records = readlines(file)
    times_list = parse.(Int, split(raw_times)[2:end])
    records_list = parse.(Int, split(raw_records)[2:end])
    full_time = parse(Int, filter(isdigit, raw_times))
    full_record = parse(Int, filter(isdigit, raw_records))

    part1 = prod(count_wins, zip(times_list, records_list))
    part2 = count_wins((full_time, full_record))
    println("Part one : ", part1)
    println("Part two : ", part2)
end