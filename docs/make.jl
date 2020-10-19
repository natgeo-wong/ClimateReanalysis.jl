using ClimateReanalysis
using Documenter

makedocs(;
    modules=[ClimateReanalysis],
    authors="Nathanael Wong <natgeo.wong@outlook.com>",
    repo="https://github.com/natgeo-wong/ClimateReanalysis.jl/blob/{commit}{path}#L{line}",
    sitename="ClimateReanalysis.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)
