function plotsetup(root::AbstractDict)

    pdir  = root["plot"]
    ppys  = joinpath(root["plot"],"plot-lsm.py")

    fID = open(ppys,"w");

    write(fID,"#!/usr/bin/env python\n");
    write(fID,"import cdsapi\n");
    write(fID,"c = cdsapi.Client()\n\n");

    write(fID,"c.retrieve(\"reanalysis-era5-single-levels\",\n");
    write(fID,"    {\n");
    write(fID,"        \"product_type\": \"reanalysis\",\n");
    write(fID,"        \"variable\": \"land_sea_mask\",\n");
    write(fID,"        \"year\": \"$(year(Dates.now()))\",\n");
    write(fID,"        \"month\": \"01\",\n");
    write(fID,"        \"day\": \"01\",\n");
    write(fID,"        \"time\": \"00:00\",\n");
    write(fID,"        \"format\": \"netcdf\",\n");
    write(fID,"    },\n");
    write(fID,"    \"plot-GLBx0.25-lsm.nc\")\n\n");
    write(fID,"})\n\n");

end

function plotsubregion(ID::AbstractString, pdir::AbstractString)

    fnc = joinpath(pdir,"plot-GLBx0.25-lsm.nc");
    if !isfile(fnc)
        error("$(now()) - The Global Land-Sea Mask file \"eplot-GLBx0.25-lsm.nc\" does not exist in the folder $(eroot["plot"]). Please run the script \"plot-lsm.py\" in the folder to download the ERA5 Land-Sea Mask file.")
    end

    ds = NCDataset(fnc)
    lsm = ds["lsm"][:]*1; lon = ds["longitude"][:]*1; lat = ds["latitude"][:]*1
    close(ds)

    rlon,rlat,rinfo = gregiongridvec(ID,lon,lat)
    rlsm = regionextractgrid(lsm,rinfo);
    if ndims(rlsm) == 3; rlsm = dropdims(rlsm,dims=3); end
    rfnc = joinpath(pdir,"plot-$(ID)x0.25-lsm.nc")
    if isfile(rfnc)
        @info "$(now()) - Stale NetCDF file $(rfnc) detected.  Overwriting ..."
        rm(rfnc);
    end

    ds = NCDataset(rfnc,"c",attrib = Dict(
        "Conventions" => "CF-1.6",
        "history"     => "Created on $(Dates.now())"
    ))

    ds.dim["longitude"] = length(rlon)
    ds.dim["latitude"]  = length(rlat)

    nclon = defVar(ds,"longitude",Float32,("longitude",),attrib = Dict(
        "units"     => "degrees_east",
        "long_name" => "longitude",
    ))

    nclat = defVar(ds,"latitude",Float32,("latitude",),attrib = Dict(
        "units"     => "degrees_north",
        "long_name" => "latitude",
    ))

    nclsm = defVar(ds,"lsm",Float32,("longitude","latitude"),attrib = Dict(
        "units"         => "(0 - 1)",
        "long_name"     => "Land-sea mask",
        "standard_name" => "land_binary_mask",
    ))

    nclon[:] = rlon; nclat[:] = rlat; nclsm[:] = rlsm

    close(ds)

end
