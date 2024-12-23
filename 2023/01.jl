const numbers = ["one","two","three","four","five","six","seven","eight","nine"]

function calibration_1(line)
    digits = filter(isdigit, collect(line))
    return parse(Int, first(digits) * last(digits)) 
end

function calibration_2(line)
    regex = Regex(join(numbers, '|') * "|[0-9]")
    m = collect(eachmatch(regex, line, overlap=true))
    return 10 * convert_str(first(m).match) + convert_str(last(m).match)
end

convert_str(s) = something(tryparse(Int, s), findfirst(isequal(s), numbers))

open(ARGS[1]) do file
    lines = readlines(file)
    part1 = sum(calibration_1, lines)
    part2 = sum(calibration_2, lines)

    println("Part one : ", part1)
    println("Part two : ", part2)
end