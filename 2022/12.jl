function parse_map(file)
    s = read(file, String)
    it = filter(!isequal('\n'), s)
    return reshape(collect(it), findfirst('\n', s)-1, :)
end

function dijkstra(arr, start_list, goal)
    queue = [(start, 0) for start in start_list]
    visited = Set{CartesianIndex{2}}()
    directions = [(1, 0), (-1, 0), (0, 1), (0, -1)]
    while true
        curr, dist = pop!(queue)
        curr ∈ visited && continue
        push!(visited, curr)
        for direction in directions
            new = curr + CartesianIndex(direction)
            if new ∉ visited && checkbounds(Bool, arr, new) &&  arr[new] - arr[curr] ≤ 1
                if new == goal
                    return dist + 1
                end
                pushfirst!(queue, (new, dist+1))
            end
        end
    end
end

open(ARGS[1]) do file
    arr = parse_map(file)
    start = findfirst(isequal('S'), arr)
    goal = findfirst(isequal('E'), arr)
    arr[start] = 'a'
    arr[goal] = 'z'
    start_list = findall(isequal('a'), arr)

    println(dijkstra(arr, [start], goal))
    println(dijkstra(arr, start_list, goal))
end