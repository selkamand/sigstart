
<!-- README.md is generated from README.Rmd. Please edit that file -->

# sigstart

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![CRAN
status](https://www.r-pkg.org/badges/version/sigstart)](https://CRAN.R-project.org/package=sigstart)
[![R-CMD-check](https://github.com/selkamand/sigstart/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/selkamand/sigstart/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

**Sigstart** reads small variants, copy number changes, and structural
rearrangements from common bioinformatics file formats like VCFs and
segment files. It converts these data into formats compatible with
**sigminer** and other signature analysis tools.

## Installation

You can install the development version of sigstart from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("selkamand/sigstart")
```

## Quick Start

``` r
library(sigstart)

# Convert SNVs and Indels from a tumor-normal VCF -> MAF-like structure for sigminer
path_vcf_snv <- system.file("tumor_normal.purple.somatic.vcf.gz",package = "sigstart")
sigminer_maf_like_dataframe <- parse_vcf_to_sigminer_maf(path_vcf_snv, sample_id = "tumor_sample")
#> ℹ Found 2 samples described in the VCF [normal_sample and tumor_sample]
#> ℹ Returning data for only sample [tumor_sample] samples in format column of VCF.
```

``` r

# Convert Purple SVs from VCF -> BEDPE-like structure for sigminer
path_vcf_sv <- system.file("tumor_sample.purple.sv.vcf", package = "sigstart")
sigminer_sv_dataframe <-  parse_purple_sv_vcf_to_sigminer(path_vcf_sv, sample_id = "tumor_sample")

# Convert Purple SVs from VCF -> BEDPE structure for sigprofiler
bedpe_dataframe <- parse_purple_sv_vcf_to_sigprofiler(path_vcf_sv)

# Convert Purple SVs from VCF -> BEDPE structure (identical output to above)
bedpe_dataframe <- parse_purple_sv_vcf_to_bedpe(path_vcf_sv)

# Convert Purple CN Segment File -> Sigminer 
path_cn <- system.file("COLO829v003T.purple.cnv.somatic.tsv", package = "sigstart")
sigminer_cn_dataframe <- parse_purple_cnv_to_sigminer(path_cn, sample_id = "tumor_sample")
```
