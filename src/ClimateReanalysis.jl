module ClimateReanalysis

## Base Modules Used
using Dates
using Logging
using Printf

## Modules Used
using Crayons
using Crayons.Box

## Exporting the following functions:
export
        AbstractDataset, AbstractAction,
        action, startup, download,
        era5singledaily,
        eraisingledaily,
        plotsetup, plotsubregion

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

## Load ClimateReanalysis Modules and Submodules
include("ERA5/ERA5.jl"); using .ERA5
include("ERAI/ERAI.jl"); using .ERAI

## Including other files in the module
include("startup.jl")
include("plots.jl")

## Run welcome message
welcome()

end
