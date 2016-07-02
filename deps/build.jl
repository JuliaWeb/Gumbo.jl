using BinDeps

@BinDeps.setup

libgumbo = library_dependency("libgumbo", aliases = ["libgumbo-1"])

provides(Sources,
         URI("http://jamesporter.me/julia/gumbo-1.0.tar.gz"),
         libgumbo,
         unpacked_dir="gumbo-1.0")

provides(Binaries, URI("https://cache.julialang.org/https://bintray.com/artifact/download/tkelman/generic/gumbo.7z"),
         libgumbo, unpacked_dir="usr$WORD_SIZE/bin", os = :Windows)

provides(BuildProcess,
         Autotools(libtarget="libgumbo.la"),
         libgumbo, os = :Unix)

@BinDeps.install Dict(:libgumbo => :libgumbo)
