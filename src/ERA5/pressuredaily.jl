function era5pressuredaily(
    rvar::AbstractString,
    greg::AbstractString="GLB",
    gstp::Real=0,
    dbeg::Date=Date(1979,1),
    dend::Date=Date(year(now())-1,12),
    hour::Vector{<:Integer}=collect(0:23)
)

    @info "$(now()) - $(BOLD("Selected Dataset:")) ERA5 Pressure-Level Hourly"

    return PressureDaily(
        "ERA5 Pressure-Level Hourly",
        "era5",
        "reanalysis-era5-pressure-levels",
        "reanalysis",
        rvar,greg,gstp,dbeg,dend,hour
    )

end

function Base.download(
    dataset::PressureDaily,
    varinfo::AbstractDict,
    reginfo::AbstractDict,
    dtinfo::AbstractDict
)

    fnc = deffncraw(dataset)
    fol = defdirraw(dataset)

    keys   = cdskeys()
    params = Dict(
        "product_type"   => dataset.productID,
        "variable"       => varinfo["era5"],
        "pressure_level" => varinfo["level"],
        "grid"           => reginfo["grid"][1,4,2,3],
        "step"           => reginfo["step"] * [1,1],
        "time"           => dtinfo["hours"],
        "format"         => "netcdf",
    )

    if dtinfo["begin"] == dtinfo["end"]

        params["year"]  = year(dtinfo["begin"])
        params["month"] = month(dtinfo["begin"])
        params["day"]   = day(dtinfo["begin"])

        retrieve(dataset.cdsID,params,fnc,keys)

    else

        yrb = year(dtinfo["begin"]);  yre = year(dtinfo["end"])
        mob = month(dtinfo["begin"]); moe = month(dtinfo["end"])

        for dt = Date(yrb,mob) : Month(1) : Date(yre,moe)

            params["year"]  = year(dt)
            params["month"] = month(dt)
            params["day"]   = collect(1:daysinmonth(dt))

            retrieve(dataset.cdsID,params,fnc,keys)

        end
    end

end
