module ClimateReanalysis

# Write your package code here.

## Modules Used
using Crayons.Box
using CDSAPI
using Dates
using Logging
using Printf

## Exporting the following functions:
export
        AbstractDataset, AbstractAction,
        action, startup, download,
        era5singledaily,
        eraisingledaily

## Abstract types
"""
    AbstractDataset

Abstract supertype for reanalysis datasets.
"""
abstract type AbstractDataset end

"""
    AbstractAction

Abstract supertype for action to be taken on reanalysis datasets.
"""
abstract type AbstractAction end

## Including submodules
include("ERA5/ERA5.jl")
include("ERAI/ERAI.jl")

## Reexporting functions from submodules
using .ERA5
using .ERAI

## Including other files in the module
include("startup.jl")

## Run welcome message
welcome()

end
