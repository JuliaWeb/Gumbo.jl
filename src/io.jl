const NO_ENTITY_SUBSTITUTION = Set([:script, :style])
const EMPTY_TAGS = Set([
    :area,
    :base,
    :basefont,
    :bgsound,
    :br,
    :command,
    :col,
    :embed,
    Symbol("event-source"),
    :frame,
    :hr,
    :image,
    :img,
    :input,
    :keygen,
    :link,
    :menuitem,
    :meta,
    :param,
    :source,
    :spacer,
    :track,
    :wbr
])
const RELEVANT_WHITESPACE = Set([:pre, :textarea, :script, :style])

function substitute_text_entities(str)
    str = replace(str, "&" => "&amp;")
    str = replace(str, "<" => "&lt;")
    str = replace(str, ">" => "&gt;")

    return str
end

function substitute_attribute_entities(str)
    str = substitute_text_entities(str)
    str = replace(str, "\""=> "&quot;")
    str = replace(str, "'" => "&#39;")

    return str
end

function Base.print(io::IO, elem::HTMLElement{T}; pretty = false, depth = 0, substitution = true) where {T}
    empty_tag = T in EMPTY_TAGS
    ws_relevant = T in RELEVANT_WHITESPACE
    has_children = !isempty(elem.children)

    pretty_children = pretty && !ws_relevant

    pretty && print(io, ' '^(2*depth))
    print(io, '<', T)
    for (name, value) in sort(collect(elem.attributes), by = first)
        print(io, ' ', name, "=\"", substitute_attribute_entities(value), '"')
    end
    if empty_tag
        print(io, '/')
    end
    print(io, '>')
    pretty_children && has_children && print(io, '\n')

    if !empty_tag
        for child in elem.children
            print(io, child; pretty = pretty_children, depth = depth + 1, substitution = substitution && !in(T, NO_ENTITY_SUBSTITUTION))
        end

        pretty && has_children && print(io, ' '^(2*depth))
        print(io, "</", T, '>')
    end
    pretty && print(io, '\n')

    return nothing
end

function Base.print(io::IO, node::HTMLText; pretty = false, depth = 0, substitution = true)
    substitutor = substitution ? substitute_text_entities : identity

    if !pretty
        print(io, substitutor(node.text))
        return nothing
    end

    for line in strip.(split(node.text, '\n'))
        isempty(line) && continue
        print(io, ' '^(2*depth), substitutor(line), '\n')
    end
end

function Base.print(io::IO, doc::HTMLDocument; pretty = false)
    write(io, "<!DOCTYPE ", doc.doctype, ">")
    Base.print(io, doc.root, pretty = pretty)
end

prettyprint(io::IO, doc::HTMLDocument) = Base.print(io, doc, pretty = true)
prettyprint(doc::HTMLDocument) = prettyprint(stdout, doc)
prettyprint(io::IO, elem::HTMLElement) = print(io, elem, pretty = true)
prettyprint(elem::HTMLElement) = print(stdout, elem, pretty = true)

function Base.show(io::IO, elem::HTMLElement)
    write(io, summary(elem), ":")
    if get(io, :compact, false)
        return
    elseif get(io, :limit, false)
        buf = IOBuffer()
        print(buf, elem, pretty = true)
        for (i, line) in enumerate(split(String(take!(buf)), '\n'))
            if i > 20
                println(io, "...")
                return
            end

            println(io, line)
        end
    else
        print(io, elem, pretty=true)
    end
end

function Base.show(io::IO, t::HTMLText)
    write(io,"HTML Text: `", t.text, '`')
end

function Base.show(io::IO, doc::HTMLDocument)
    write(io, "HTML Document:\n")
    write(io, "<!DOCTYPE ", doc.doctype, ">\n")
    Base.show(io, doc.root)
end
