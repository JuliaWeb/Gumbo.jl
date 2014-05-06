## IO for element

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
    if isempty(elem.children)
        produce((depth,opentag * closetag))
    else
        produce((depth,opentag))
        for child in elem.children
            linesof(child,depth+1)
        end
        produce((depth,closetag))
    end
end

linesof{T}(elem::HTMLElement{T}) = @task linesof(elem,0)

linesof(t::HTMLText) = produce((0,t.text))
linesof(t::HTMLText,depth) = produce((depth,t.text))

function show{T}(io::IO, elem::HTMLElement{T}, maxlines)
    for (i,(depth, line)) in enumerate(linesof(elem))
        if i == maxlines
            write(io,". . . \n")
            return
        else
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

function Base.showcompact(io::IO, elem::HTMLElement)
    write(io,summary(elem))
end

# print just writes all the lines to io
function Base.print(io::IO, elem::HTMLElement)
    for (depth,line) in linesof(elem)
        write(io, line)
    end
end

### IO for Text

function Base.show(io::IO, t::HTMLText)
    write(io,"HTML Text: t.text")
end


### IO for Document

function Base.show(io::IO, doc::HTMLDocument)
    write(io, "HTML Document:\n")
    write(io, "<!DOCTYPE $(doc.doctype)>\n")
    Base.show(io, doc.root)
end

function Base.showall(io::IO, doc::HTMLDocument)
    write(io, "HTML Document:\n")
    write(io, "<!DOCTYPE $(doc.doctype)>\n")
    Base.showall(io, doc.root)
end


function Base.print(io::IO, doc::HTMLDocument)
    write(io, "<!DOCTYPE $doc.doctype>")
    Base.print(io, doc.root)
end
