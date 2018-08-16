## IO for element

# this is to avoid copy and pasting in print below, don't use this
# anywhere else. gnarly hack, the variable names here have to
# correspond to those in print
macro writeandcheck(line)
    esc(quote
        if pretty
            write(io, repeat("  ",depth)*$line*"\n")
        else
            write(io, $line)
        end
        written += 1
        if written == maxlines return end
    end)
end

function Base.print(io::IO, elem::HTMLElement{T},
                    maxlines=Inf, depth=0, written=0; pretty=false) where {T}
    opentag = isempty(elem.attributes) ? "<$T" : "<$T "
    for (name,value) in elem.attributes
        opentag *= "$name=\"$value\""
    end
    opentag *= ">"
    closetag = "</$T>"
    # TODO make inline elements printed all on one line
    if isempty(children(elem))
        @writeandcheck(opentag * closetag)
    else
        @writeandcheck(opentag)
        for child in elem.children
            print(io,child,maxlines,depth+1,written,pretty=pretty)
        end
        @writeandcheck(closetag)
    end
end

prettyprint(io::IO, elem::HTMLElement) = print(io, elem, Inf, pretty=true)
prettyprint(elem::HTMLElement) = print(stdout, elem, pretty=true)

# TODO maybe query tty_cols for a default?
function Base.show(io::IO, elem::HTMLElement)
    write(io,summary(elem)*":\n")
    if get(io, :compact, false)
        write(io, summary(elem))
    elseif get(io, :limit, false)
        print(io, elem, 20, pretty=true)
    else
        print(io, elem, Inf, pretty=true)
    end
end

### IO for Text

function Base.show(io::IO, t::HTMLText)
    write(io,"HTML Text: $(t.text)")
end

function Base.print(io::IO, node::HTMLText,
                    maxlines=Inf, depth=0, written=0; pretty=false)
    if pretty
        for line in split(strip(text(node)), "\n")
            @writeandcheck(line)
        end
    else
        @writeandcheck(text(node))
    end
end

### io for Document

function Base.show(io::IO, doc::HTMLDocument)
    write(io, "HTML Document:\n")
    write(io, "<!DOCTYPE $(doc.doctype)>\n")
    Base.print(io, doc.root, pretty=true)
end

function Base.print(io::IO, doc::HTMLDocument; pretty=false)
    write(io, "<!DOCTYPE $(doc.doctype)>")
    Base.print(io, doc.root, pretty=pretty)
end

prettyprint(io::IO, doc::HTMLDocument) = Base.print(io, doc, pretty=true)
prettyprint(doc::HTMLDocument) = prettyprint(stdout, doc)
