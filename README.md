# Gumbo.jl

[![Build Status](https://travis-ci.org/JuliaWeb/Gumbo.jl.svg?branch=master)](https://travis-ci.org/JuliaWeb/Gumbo.jl)
[![Build status](https://ci.appveyor.com/api/projects/status/5y5hh4lv0wgw4i12?svg=true)](https://ci.appveyor.com/project/porterjamesj/gumbo-jl)

[![Gumbo](http://pkg.julialang.org/badges/Gumbo_0.3.svg)](http://pkg.julialang.org/?pkg=Gumbo)
[![Gumbo](http://pkg.julialang.org/badges/Gumbo_0.4.svg)](http://pkg.julialang.org/?pkg=Gumbo)
[![Gumbo](http://pkg.julialang.org/badges/Gumbo_0.5.svg)](http://pkg.julialang.org/?pkg=Gumbo)
[![Gumbo](http://pkg.julialang.org/badges/Gumbo_0.6.svg)](http://pkg.julialang.org/?pkg=Gumbo)
[![Gumbo](http://pkg.julialang.org/badges/Gumbo_0.7.svg)](http://pkg.julialang.org/?pkg=Gumbo)

[![codecov.io](http://codecov.io/github/JuliaWeb/Gumbo.jl/coverage.svg?branch=master)](http://codecov.io/github/JuliaWeb/Gumbo.jl?branch=master)

Gumbo.jl is a Julia wrapper around
[Google's gumbo library](https://github.com/google/gumbo-parser) for
parsing HTML.

Getting started is very easy:


```julia
julia> using Gumbo

julia> parsehtml("<h1> Hello, world! </h1>")
HTML Document:
<!DOCTYPE >
HTMLElement{:HTML}:
<HTML>
  <head></head>
  <body>
    <h1>
       Hello, world!
    </h1>
  </body>
</HTML>
```

Read on for further documentation.

## Installation

```jl
using Pkg
Pkg.add("Gumbo")
```

or activate `Pkg` mode in the REPL by typing `]`, and then:

```
add Gumbo
```

## Basic usage

The workhorse is the `parsehtml` function, which takes a single
argument, a valid UTF8 string, which is interpreted as HTML data to be
parsed, e.g.:

```julia
parsehtml("<h1> Hello, world! </h1>")
```

The result of a call to `parsehtml` is an `HTMLDocument`, a type which
has two fields: `doctype`, which is the doctype of the parsed document
(this will be the empty string if no doctype is provided), and `root`,
which is a reference to the `HTMLElement` that is the root of the
document.

Note that gumbo is a very permissive HTML parser, designed to
gracefully handle the insanity that passes for HTML out on the wild,
wild web. It will return a valid HTML document for *any* input, doing
all sorts of algorithmic gymnastics to twist what you give it into
valid HTML.

If you want an HTML validator, this is probably not your library. That
said, `parsehtml` does take an optional `Bool` keyword argument,
`strict` which, if `true`, causes an `InvalidHTMLError` to be thrown
if the call to the gumbo C library produces any errors.

## HTML types

This library defines a number of types for representing HTML.

### `HTMLDocument`

`HTMlDocument` is what is returned from a call to `parsehtml` it has a
`doctype` field, which contains the doctype of the parsed document,
and a `root` field, which is a reference to the root of the document.

### `HTMLNode`s

A document contains a tree of HTML Nodes, which are represented as
children of the `HTMLNode` abstract type. The first of these is
`HTMLElement`.

### `HTMLElement`

```julia
mutable struct HTMLElement{T} <: HTMLNode
    children::Vector{HTMLNode}
    parent::HTMLNode
    attributes::Dict{String, String}
end
```

`HTMLElement` is probably the most interesting and frequently used
type. An `HTMLElement` is parameterized by a symbol representing its
tag. So an `HTMLElement{:a}` is a different type from an
`HTMLElement{:body}`, etc. An empty `HTMLElement` of a given tag can be
constructed as follows:

```julia
julia> HTMLElement(:div)
HTMLElement{:div}:
<div></div>
```

`HTMLElement`s have a `parent` field, which refers to another
`HTMLNode`. `parent` will always be an `HTMLElement`, unless the
element has no parent (as is the case with the root of a document), in
which case it will be a `NullNode`, a special type of `HTMLNode` which
exists for just this purpose. Empty `HTMLElement`s constructed as in
the example above will also have a `NullNode` for a parent.

`HTMLElement`s also have `children`, which is a vector of
`HTMLElement` containing the children of this element, and
`attributes`, which is a `Dict` mapping attribute names to values.

`HTMLElement`s implement `getindex`, `setindex!`, and `push!`;
indexing into or pushing onto an `HTMLElement` operates on its
children array.

There are a number of convenience methods for working with `HTMLElement`s:

- `tag(elem)`
  get the tag of this element as a symbol

- `attrs(elem)`
  return the attributes dict of this element

- `children(elem)`
   return the children array of this element

- `getattr(elem, name)`
  get the value of attribute `name` or raise a `KeyError`

- `setattr!(elem, name, value)`
  set the value of attribute `name` to `value`

### `HTMLText`

```jl
type HTMLText <: HTMLNode
    parent::HTMLNode
    text::String
end
```

Represents text appearing in an HTML document. For example:

```julia
julia> doc = parsehtml("<h1> Hello, world! </h1>")
HTML Document:
<!DOCTYPE >
HTMLElement{:HTML}:
<HTML>
  <head></head>
  <body>
    <h1>
       Hello, world!
    </h1>
  </body>
</HTML>

julia> doc.root[2][1][1]
HTML Text:  Hello, world!
```

This type is quite simple, just a reference to its parent and the
actual text it represents (this is also accessible by a `text`
function). You can construct `HTMLText` instances as follows:

```jl
julia> HTMLText("Example text")
HTML Text: Example text
```

Just as with `HTMLElement`s, the parent of an instance so constructed
will be a `NullNode`.


## Tree traversal

Use the iterators defined in
[AbstractTrees.jl](https://github.com/Keno/AbstractTrees.jl/), e.g.:

```julia
julia> using AbstractTrees

julia> using Gumbo

julia> doc = parsehtml("""
                     <html>
                       <body>
                         <div>
                           <p></p> <a></a> <p></p>
                         </div>
                         <div>
                            <span></span>
                         </div>
                        </body>
                     </html>
                     """);

julia> for elem in PreOrderDFS(doc.root) println(tag(elem)) end
HTML
head
body
div
p
a
p
div
span

julia> for elem in PostOrderDFS(doc.root) println(tag(elem)) end
head
p
a
p
div
span
div
body
HTML

julia> for elem in StatelessBFS(doc.root) println(tag(elem)) end
HTML
head
body
div
div
p
a
p
span

julia>
```

## TODOS

- support CDATA
- support comments
