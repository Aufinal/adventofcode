find_marker(line, n) = findfirst(i -> allunique(line[i:i+n-1]), 1:length(line)) + n - 1

open(ARGS[1]) do file
    line = readline(file)
    println(find_marker(line, 4))
    println(find_marker(line, 14))
end