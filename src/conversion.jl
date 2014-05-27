function parsehtml(input::String; strict=false)
    result_ptr = ccall((:gumbo_parse,"libgumbo"),
                       Ptr{Gumbo.Output},
                       (Ptr{Uint8},),
                       input)
    goutput::Gumbo.Output = unsafe_load(result_ptr)

    if strict && goutput.errors.length > 0
        throw(InvalidHTMLException("input html was invalid"))
    end
    doc = document_from_gumbo(goutput)
    gumbo_dl = dlopen("libgumbo")
    default_options = dlsym(gumbo_dl, :kGumboDefaultOptions)
    ccall((:gumbo_destroy_output,"libgumbo"),
          Void,
          (Ptr{Void}, Ptr{Gumbo.Output}),
          default_options, result_ptr)
    return doc
end


# turn a gumbo vector into a Julia vector
# of Ptr{T} where T is the struct contained
# by the gumbo vector
gvector_to_jl(T,gv::Gumbo.Vector) = pointer_to_array(convert(Ptr{Ptr{T}},gv.data),
                                                     (int(gv.length),))


# convert a vector of pointers to GumboAttributes to
# a Dict String => String
function attributes(av::Vector{Ptr{Gumbo.Attribute}})
    result = Dict{String,String}()
    for ptr in av
        ga::Gumbo.Attribute = unsafe_load(ptr)
        result[bytestring(ga.name)] = bytestring(ga.value)
    end
    return result
end

function element(parent::HTMLNode, ge::Gumbo.Element)
    tag = Gumbo.TAGS[ge.tag+1]  # +1 is for 1-based julia indexing
    # TODO when tag is unknown get out actual tag ??
    attrs = attributes(gvector_to_jl(Gumbo.Attribute,ge.attributes))
    children = HTMLNode[]
    res = HTMLElement{tag}(children, parent, attrs)
    for nodeptr in gvector_to_jl(Gumbo.Node,ge.children)
        node::Gumbo.Node = unsafe_load(nodeptr)
        if node.gntype == Gumbo.ELEMENT
            push!(children, element(res, node.v))  # already a GumboElement
        elseif node.gntype == Gumbo.TEXT
            push!(children,HTMLText(res,
                                    bytestring(reinterpret(Gumbo.Text,node.v).text)))
        end
        # TODO handle CDATA, comments, etc.
    end
    res
end

element(ge::Gumbo.Element) = element(NullNode(), ge)

# transform gumbo output into Julia data
function document_from_gumbo(goutput::Gumbo.Output)
    # TODO convert some of these typeasserts to better error messages?
    gnode::Gumbo.Node = unsafe_load(goutput.document)
    if gnode.gntype != Gumbo.DOCUMENT
        error("Document appears to have incorrent GumboNodeType")
    end
    gdoc = reinterpret(Gumbo.Document,gnode.v)
    doctype = bytestring(gdoc.name)
    groot::Gumbo.Node = unsafe_load(goutput.root)
    if groot.gntype != Gumbo.ELEMENT  # should always be true
        error("root appears to have wrong GumboNodeType")
    end
    grootnode::Gumbo.Node = unsafe_load(goutput.root)
    root = element(grootnode.v)  # already an element
    HTMLDocument(doctype, root)
end
