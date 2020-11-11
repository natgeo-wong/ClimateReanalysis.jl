"""
This file initializes the ClimateERA module by setting and determining the
ECMWF reanalysis variables to be analyzed and the regions upon which the data
are to be extracted from.  Functionalities include:
    - Setting up of reanalysis module type
    - Setting up of reanalysis variables to be analyzed
    - Setting up of time steps upon which data are to be downloaded
    - Setting up of region of analysis based on ClimateEasy

"""

# ClimateERA variable Setup

function variablecopy(;overwrite::Bool=false)

    jfol = joinpath(DEPOT_PATH[1],"files/ClimateReanalysis/"); mkpath(jfol);
    ftem = joinpath(@__DIR__,"../extra/variables_era5_template.txt")
    fvar = joinpath(jfol,"variables_era5.txt")

    if !overwrite
        if !isfile(fvar)

            @debug "$(now()) - Unable to find variables_era5.txt, copying data from variables_era5_template.txt ..."

            open(fvar,"w") do io
                write(io,"# (1)Mode,(2)ID,(3)IDnc,(4)era5,(5)Full,(6)Units\n")
                open(ftem) do f
                    for line in readlines(f)
                        write(io,"$line\n")
                    end
                end
            end

        end
    else

        if isfile(fvar)
            @warn "$(now()) - Overwriting variables_era5.txt in $jfol ..."
            rm(fvar,force=true)
        end

        open(fvar,"w") do io
            open(ftem) do f
                for line in readlines(f)
                    write(io,"$line\n")
                end
            end
        end

    end

    return fvar

end

function variableload(action::Download)

    @debug "$(now()) - Loading information on the ERA5 Reanalysis variables that can be downloaded from the Climate Data Store ..."
    allparams = readdlm(eravariablecopy(),',',comments=true);

    @debug "$(now()) - Filtering out variables that can only be analyzed but not downloaded ..."
    modID = allparams[:,1]; return allparams[(modID.=="dsfc").+(modID.=="dpre"),:];

end

function variableload(action::Analysis)

    @debug "$(now()) - Loading information on all ERA5 Reanalysis variables."
    return readdlm(eravariablecopy(),',',comments=true);

end

function variableload()

    @debug "$(now()) - Loading information on all ERA5 Reanalysis variables."
    return readdlm(eravariablecopy(),',',comments=true);

end

function variableadd(fadd::AbstractString)

    if !isfile(fadd); error("$(now()) - The file $(fadd) does not exist."); end
    ainfo = readdlm(fadd,',',comments=true); varID = ainfo[:,2]; nadd = size(ainfo,1);
    fvar = variablecopy(); vinfo = variableload(); rvarID = vinfo[:,2];

    open(fvar,"a") do io

        for iadd = 1 : nadd

            if sum(rvarID.==varID) > 0

                if throw
                    error("$(now()) - $(varID) already exists as a variable ID. Please use another identifier.")
                else
                    @info "$(now()) - $(varID) has already been added to variables_era5.txt"
                end

            else

                writedlm(io,replace.("$(ainfo[iadd,:])",["["=>"","]"=>"",", "=>","]))

            end
        end

    end

end

function loadpressure()
    return [1,2,3,5,7,10,20,30,50,70,100,125,150,175,200,
            225,250,300,350,400,450,500,550,600,650,700,750,
            775,800,825,850,875,900,925,950,975,1000]
end

# ClimateERA Region Setup

function regionload(gregID::AbstractString, action::Download)

    @info "$(now()) - Loading available GeoRegions ..."
    greginfo = gregioninfoload(); regionfilter(gregID,greginfo,action);
    gregfull = gregionfullname(gregID,greginfo)
    greggrid = gregionbounds(gregID,greginfo)
    if gregID == "GLB"; regglbe = true; else; regglbe = false; end

    @info "$(now()) - Storing GeoRegion properties and information for the $(gregfull) region ..."
    return Dict("region"=>gregID,"grid"=>greggrid,"name"=>gregfull,"isglobe"=>regglbe)

end

function regionload(gregID::AbstractString, action::Analysis)

    @info "$(now()) - Loading available GeoRegions ..."
    greginfo = gregioninfoload()
    gregfull = gregionfullname(gregID,greginfo)
    greggrid = gregionbounds(gregID,greginfo)
    if gregID == "GLB"; regglbe = true; else; regglbe = false; end

    @info "$(now()) - Storing GeoRegion properties and information for the $(gregfull) region ..."
    return Dict("region"=>gregID,"grid"=>greggrid,"name"=>gregfull,"isglobe"=>regglbe)

end

function regionfilter(gregID::AbstractString, greginfo::AbstractArray, action::Download)

    isgeoregion(gregID,greginfo);

    if gregionparent(gregID;levels=2) != "GLB"
        error("$(now()) - ClimateERA.jl only has the option to analyse data from the $(gregionfullname(gregID,greginfo)) and not download it.")
    end

end

function regionstep(gregID::AbstractString,step::Real=0)

    @debug "$(now()) - Determining spacing between grid points in the GeoRegion ..."
    if step == 0
        if gregID == "GLB";
              step = 1.0;
        else; step = 0.25;
        end
    else
        if !checkegrid(step)
            error("$(now()) - The grid resolution specified is not valid.")
        end
    end

    return step

end

function regionvec(ereg::Dict,step::Real)

    step = regionstep(ereg["region"],step); ereg["step"] = step; N,S,E,W = ereg["grid"]

    @info "$(now()) - Creating longitude and latitude vectors for the GeoRegion ..."
    lon = convert(Array,W:step:E); if mod(E,360) == mod(W,360); pop!(lon); end
    lat = convert(Array,N:-step:S); nlon = size(lon,1); nlat = size(lat,1);
    ereg["lon"] = lon; ereg["lat"] = lat; ereg["size"] = [nlon,nlat];
    ereg["fol"] = "$(ereg["region"])x$(@sprintf("%.2f",ereg["step"]))"

    return ereg

end

function regionparent(gregID::AbstractString,emod::Dict)
    @info "$(now()) - Extracting parent GeoRegion properties/information ..."
    parentID = gregionparent(gregID); return defregion(gregID,emod);
end

function regionparent(gregID::AbstractString,reginfo::AbstractArray,emod::Dict)
    @info "$(now()) - Extracting parent GeoRegion properties/information ..."
    parentID = gregionparent(gregID,reginfo); return defregion(parentID,emod);
end

# function regionextract(data::AbstractArray,gregID::AbstractString,emod::Dict)
#     @info "$(now()) - Extracting data for GeoRegion from parent GeoRegion ..."
#     preg = regionparent(gregID,emod); return regionextractgrid(data,reg,plon,plat)
# end
#
# function regionextract(data::AbstractArray,preg::Dict,reg::AbstractString)
#     @info "$(now()) - Extracting data for GeoRegion from parent GeoRegion ..."
#     return regionextractgrid(data,reg,preg["lon"],preg["lat"])
# end

# Initialization

function defvariable(dataset::SingleDataset, action::AbstractAction)

    variableID = dataset.variable
    varlist = variableload(action);

    if sum(varlist[:,2] .== variableID) == 0
        error("$(now()) - Invalid variable choice for chosen Action $(BOLD(uppercase(action.action))).  Call queryvar(action) to find list of valid variable IDs for this Action.")
    else
        ID = (varlist[:,2] .== variableID);
    end

    varinfo = varlist[ID,:];
    @info """$(now()) - $(BOLD("Selected Variable:")) $(uppercase(varinfo[5]))
      $(BOLD("Units:"))         $(varinfo[6])
      $(BOLD("Reanalysis ID:")) $(varinfo[2])
      $(BOLD("ERA5 ID:"))       $(varinfo[4])
    """

    return Dict(
        "ID"  =>varinfo[2],"IDnc"=>varinfo[3],"era5"=>varinfo[4],
        "name"=>varinfo[5],"unit"=>varinfo[6],"level"=>"sfc"
    )

end

function defvariable(dataset::PressureDataset, action::AbstractAction)

    variableID = dataset.variable
    varlist = variableload(action);

    if sum(varlist[:,2] .== variableID) == 0
        error("$(now()) - Invalid variable choice for chosen Action $(BOLD(uppercase(action.action))).  Call queryvar(action) to find list of valid variable IDs for this Action.")
    else
        ID = (varlist[:,2] .== variableID);
    end

    varinfo = varlist[ID,:];
    @info """$(now()) - $(BOLD("Selected Variable:")) $(uppercase(varinfo[5]))
      $(BOLD("Units:"))         $(varinfo[6])
      $(BOLD("Reanalysis ID:")) $(varinfo[2])
      $(BOLD("ERA5 ID:"))       $(varinfo[4])
    """

    return Dict(
        "ID"  =>varinfo[2],"IDnc"=>varinfo[3],"era5"=>varinfo[4],
        "name"=>varinfo[5],"unit"=>varinfo[6],"level"=>dataset.levels
    )

end

function deftime(
    dataset::ERA5Dataset
    action::AbstractAction
)

    dtinfo = Dict("begin"=>dataset.datebeg,"end"=>dataset.datefin)

    if (typeof(dataset) != SingleMonthly) && (typeof(dataset) != PressureMonthly)
          return dtinfo["hours"] = dataset.hours
    else; return dtinfo
    end

end

function defregion(dataset::ERA5Dataset, action::AbstractAction)
    return regionvec(regionload(dataset.georegion),dataset.gridstep)
end

function initialize(dataset::ERA5Dataset, action::AbstractAction)

    varinfo = defvariable(dataset,action)
    reginfo = defgeoregion(dataset,action)
    dtinfo  = deftime(dataset,action)

    return varinfo,reginfo,dtinfo

end
