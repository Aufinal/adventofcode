sum_segment(start, len) = len * (len + 2 * start - 1) ÷ 2

function sum_compacted(memory, free)
    free_idx, mem_idx = firstindex(free), lastindex(memory)
    res = 0
    (mem_addr, len_mem) = memory[mem_idx]
    (free_addr, len_free) = free[free_idx]
    while mem_idx > free_idx
        moved = min(len_mem, len_free)
        len_mem -= moved
        len_free -= moved
        res += (mem_idx - 1) * sum_segment(free_addr, moved)
        free_addr += moved
        if iszero(len_free)
            free_idx += 1
            (free_addr, len_free) = free[free_idx]
        end
        if iszero(len_mem)
            mem_idx -= 1
            (mem_addr, len_mem) = memory[mem_idx]
        end            
    end
    while mem_idx > 1
        res += (mem_idx - 1) * sum_segment(mem_addr, len_mem)
        mem_idx -= 1
        (mem_addr, len_mem) = memory[mem_idx]
    end
    return res
end

function sum_defragged(memory, free)
    res = 0
    for (mem_idx, (mem_addr, len_mem)) in reverse(collect(enumerate(memory)))
        free_idx = findfirst(((_, len),) -> len ≥ len_mem, @view free[1:(mem_idx-1)])
        if !isnothing(free_idx)
            free_addr, len_free = free[free_idx]
            res += (mem_idx-1) * sum_segment(free_addr, len_mem)
            free[free_idx] = (free_addr + len_mem, len_free - len_mem)
        else
            res += (mem_idx - 1) * sum_segment(mem_addr, len_mem)
        end
    end
    return res
end

open(ARGS[1]) do file
    input = parse.(Int, collect(readline(file)))
    input = collect(zip([0; cumsum(input)], input))
    memory, free = input[1:2:end], input[2:2:end]
    println(sum_compacted(memory, free))
    println(sum_defragged(memory, free))
end