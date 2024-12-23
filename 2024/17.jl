mutable struct Computer
    program::Vector{Int}
    registers::Vector{Int}
    pointer::Int
    output::Vector{Int}
    Computer(program, registers) = new(program, registers, 0, [])
end

get(c::Computer, i::Int) = c.registers[i]
get_op(c::Computer) = c.program[c.pointer+=1]
set!(c::Computer, i::Int, v::Int) = setindex!(c.registers, v, i)
combo(c::Computer, o::Int) = o ≤ 3 ? o : get(c, o - 3)
adv(c, o) = set!(c, 1, get(c, 1) ÷ 2^combo(c, o))
bdv(c, o) = set!(c, 2, get(c, 1) ÷ 2^combo(c, o))
cdv(c, o) = set!(c, 3, get(c, 1) ÷ 2^combo(c, o))
bxl(c, o) = set!(c, 2, get(c, 2) ⊻ o)
bst(c, o) = set!(c, 2, combo(c, o) % 8)
jnz(c, o) = iszero(get(c, 1)) ? nothing : setfield!(c, :pointer, o)
bxc(c, _) = set!(c, 2, get(c, 2) ⊻ get(c, 3))
out(c, o) = push!(c.output, combo(c, o) % 8)

const opcodes = [adv, bxl, bst, jnz, bxc, out, bdv, cdv]
ok(c::Computer) = checkbounds(Bool, c.program, c.pointer + 1)
advance!(c::Computer) = opcodes[get_op(c)+1](c, get_op(c))

function run!(c::Computer)
    while ok(c)
        advance!(c)
    end
    return c.output
end

parse_register(line) = parse(Int, split(line, ": ")[2])

function parse_computer(file)
    register_str = readuntil(file, "\n\n")
    program_str = split(readline(file), ": ")[2]
    registers = parse_register.(split(register_str, '\n'))
    program = parse.(Int, split(program_str, ','))
    return Computer(program, registers)
end

function reset!(c::Computer)
    c.pointer = 0
    fill!(c.registers, 0)
    c.output = []
end

function find_quine(comp, target_idx, A)
    target_idx == 0 && return A

    for val in 0:7
        new_A = 8 * A + val
        reset!(comp)
        set!(comp, 1, new_A)
        output = run!(comp)
        if first(output) == comp.program[target_idx]
            sol = find_quine(comp, target_idx - 1, new_A)
            !isnothing(sol) && return sol
        end
    end
end
find_quine(comp) = find_quine(comp, lastindex(comp.program), 0)

open(ARGS[1]) do file
    comp = parse_computer(file)
    output = run!(comp)
    println(join(output, ','))
    println(find_quine(comp))
end