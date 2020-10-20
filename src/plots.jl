function plotsetup(pdir::AbstractString)

    pfnc = joinpath(pdir,"plot-GLBx0.25-lsm.nc")

    # if !isfile(pfnc)
        plsm = Dict(
            "product_type" => "reanalysis",
            "variable"     => "land_sea_mask",
            "year"         => year(Dates.now()),
            "month"        => 1,
            "day"          => 1,
            "time"         => "00:00",
            "format"       => "netcdf"
        )
        retrieve(pfnc,"reanalysis-era5-single-levels",plsm)
    # end

end

function plotsubregion(ID::AbstractString, pdir::AbstractString)

    plotsetup(pdir::AbstractString)

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
