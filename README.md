# **<div align="center">ClimateReanalysis.jl</div>**

<p align="center">
  <a href="https://www.repostatus.org/#active">
    <img alt="Repo Status" src="https://www.repostatus.org/badges/latest/active.svg?style=flat-square" />
  </a>
  <a href="https://travis-ci.com/github/natgeo-wong/ClimateReanalysis.jl">
    <img alt="Travis CI" src="https://travis-ci.com/natgeo-wong/ClimateReanalysis.jl.svg?branch=master&style=flat-square">
  </a>
  <a href="https://github.com/natgeo-wong/ClimateReanalysis.jl/actions?query=workflow%3ADocumentation">
    <img alt="Documentation Build" src="https://github.com/natgeo-wong/ClimateReanalysis.jl/workflows/Documentation/badge.svg">
  </a>
  <br>
  <a href="https://mit-license.org">
    <img alt="MIT License" src="https://img.shields.io/badge/License-MIT-blue.svg?style=flat-square">
  </a>
  <img alt="Latest Release" src="https://img.shields.io/github/v/release/natgeo-wong/ClimateReanalysis.jl">
  <a href="https://natgeo-wong.github.io/ClimateReanalysis.jl/stable/">
    <img alt="Latest Documentation" src="https://img.shields.io/badge/docs-stable-blue.svg?style=flat-square">
  </a>
  <a href="https://natgeo-wong.github.io/ClimateReanalysis.jl/dev/">
    <img alt="Latest Documentation" src="https://img.shields.io/badge/docs-latest-blue.svg?style=flat-square">
  </a>
</p>

**Created By:** Nathanael Wong (nathanaelwong@fas.harvard.edu)

**Developer To-Do for v1.0:**
* [ ] Porting of `ClimateERA.jl` functions here, modified to use `Types` instead of `Dicts`
* [ ] Testing of `download` and `analysis` functions
* [ ] Testing of `CDSAPI` functionality for ERA5 data
* [ ] Comprehensive documentation and Jupyter notebook examples
* [ ] `query` function series development

## Introduction

`ClimateReanalysis.jl` is a Julia package that aims to streamline the following processes:
* downloading of reanalysis data (ERA5, ERA-Interim, etc.)
* basic analysis (mean, maximum, minimum, standard deviation, etc.) of downloaded data
* extraction of data for a given **GeoRegion** (see `GeoRegions.jl` for more information)

`ClimateReanalysis.jl` has not been added to the Registry yet.  However, it can still be installed via
```
] add https://github.com/natgeo-wong/ClimateReanalysis.jl.git
```

## Requirements
There are some non-Julia functionalities required in order to download reanalysis data using `ClimateReanalysis.jl` (most pertinent to ECMWF reanalysis data):
* A working Python installation
* For ERA-Interim, please follow the instructions here to install the ECMWF API
* For ERA5, please follow the instructions here to install the CDS API

## ECMWF Reanalysis
Both ERA-Interim and ERA5 are produced by the European Centre for Medium-Range Weather Forecasts.  For more information regarding the ERA-Interim and ERA5 reanalysis models, please refer to the following:
* ERA-Interim [[Documentation](https://www.ecmwf.int/en/elibrary/8174-era-interim-archive-version-20)] [[Paper](https://rmets.onlinelibrary.wiley.com/doi/full/10.1002/qj.828)]
* ERA5 [[Documentation](https://confluence.ecmwf.int/display/CKB/ERA5%3A+data+documentation)]

## Workflow

### Startup and Initialization

## Setup
### Directories
By default, `ClimateReanalysis.jl` saves all data into a `datadir` repository that is user-specified, or else it will otherwise default to
```
datadir="~/research/reanalysis/"
```

### Regions
`ClimateReanalysis.jl` utlizes `GeoRegions.jl` to specify domains from which data is to be extracted.  If the option is not specified, then `ClimateReanalysis.jl` will assume that the user wishes to process **global** data (which may not be wise especially for GPM due to the large file sizes involved and memory required).

For more information, please see the repository for `GeoRegions.jl` [here](https://github.com/natgeo-wong/GeoRegions.jl).

### Downloads
`ClimateReanalysis.jl` does not directly download reanalysis data from ECMWF/CDS.  Instead, it generates a `Python` script according to the user's choice of parameters that the user will run with Python to download the data required.

**Note: I am currently working on updating this with the `CDSAPI.jl` package that was just recently developed.**
