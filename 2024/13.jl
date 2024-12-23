function parse_problem(str)
    input = match(r"\+(\d+).*\+(\d+).*\+(\d+).*\+(\d+).*"s, str)
    goal = match(r"=(\d+).*=(\d+)", str)
    return parse.(Int, input.captures), parse.(Int, goal.captures)
end

solve((x1, y1, x2, y2), (x, y)) = (y2*x - x2*y, x1*y - y1*x)
det((x1, y1, x2, y2)) = x1*y2 - y1*x2

function solve_problem((input, goal))
    d = det(input)
    sol = solve(input, goal)
    if all(iszero, sol .% d)
        return (3 * sol[1] + sol[2]) ÷ d
    else
        return 0
    end
end

p2((i, g)) = (i, g .+ 10000000000000)

open(ARGS[1]) do file
    problems = parse_problem.(split(read(file, String), "\n\n"))
    println(sum(solve_problem, problems))
    println(sum(solve_problem ∘ p2, problems))
end