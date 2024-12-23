struct Problem
    string::String
    constraints::Vector{Int}
end
rep(p::Problem) = p.string * join(p.constraints, ',')

function parse_line(line)
    str, constraint_str = split(line)
    constraints = parse.(Int, split(constraint_str, ','))
    return Problem(str, constraints)
end

can_place(p::Problem, n::Int) = length(p.string) ≥ n && all(∈("#?"), p.string[1:n]) && get(p.string, n+1, '.') ∈ ".?"
can_place(p::Problem) = can_place(p, p.constraints[1])
place(p::Problem, n::Int) = Problem(p.string[n+2:end], p.constraints[2:end])
place(p::Problem) = place(p, p.constraints[1])
dont_place(p::Problem) = Problem(p.string[2:end], p.constraints)

quintuple(p::Problem) = Problem(join(repeat([p.string], 5), '?'), repeat(p.constraints, 5))

function solve(p::Problem)
    function mem_solve!(mem::Dict{String, Int}, p::Problem)
        get!(mem, rep(p)) do 
            isempty(p.string) && return isempty(p.constraints)
            isempty(p.constraints) && return !any(isequal('#'), p.string)
            res = 0
            if can_place(p)
                res += mem_solve!(mem, place(p))
            end
            if startswith(p.string, ['?', '.'])
                res += mem_solve!(mem, dont_place(p))
            end
            res
        end
    end
    mem_solve!(Dict{String, Int}(), p)
end

open(ARGS[1]) do file
    problems = parse_line.(eachline(file))
    part1 = sum(solve, problems)
    part2 = sum(solve, quintuple.(problems))
    println("Part 1 : $part1")
    println("Part 2 : $part2")
end