parseline(line::String) = parse.(Int, split(line))
test_diff(x) = 1 <= x <= 3

function is_valid(report)
    diffs = diff(report)
    return all(test_diff, diffs) || all(test_diff, -diffs)
end

dampened(report, idx) = is_valid(report[(begin:end) .!= idx])

function is_valid_dampened(report)
    diffs = diff(report)
    asc = findfirst(!test_diff, diffs)
    desc = findfirst(!test_diff, -diffs)
    if isnothing(asc) || isnothing(desc)
        return true
    else
        return any(dampened(report, idx) for idx in (asc, asc+1, desc, desc+1))
    end
end

open(ARGS[1]) do file
    lines = readlines(file)
    println(sum(is_valid ∘ parseline, lines))
    println(sum(is_valid_dampened ∘ parseline, lines))
end