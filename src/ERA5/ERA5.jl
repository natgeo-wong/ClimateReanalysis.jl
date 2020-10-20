module ERA5

# Write your package code here.

## Modules Used
using Crayons.Box
using Dates
using DelimitedFiles
using GeoRegions
using Logging
using NCDatasets
using Printf
using Statistics

using ..ClimateReanalysis

## Exporting the following functions:
export
        ERA5Dataset,
        download, era5singledaily

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

## Including other files in the module
include("types.jl")
include("download.jl")

end
