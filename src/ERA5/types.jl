struct SingleDaily <: SingleDataset
    eparameter :: AbstractString
     georegion :: AbstractString
     datestart :: TimeType
       dateend :: TimeType
         hours :: Vector{<:Integer}
end

function era5singledaily(
    par::AbstractString,
    greg::AbstractString,
    dbeg::TimeType,
    dend::TimeType,
    hour::Vector{<:Integer}=collect(0:23)
)

    @info "$(now()) - $(BOLD("Selected Dataset:")) ERA5 Single-Level Hourly"

    return SingleDaily(par,greg,dbeg,dend,hour)

end

struct SingleMonthly <: SingleDataset

end

struct SingleMonthHourly <: SingleDataset

end

struct PressureDaily <: PressureDataset

end

struct PressureMonthly <: PressureDataset

end

struct PressureMonthHourly <: PressureDataset

end
