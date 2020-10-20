struct Download <: AbstractAction end
struct Analysis <: AbstractAction end

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
        return Download()
    elseif any(uppercase(action),["ANALYSIS","ANALYZE","ANALYSE"])
        return Analysis()
    end

end

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

function startup(action::Download, dataset::ERA5Dataset, path::AbstractString="")

    @info "$(now()) - This script will $(BOLD("DOWNLOAD ERA5")) reanalysis data."
    root = defroot(path,action,dataset)

    plotsetup(root); #plotsubregion("GLB",root["plot"])
    return root

end

function welcome()

    ftext = joinpath(@__DIR__,"../extra/erawelcome.txt");
    lines = readlines(ftext); count = 0; nl = length(lines);
    for l in lines; count += 1;
       if any(count .== [1,2]); print(Crayon(bold=true),"$l\n");
       elseif count == nl;      print(Crayon(bold=false),"$l\n\n");
       else;                    print(Crayon(bold=false),"$l\n");
       end
    end

end
