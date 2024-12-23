function build_xmas(gap, rev=false)
    str = rev ? "SAMX" : "XMAS"
    gap_regex = iszero(gap) ? "" : ".{$(gap)}"
    return Regex(join(collect(str), gap_regex), "s")
end

function build_x_mas(rev1, rev2, gap)
    c1, c4 = rev1 ? ("S", "M") : ("M", "S")
    c2, c3 = rev2 ? ("S", "M") : ("M", "S")
    return Regex(join(["$(c1).$(c2)", ".A.", "$(c3).$(c4)"], ".{$(gap)}"), "s")
end

open(ARGS[1]) do file
    grid = read(file, String)
    n = findfirst('\n', grid) - 1
    println(sum(count(build_xmas(gap, rev), grid, overlap=true)
                for gap in (0, n - 1, n, n + 1)
                for rev in (true, false)))

    println(sum(count(build_x_mas(rev1, rev2, n - 2), grid, overlap=true)
                for rev1 in (true, false)
                for rev2 in (true, false)))
end
