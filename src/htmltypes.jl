type HTMLElement{T}
    children::Vector{HTMLElement}
    text::String
    attributes::Dict{String, String}
end

# convenience method for defining an empty element
HTMLElement(T::Symbol) = HTMLElement{T}({},"",Dict{String,String}())

type HTMLDocument
    doctype::String
    root::HTMLElement
end

type InvalidHTMLException <: Exception
    msg::String
end

# linesof(elem) returns a task. consuming from this task
# yields returns tuples of (depth, line), where depth is tree
# depth and line is a pretty string representing the line
function linesof{T}(elem::HTMLElement{T},depth::Int)
    opentag = isempty(elem.attributes) ? "<$T" : "<$T "
    for (name,value) in elem.attributes
        opentag *= "$name=\"$value\""
    end
    opentag *= ">"
    closetag = "</$T>"
    if isempty(elem.children) && isempty(elem.text)
        produce((depth,opentag * closetag))
    else
        produce((depth,opentag))
        if !isempty(elem.text)
            produce((depth+1, elem.text)) # TODO this could be full of \n\n\n
        end
        for child in elem.children
            linesof(child,depth+1)
        end
        produce((depth,closetag))
    end
end

linesof{T}(elem::HTMLElement{T}) = @task linesof(elem,0)

function show{T}(io::IO, elem::HTMLElement{T}, maxlines)
    maxdepth = Inf
    for (i,(depth, line)) in enumerate(linesof(elem))
        if i + depth >= maxlines && maxdepth == Inf
            write(io,repeat("  ",depth)*". . . \n")
            maxdepth = depth
        elseif depth < maxdepth
            write(io,repeat("  ",depth)*line*"\n")
        end
    end
end

# TODO maybe query tty_cols for a default?
function Base.show(io::IO, elem::HTMLElement)
    write(io,summary(elem)*":\n")
    show(io, elem, 20)
end

function Base.showall(io::IO, elem::HTMLElement)
    write(io,summary(elem)*":\n")
    show(io, elem, Inf)
end

# print just writes all the lines to io
function Base.print(io::IO, elem::HTMLElement)
    for (depth,line) in linesof(elem)
        write(io, line)
    end
end
