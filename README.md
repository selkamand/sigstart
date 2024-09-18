
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

# Convert CN Segment Files from other tools -> Sigminer
# (by manually specifying the column name mappings)
path_cn_notpurple <- system.file("pcawg.single_sample.copynumber.notpurple.segment", package = "sigstart")
sigminer_cn_dataframe <- parse_cnv_to_sigminer(
  path_cn_notpurple,
  sample_id = "tumor_sample",
  col_chromosome = "chr",
  col_start = "start",
  col_end = "end",
  col_copynumber = "total_cn",
  col_minor_cn = "minor_cn"
)
```

## Cohort -\> Single Sample Files

Signature analysis tools including sigscreen and signal are easier to
run from single sample data files. Here we demonstrate how to create the

### Converting cohort MAF to single sample VCFs

Signature analysis tools including sigscreen and signal are easier to
run from single sample VCFs than cohort-MAFs. The convert_maf_to_vcfs
function splits a cohort MAF file into a collection of minimal single
sample vcfs.

``` r
library(sigstart)
path_maf <- system.file(package = "sigstart", "pcawg.3sample.snvs_indel.maf")
convert_maf_to_vcfs(path_maf, outdir = "single_sample_files/vcfs")
#> ℹ Found a total of 3 samples in the MAF file
#>   |                                                                              |                                                                      |   0%  |                                                                              |=======================                                               |  33%  |                                                                              |===============================================                       |  67%  |                                                                              |======================================================================| 100%
#> 
#> ✔ Successfullly saved 3 samples to  `<sample>.snv_indel.vcf` files in 'single_sample_files/vcfs'
```

### Converting cohort copynumber calls into single sample segment VCFs

``` r
path_copynumber <- system.file(package = "sigstart", "pcawg.3sample.copynumber.segment")
convert_cohort_segment_file_to_single_samples(path_copynumber, outdir = "single_sample_files/cnvs")
#> ℹ Found a total of 3 samples in the segment file '/private/var/folders/d9/x2yygv_13_15dw5f8fspdn880000gp/T/RtmpTLvGrT/temp_libpath7eb617c88faf/sigstart/pcawg.3sample.copynumber.segment'
#>   |                                                                              |                                                                      |   0%  |                                                                              |=======================                                               |  33%  |                                                                              |===============================================                       |  67%  |                                                                              |======================================================================| 100%
#> 
#> ✔ Successfullly saved 3 samples to  `<sample>.copynumber.tsv` files in 'single_sample_files/cnvs'
```
