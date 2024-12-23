struct File
    name::String
    size::Int
end

mutable struct Directory
    name::String
    parent::Union{Nothing,Directory}
    contents::Dict{String,Union{File,Directory}}
    size::Union{Nothing,Int}

    Directory(name, parent) = new(name, parent, Dict(), nothing)
    Directory(name) = new(name, nothing, Dict(), nothing)
end

size(f::File) = f.size
size(d::Directory) = isnothing(d.size) ? (d.size = sum(size, values(d.contents), init=0)) : d.size

function parse_ls(ls_line::String, parent)
    size_or_dir, name = split(ls_line)
    if size_or_dir == "dir"
        return Directory(name, parent)
    else
        return File(name, parse(Int, size_or_dir))
    end
end

open(ARGS[1]) do file
    root = Directory("/")
    dir_list = [root]
    cur_dir = root

    for line in Iterators.drop(eachline(file), 1)
        if startswith(line, '$')
            cmd, args... = split(line)[2:end]
            if cmd == "cd"
                to_dir = args[1]
                cur_dir = to_dir == ".." ? cur_dir.parent : cur_dir.contents[to_dir]
            end
        else
            inode = parse_ls(line, cur_dir)
            cur_dir.contents[inode.name] = inode
            if isa(inode, Directory)
                push!(dir_list, inode)
            end
        end
    end

    sizes = map(size, dir_list)
    println(sum(filter(<(100000), sizes)))
    println(minimum(filter(>(3e7 - (7e7 - root.size)), sizes)))
end