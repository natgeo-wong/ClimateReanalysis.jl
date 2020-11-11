struct SingleDaily <: SingleDataset
      dataset :: AbstractString
       prefix :: AbstractString
        cdsID :: AbstractString
    productID :: AbstractString
     variable :: AbstractString
    georegion :: AbstractString
     gridstep :: Real
      datebeg :: Date
      datefin :: Date
        hours :: Vector{<:Integer}
end

struct SingleMonthly <: SingleDataset
      dataset :: AbstractString
       prefix :: AbstractString
        cdsID :: AbstractString
    productID :: AbstractString
     variable :: AbstractString
    georegion :: AbstractString
     gridstep :: Real
      datebeg :: Date
      datefin :: Date
end

struct SingleMonthHourly <: SingleDataset
      dataset :: AbstractString
       prefix :: AbstractString
        cdsID :: AbstractString
    productID :: AbstractString
     variable :: AbstractString
    georegion :: AbstractString
     gridstep :: Real
      datebeg :: Date
      datefin :: Date
        hours :: Vector{<:Integer}
end

struct PressureDaily <: PressureDataset
      dataset :: AbstractString
       prefix :: AbstractString
        cdsID :: AbstractString
    productID :: AbstractString
     variable :: AbstractString
       levels :: Integer
    georegion :: AbstractString
     gridstep :: Real
      datebeg :: Date
      datefin :: Date
        hours :: Vector{<:Integer}
end

struct PressureMonthly <: PressureDataset
      dataset :: AbstractString
       prefix :: AbstractString
        cdsID :: AbstractString
    productID :: AbstractString
     variable :: AbstractString
       levels :: Vector{<:Integer}
    georegion :: AbstractString
     gridstep :: Real
      datebeg :: Date
      datefin :: Date
end

struct PressureMonthHourly <: PressureDataset
      dataset :: AbstractString
       prefix :: AbstractString
        cdsID :: AbstractString
    productID :: AbstractString
     variable :: AbstractString
       levels :: Vector{<:Integer}
    georegion :: AbstractString
     gridstep :: Real
      datebeg :: Date
      datefin :: Date
        hours :: Vector{<:Integer}
end
