module ERAI

# Write your package code here.

## Modules Used
using Crayons
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
        ERAIDataset,
        download, eraisingledaily

## Abstract types
"""
    ERAIDataset

Abstract supertype for ERA-Interim datasets, which is a subtype of the AbstractDataset type
"""
abstract type ERAIDataset <: AbstractDataset end

"""
    SingleDataset <: ERAIDataset

Abstract supertype for single-level datasets for ERA5 data.
"""
abstract type SingleDataset <: ERAIDataset end

"""
    PressureDataset <: ERAIDataset

Abstract supertype for single-level datasets for ERA5 data.
"""
abstract type PressureDataset <: ERAIDataset end

## Including other files in the module
include("types.jl")
include("download.jl")

end
