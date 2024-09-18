#' Convert MAF-like File to Single Sample VCFs
#'
#' This function takes a path to a MAF-like file and creates a collection of single-sample VCFs.
#' Note that this is **NOT** a lossless operation. Only the most basic chromosome/position/reference/alternate allele information is kept to ensure VCFs are extremely simple.
#' Also, no filtering is applied to the MAF—every variant in your MAF will be saved in the VCFs.
#'
#' @param path Path to the MAF file (string).
#' @param outdir Output directory where VCF files will be saved (string).
#' @param col_sample Name of the column describing the sample containing the mutation (string).
#' @param col_chrom Name of the column describing the chromosome of the mutation (string).
#' @param col_start_position Name of the column describing the start position of the mutation (string).
#' @param col_end_position Name of the column describing the end position of the mutation (string).
#' @param col_ref Name of the column describing the reference allele (string).
#' @param col_alt Name of the column describing the alternate allele (string).
#' @param bgzip should segment files be bgzipped?
#' @return Invisibly returns NULL. Creates VCF files in the specified output directory.
#' @export
#'
#' @examples
#' path_maf <- system.file(package = "sigstart", "pcawg.3sample.snvs_indel.maf")
#' convert_maf_to_vcfs(path_maf, outdir = "vcfs")
convert_maf_to_vcfs <- function(path, outdir = "vcfs",
                                col_sample = "Tumor_Sample_Barcode",
                                col_chrom = "Chromosome",
                                col_start_position = "Start_Position",
                                col_end_position = "End_Position",
                                col_ref = "Reference_Allele",
                                col_alt = "Tumor_Seq_Allele2",
                                bgzip = TRUE
){

  # Assertions
  assertions::assert_file_exists(path)
  assertions::assert_directory_does_not_exist(outdir, msg = "Directory {.path {outdir}} already exists. Please remove then try again")
  if(bgzip) requireNamespace("Rsamtools", quietly = TRUE)

  # Read MAF (first 10 lines only)
  df_maf <- data.table::fread(path, nrows = 5)

  # Ensure We Have all the right columns
  assertions::assert_names_include(df_maf, c(col_sample,  col_chrom, col_start_position, col_end_position, col_ref, col_alt))

  # If the maf has all the right column names, read the full MAF
  df_maf <- data.table::fread(path)

  # Count Samples
  samples <- unique(df_maf[[col_sample]])
  nsamples <- length(samples)
  cli::cli_alert_info("Found a total of {nsamples} samples in the MAF file")

  # Create output directory
  dir.create(outdir, recursive = TRUE)

  # Split Samples
  ls_maf <- split(df_maf, df_maf[[col_sample]])

  # Iterate over samples, writing data to individual files
  progress_bar = utils::txtProgressBar(min=0, max=nsamples, style = 3, char="=")
  i=0
  for (sample in names(ls_maf)){
    i <- i + 1
    utils::setTxtProgressBar(progress_bar, value=i, title = NULL, label = NULL)
    outfile = paste0(outdir, "/", sample, ".snv_indel.vcf")
    file.create(outfile)
    df_ss_maf <- ls_maf[[sample]]
    df_vcf <- data.frame(
      CHROM = df_ss_maf[[col_chrom]],
      POS = df_ss_maf[[col_start_position]],
      ID = ".",
      REF = df_ss_maf[[col_ref]],
      ALT = df_ss_maf[[col_alt]],
      QUAL = ".",
      FITLER = ".",
      INFO = "."
    )
    write("##fileformat=VCFv4.2", file = outfile, append = FALSE)
    write(paste0("##sample=", sample), file = outfile, append = TRUE)
    write("#CHROM\tPOS\tID\tREF\tALT\tQUAL\tFILTER\tINFO", file = outfile, append = TRUE)
    utils::write.table(df_vcf, col.names = FALSE, row.names = FALSE, sep = "\t", file = outfile, append = TRUE, quote = FALSE)

    # Compress with bgzip
    if(bgzip){
      Rsamtools::bgzip(file = outfile)
      file.remove(outfile)
    }

  }

  message("\n")
  cli::cli_alert_success("Successfullly saved {nsamples} samples to  {.code <sample>.snv_indel.vcf} files in {.path {outdir}}")

  # Invisibly return NULL
  return(invisible(NULL))
}


#' Convert cohort CNV file to single samples
#'
#' This function takes a path to a CNV describing segment files (TSV format) and
#' creates a collection of single-sample copynumber segment files that can be read with
#' [parse_cnv_to_sigminer()]. Makes no changes to the data, just splits it up by sample.
#'
#' @param segment a tsv describing somatic copynumber changes by genomic region.
#' @param col_sample name of the column containing sample identifiers
#' @param outdir Output directory where single-sample segment files will be saved (string).
#' @param bgzip should segment files be bgzipped?
#' @inheritParams parse_cnv_to_sigminer
#'
#' @return Invisibly returns NULL. Creates single sample copynumber segment files in the specified output directory.
#' @export
#'
#' @examples
#' path_copynumber <- system.file(package = "sigstart", "pcawg.3sample.copynumber.segment")
#' convert_cohort_segment_file_to_single_samples(path_copynumber, outdir = "single_sample_files/cnvs")
#'
convert_cohort_segment_file_to_single_samples <- function(
    segment,
    col_sample = "sample",
    col_chromosome = "chromosome",
    col_start = "start",
    col_end = "end",
    col_copynumber = "copynumber",
    col_minor_cn = "minorAlleleCopyNumber",
    outdir = "cnvs",
    bgzip = TRUE
    ){

  # Assertions
  assertions::assert_file_exists(segment)
  assertions::assert_directory_does_not_exist(outdir, msg = "Directory {.path {outdir}} already exists. Please remove then try again")
  if(bgzip) requireNamespace("Rsamtools", quietly = TRUE)

  # Check file has valid segment format
  df_top5_rows <- data.table::fread(segment, nrows = 5)
  assertions::assert_names_include(df_top5_rows, c(col_sample, col_chromosome, col_start, col_end, col_copynumber, col_minor_cn))

  # If so, read in the full file
  df_segment <- data.table::fread(segment)

  # Count Samples
  samples <- unique(df_segment[[col_sample]])
  nsamples <- length(samples)
  cli::cli_alert_info("Found a total of {nsamples} samples in the segment file {.path {segment}}")

  # Create output directory
  dir.create(outdir, recursive = TRUE)

  # Split Samples
  ls_segment <- split(df_segment, df_segment[[col_sample]])

  # Iterate over samples, writing data to individual files
  progress_bar = utils::txtProgressBar(min=0, max=nsamples, style = 3, char="=")
  i=0
  for (sample in names(ls_segment)){
    i <- i + 1
    utils::setTxtProgressBar(progress_bar, value=i, title = NULL, label = NULL)
    outfile = paste0(outdir, "/", sample, ".copynumber.tsv")
    file.create(outfile)
    df_ss_segment <- ls_segment[[sample]]
    utils::write.table(df_ss_segment, col.names = FALSE, row.names = FALSE, sep = "\t", file = outfile, append = TRUE, quote = FALSE)

    # Compress with bgzip
    if(bgzip){
      Rsamtools::bgzip(file = outfile)
      file.remove(outfile)
    }
  }

  message("\n")
  cli::cli_alert_success("Successfullly saved {nsamples} samples to  {.code <sample>.copynumber.tsv} files in {.path {outdir}}")

  # Invisibly return NULL
  return(invisible(NULL))
}
