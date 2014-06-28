function parsehtml(input::String; strict=false)
    result_ptr = ccall((:gumbo_parse,libgumbo),
                       Ptr{CGumbo.Output},
                       (Ptr{Uint8},),
                       input)
    goutput::CGumbo.Output = unsafe_load(result_ptr)

    if strict && goutput.errors.length > 0
        throw(InvalidHTMLException("input html was invalid"))
    end
    doc = document_from_gumbo(goutput)
    gumbo_dl = dlopen(libgumbo)
    default_options = dlsym(gumbo_dl, :kGumboDefaultOptions)
    ccall((:gumbo_destroy_output,libgumbo),
          Void,
          (Ptr{Void}, Ptr{CGumbo.Output}),
          default_options, result_ptr)
    return doc
end


# turn a gumbo vector into a Julia vector
# of Ptr{T} where T is the struct contained
# by the gumbo vector
gvector_to_jl(T,gv::CGumbo.Vector) = pointer_to_array(convert(Ptr{Ptr{T}},gv.data),
                                                     (int(gv.length),))


# convert a vector of pointers to GumboAttributes to
# a Dict String => String
function attributes(av::Vector{Ptr{CGumbo.Attribute}})
    result = Dict{String,String}()
    for ptr in av
        ga::CGumbo.Attribute = unsafe_load(ptr)
        result[bytestring(ga.name)] = bytestring(ga.value)
    end
    return result
end

function element(parent::HTMLNode, ge::CGumbo.Element)
    tag = CGumbo.TAGS[ge.tag+1]  # +1 is for 1-based julia indexing is
    if tag == :unknown
        ot = ge.original_tag
        tag = bytestring(ot.data, ot.length)[2:end-1] |> symbol
    end
    attrs = attributes(gvector_to_jl(CGumbo.Attribute,ge.attributes))
    children = HTMLNode[]
    res = HTMLElement{tag}(children, parent, attrs)
    for nodeptr in gvector_to_jl(CGumbo.Node,ge.children)
        node::CGumbo.Node = unsafe_load(nodeptr)
        if node.gntype == CGumbo.ELEMENT
            push!(children, element(res, node.v))  # already a GumboElement
        elseif node.gntype == CGumbo.TEXT
            push!(children,HTMLText(res,
                                    bytestring(reinterpret(CGumbo.Text,node.v).text)))
        end
        # TODO handle CDATA, comments, etc.
    end
    res
end

element(ge::CGumbo.Element) = element(NullNode(), ge)

# transform gumbo output into Julia data
function document_from_gumbo(goutput::CGumbo.Output)
    # TODO convert some of these typeasserts to better error messages?
    gnode::CGumbo.Node = unsafe_load(goutput.document)
    if gnode.gntype != CGumbo.DOCUMENT
        error("Document appears to have incorrent GumboNodeType")
    end
    gdoc = reinterpret(CGumbo.Document,gnode.v)
    doctype = bytestring(gdoc.name)
    groot::CGumbo.Node = unsafe_load(goutput.root)
    if groot.gntype != CGumbo.ELEMENT  # should always be true
        error("root appears to have wrong GumboNodeType")
    end
    grootnode::CGumbo.Node = unsafe_load(goutput.root)
    root = element(grootnode.v)  # already an element
    HTMLDocument(doctype, root)
end
