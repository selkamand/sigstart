
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
run from single sample data files. Here we demonstrate how to split
common cohort/multisample filetypes into a collection of single-sample
files.

### Converting cohort MAF to single sample VCFs

Signature analysis tools including sigscreen and signal are easier to
run from single sample VCFs than cohort-MAFs. The convert_maf_to_vcfs
function splits a cohort MAF file into a collection of minimal single
sample vcfs.

``` r
# Split MAF into single sample VCFs
path_maf <- system.file(package = "sigstart", "pcawg.3sample.snvs_indel.maf")
convert_maf_to_vcfs(
  path_maf, 
  outdir = "single_sample_files/vcfs", 
  verbose = FALSE
)

# Parse the vcfs 
# (no need to specify a sample ID since these are single sample VCFs)
maf <- parse_vcf_to_sigminer_maf("single_sample_files/vcfs/DO1000.snv_indel.vcf.bgz")
#> ℹ Found 1 samples described in the VCF [DO1000]
```

``` r
head(maf)
#> Empty data.table (0 rows and 14 cols): Chromosome,Position_1based,ID,QUAL,FILTER,Tumor_Sample_Barcode...
```

### Converting cohort copynumber calls into single sample segment VCFs

``` r
# Split cohort CNV segment files into single sample files 
path_copynumber <- system.file(package = "sigstart", "pcawg.3sample.copynumber.segment")
convert_cohort_segment_file_to_single_samples(
  path_copynumber, 
  outdir = "single_sample_files/cnvs", 
  verbose = FALSE
)

# Parse the copynumber file
cnv <- parse_cnv_to_sigminer("single_sample_files/cnvs/DO1000.copynumber.tsv.bgz", sample_id = "D01000")
head(cnv)
#>   sample Chromosome  Start.bp    End.bp modal_cn minor_cn
#> 1 D01000          1     10001    790502        3        1
#> 2 D01000          1    790503   5052500        3        1
#> 3 D01000          1   5052501   5219983        3        1
#> 4 D01000          1   5219984  74599976        3        1
#> 5 D01000          1  74599977 118369934        3        1
#> 6 D01000          1 118369935 118774913        3        1
```
