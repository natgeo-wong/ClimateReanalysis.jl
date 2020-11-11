module ERA5

## Base Modules Used
using Base64
using Dates
using DelimitedFiles
using Logging
using Printf
using Statistics

## Modules Used
using CDSAPI
using Crayons.Box
using GeoRegions
using HTTP
using JSON
using NCDatasets

## Load ClimateReanalysis Modules and Submodules
using ..ClimateReanalysis

## Exporting the following functions:
export
        ERA5Dataset,
        download, retrieve,
        era5singledaily

## Abstract types
"""
    ERA5Dataset

Abstract supertype for ERA5 datasets, which is a subtype of the AbstractDataset type
"""
abstract type ERA5Dataset <: AbstractDataset end

"""
    SingleDataset <: ERA5Dataset

Abstract supertype for single-level datasets for ERA5 data.
"""
abstract type SingleDataset <: ERA5Dataset end

"""
    PressureDataset <: ERA5Dataset

Abstract supertype for single-level datasets for ERA5 data.
"""
abstract type PressureDataset <: ERA5Dataset end

## Common Functions
function Base.download(dataset::ERA5Dataset,action::Download)

    varinfo,reginfo,dtinfo = initialize(dataset,action)
    download(dataset,varinfo,reginfo,dtinfo)

end

## Including other files in the module
include("types.jl")
# include("cdsapi.jl")
include("initialize.jl")
include("singledaily.jl")
include("singlemonthly.jl")
include("singlemonthhourly.jl")

end
