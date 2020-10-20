struct Download <: AbstractAction
    name :: AbstractString
end

struct Analysis <: AbstractAction
    name :: AbstractString
end

"""
    action(str::AbstractString)

Define the action to be taken with regards to the reanalysis dataset.  There are two different types of actions possible (write input as string):

    * Download
    * Analysis (also, Analyze, Analyse)

Arguments:
    * `str::AbstractString` : string showing action to be taken. input is not case sensitive.
"""
function action(action::AbstractString)

    if uppercase(action) == "DOWNLOAD"
        return Download("download")
    elseif any(uppercase(action),["ANALYSIS","ANALYZE","ANALYSE"])
        return Analysis("analyze")
    end

end

"""
    defroot(path::AbstractString, action::AbstractAction) -> Dict

Checks the path argument:
    * If path string is empty (i.e. ""), then a path is created in the user homedir `~/research/reanalysis`.
    * If path specified does not exist, then there are two possible outcomes:
        (1) If `AbstractAction` Type is `Download`, then the path will be created where specified
        (2) If `AbstractAction` Type is `Analysis`, then an error is thrown

Arguments:
    * `path :: AbstractString` : Directory path
    * `action :: AbstractAction` : Type containing information on action to be taken on dataset
"""
function defroot(path::AbstractString, action::Download)

    if path == "";
        path = joinpath("$(homedir())","research","reanalysis");
        @warn "$(now()) - No directory path was given.  Setting to default path: $(path) for reanalysis data downloads."
    end

    if isdir(path)
        @info "$(now()) - The directory $(path) exists and therefore can be used as a directory for reanalysis data downloads."
    else
        @warn "$(now()) - The directory $(path) does not exist.  A new directory will be created here.  Therefore if you already have an existing repository for reanalysis data, make sure that $(path) is the correct location."
        @info "$(now()) - Creating directory $(path) ..."
        mkpath(path);
    end

    return mkroot(path)

end

function defroot(path::AbstractString, action::Analysis)

    if path == "";
        path = joinpath("$(homedir())","research","reanalysis");
        @warn "$(now()) - No directory path was given.  Setting to default directory: $(path) for ClimateERA data downloads."
    end

    if isdir(path)
        @info "$(now()) - The directory $(path) exists and therefore can be used as a directory for reanalysis data downloads."
    else
        error("$(Dates.now()) - The directory $(path) does not exist.  If you are doing analysis, please point towards the correct path before proceeding ...")
    end

    return mkroot(path)

end

"""
    mkroot(root::AbstractString, action::AbstractAction) -> Dict

Define the reanalysis data and plotting directories, returned in the form of a dictionary with the following keywords
    * `root :: String` : Path of the directory for the reanalysis dataset
    * `plot :: String` : Path of the directory containing land-sea mask and other plotting backends

Arguments:
    * `root :: AbstractString` : Directory path
    * `action :: AbstractAction` : Type containing information on action to be taken on dataset
"""
function mkroot(root::AbstractString, dataset::AbstractDataset)

    data = joinpath(root,dataset.prefix);
    if !isdir(data)
        mkpath(data); @info "$(now()) - Created root folder for reanalysis data $(data)."
    else;             @info "$(now()) - Root folder for reanalysis data $(data) exists."
    end

    plot = joinpath(root,"plot");
    if !isdir(plot)
        mkpath(plot); @info "$(now()) - Created root folder for plotting data $(plot)."
    else;             @info "$(now()) - Root folder for plotting data $(plot) exists."
    end

    return Dict("root"=>data,"plot"=>plot);

end

"""
    startup(
        action::AbstractAction,
        dataset::AbstractDataset,
        root::AbstractString=""
    ) -> Dict

Startup the reanalysis data and plotting directories, returned in the form of a dictionary with the following keywords
    * `root :: String` : Path of the directory for the reanalysis dataset
    * `plot :: String` : Path of the directory containing land-sea mask and other plotting backends

Arguments:
    * `action :: AbstractAction` : Type containing information on action to be taken on dataset
    * `dataset :: AbstractDataset` : Type containing information on reanalysis dataset
    * `root :: AbstractString` : Directory path
"""
function startup(action::AbstractAction, dataset::AbstractDataset, path::AbstractString="")

    @info "$(now()) - This script will $(BOLD(uppercase(action.name))) $(BOLD(uppercase(dataset.name))) reanalysis data."
    root = defroot(path,action,dataset)

    @info "$(now()) - Setting up plotting directories and backends ..."
    plotsetup(root["plot"]); plotsubregion("GLB",root["plot"])
    return root

end

"""
    welcome() -> IOStream

Calls the welcome message for `ClimateReanalysis.jl`
"""
function welcome()

    ftext = joinpath(@__DIR__,"../extra/welcome.txt");
    lines = readlines(ftext); count = 0; nl = length(lines);
    for l in lines; count += 1;
       if any(count .== [1,2]); print(Crayon(bold=true),"$l\n");
       elseif count == nl;      print(Crayon(bold=false),"$l\n\n");
       else;                    print(Crayon(bold=false),"$l\n");
       end
    end

end
