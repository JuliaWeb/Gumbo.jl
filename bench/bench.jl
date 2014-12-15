using BenchmarkLite
using Gumbo
using Requests

type HTMLParse <: Proc end

Base.string(hp::HTMLParse) = "htmlparse"

Base.length(hp::HTMLParse, cfg::String) = length(get(cfg).data)

# I guess I could do a URI parse here?
Base.isvalid(hp::HTMLParse, cfg::String) = true

Base.start(hp::HTMLParse, cfg::String) = get(cfg).data
Base.done(hp::HTMLParse, cfg::String, s) = nothing

Base.run(hp::HTMLParse, cfg::String, s) = parsehtml(s)

cfgs = ["http://www.google.com",
        "http://example.com",
        "http://www.gnu.org/software/libc/manual/html_mono/libc.html"]

info("Running benchmarks.")
results = run(Proc[HTMLParse()], cfgs)
