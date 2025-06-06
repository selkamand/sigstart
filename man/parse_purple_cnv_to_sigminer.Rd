% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/parse.R
\name{parse_purple_cnv_to_sigminer}
\alias{parse_purple_cnv_to_sigminer}
\title{Parse CNVs to sigminer format}
\usage{
parse_purple_cnv_to_sigminer(
  segment,
  sample_id = "Sample",
  exclude_sex_chromosomes = TRUE
)
}
\arguments{
\item{segment}{path to segment file}

\item{sample_id}{string representing what the sample ID should be. Can be any valid string.}

\item{exclude_sex_chromosomes}{drop sex chromosomes from dataframe output}
}
\value{
data.frame compatible with sigminer (containg the columns sample, chromosome, start, end, segVal, and minor_cn), ready for reading with \code{\link[sigminer:read_copynumber]{sigminer::read_copynumber()}}
}
\description{
Parse a single-sample copynumber segment file to sigminer compatible format.
\strong{This function assumes your segment file is single-sample}.
If you have a multi-sample copynumber file, see \code{\link[=convert_cohort_segment_file_to_single_samples]{convert_cohort_segment_file_to_single_samples()}}.
If working from oncoanalyser outputs see \code{\link[=parse_purple_cnv_to_sigminer]{parse_purple_cnv_to_sigminer()}}.
}
\examples{
path_cn <- system.file("purple.cnv.somatic.tsv", package = "sigstart")
sigminer_cn_dataframe <- parse_purple_cnv_to_sigminer(path_cn, sample_id = "tumor_sample")

}
