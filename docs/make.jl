using TerminalMenusExtra
using Documenter

DocMeta.setdocmeta!(TerminalMenusExtra, :DocTestSetup, :(using TerminalMenusExtra); recursive=true)

makedocs(;
    modules=[TerminalMenusExtra],
    authors="Marco Menarini",
    sitename="TerminalMenusExtra.jl",
    format=Documenter.HTML(;
        canonical="https://uriele.github.io/TerminalMenusExtra.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/uriele/TerminalMenusExtra.jl",
    devbranch="main",
)
