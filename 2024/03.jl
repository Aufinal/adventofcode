function sum_mul(str)
    re = r"mul\((\d+),(\d+)\)"
    sum(m -> parse(Int, m[1]) * parse(Int,m[2]), eachmatch(re, str))
end

open(ARGS[1]) do file
    re = r"(?:^|do\(\)).*?(?:don't\(\)|$)"s
    str = read(file, String)
    println(sum_mul(str))
    println(sum(m -> sum_mul(m.match), eachmatch(re, str)))
end
