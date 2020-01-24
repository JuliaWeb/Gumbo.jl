using Libdl

function parsehtml(input::AbstractString; strict=false, preserve_whitespace=false)
    result_ptr = ccall((:gumbo_parse,libgumbo),
                       Ptr{CGumbo.Output},
                       (Cstring,),
                       input)
    goutput::CGumbo.Output = unsafe_load(result_ptr)

    if strict && goutput.errors.length > 0
        throw(InvalidHTMLException("input html was invalid"))
    end
    doc = document_from_gumbo(goutput, preserve_whitespace)
    gumbo_dl = Libdl.dlopen(libgumbo)
    default_options = Libdl.dlsym(gumbo_dl, :kGumboDefaultOptions)
    ccall((:gumbo_destroy_output,libgumbo),
          Cvoid,
          (Ptr{Cvoid}, Ptr{CGumbo.Output}),
          default_options, result_ptr)
    return doc
end


# turn a gumbo vector into a Julia vector
# of Ptr{T} where T is the struct contained
# by the gumbo vector
gvector_to_jl(T,gv::CGumbo.Vector) = unsafe_wrap(Array, convert(Ptr{Ptr{T}},gv.data),
                                                     (Int(gv.length),))


# convert a vector of pointers to GumboAttributes to
# a Dict AbstractString => AbstractString
function attributes(av::Vector{Ptr{CGumbo.Attribute}})
    result = Dict{AbstractString,AbstractString}()
    for ptr in av
        ga::CGumbo.Attribute = unsafe_load(ptr)
        result[unsafe_string(ga.name)] = unsafe_string(ga.value)
    end
    return result
end

function elem_tag(ge::CGumbo.Element)
    tag = CGumbo.TAGS[ge.tag+1]  # +1 is for 1-based julia indexing
    if tag == :unknown
        ot = ge.original_tag
        tag = split(unsafe_string(ot.data, ot.length)[2:end-1])[1] |> Symbol
    end
    tag
end

function gumbo_to_jl(parent::HTMLNode, ge::CGumbo.Element, preserve_whitespace)
    tag = elem_tag(ge)
    attrs = attributes(gvector_to_jl(CGumbo.Attribute,ge.attributes))
    children = HTMLNode[]
    res = HTMLElement{tag}(children, parent, attrs)
    for childptr in gvector_to_jl(CGumbo.Node{Int},ge.children)
        node = load_node(childptr, preserve_whitespace)
        if in(typeof(node).parameters[1], [CGumbo.Element, CGumbo.Text])
            push!(children, gumbo_to_jl(res, node.v, preserve_whitespace))
        end
    end
    res
end


function gumbo_to_jl(parent::HTMLNode, gt::CGumbo.Text, preserve_whitespace)
    HTMLText(parent, unsafe_string(gt.text))
end

# this is a fallback method that should only be called to construct
# the root of a tree
gumbo_to_jl(ge::CGumbo.Element, preserve_whitespace) = gumbo_to_jl(NullNode(), ge, preserve_whitespace)

# load a GumboNode struct into memory as the appropriate Julia type
# this involves loading it once as a CGumbo.Node{Int} in order to
# figure out what the correct type actually is, and then reloading it as
# that type
function load_node(nodeptr::Ptr, preserve_whitespace=false)
    precursor = unsafe_load(reinterpret(Ptr{CGumbo.Node{Int}},nodeptr))
    # TODO clean this up with a Dict in the CGumbo module
    correctptr = if precursor.gntype == CGumbo.ELEMENT
        reinterpret(Ptr{CGumbo.Node{CGumbo.Element}},nodeptr)
    elseif precursor.gntype == CGumbo.TEXT
        reinterpret(Ptr{CGumbo.Node{CGumbo.Text}},nodeptr)
    elseif precursor.gntype == CGumbo.DOCUMENT
        reinterpret(Ptr{CGumbo.Node{CGumbo.Document}},nodeptr)
    elseif preserve_whitespace && precursor.gntype == CGumbo.WHITESPACE
        reinterpret(Ptr{CGumbo.Node{CGumbo.Text}},nodeptr)
    else
        # TODO this is super sketchy and should realistically be an
        # error
        nodeptr
    end
    unsafe_load(correctptr)
end

# transform gumbo output into Julia data
function document_from_gumbo(goutput::CGumbo.Output, preserve_whitespace)
    # TODO convert some of these typeasserts to better error messages?
    gnode::CGumbo.Node{CGumbo.Document} = load_node(goutput.document, preserve_whitespace)
    gdoc = gnode.v
    doctype = unsafe_string(gdoc.name)
    groot::CGumbo.Node{CGumbo.Element} = load_node(goutput.root, preserve_whitespace)
    root = gumbo_to_jl(groot.v, preserve_whitespace)  # already an element
    HTMLDocument(doctype, root)
end
