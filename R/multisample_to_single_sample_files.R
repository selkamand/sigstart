#' Convert MAF-like File to Single Sample VCFs
#'
#' This function takes a path to a MAF-like file and creates a collection of single-sample VCFs.
#' Note that this is **NOT** a lossless operation.
#' Only the most basic information is kept to ensure VCFs remain simple.
#' FORMAT and sample columns are added with Genotypes 'missing' for all alleles to
#' as this information is not automatically extracted from the MAF.
#'
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
#' @param verbose verbose mode (flag).
#' @param bgzip compress and index vcf file (flag).
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
                                bgzip = TRUE,
                                verbose = TRUE
){

  # Assertions
  assertions::assert_file_exists(path)
  assertions::assert_directory_does_not_exist(outdir, msg = "Directory {.path {outdir}} already exists. Please remove then try again")
  requireNamespace("Rsamtools", quietly = TRUE)

  # Read MAF (first 10 lines only)
  df_maf <- data.table::fread(path, nrows = 5)

  # Ensure We Have all the right columns
  assertions::assert_names_include(df_maf, c(col_sample,  col_chrom, col_start_position, col_end_position, col_ref, col_alt))

  # If the maf has all the right column names, read the full MAF
  df_maf <- data.table::fread(path)

  # Count Samples
  samples <- unique(df_maf[[col_sample]])
  nsamples <- length(samples)
  if(verbose) cli::cli_alert_info("Found a total of {nsamples} samples in the MAF file")

  # Create output directory
  dir.create(outdir, recursive = TRUE)

  # Split Samples
  ls_maf <- split(df_maf, df_maf[[col_sample]])

  # Iterate over samples, writing data to individual files
  if(verbose) progress_bar = utils::txtProgressBar(min=0, max=nsamples, style = 3, char="=")
  i=0
  for (sample in names(ls_maf)){
    i <- i + 1
    if(verbose) utils::setTxtProgressBar(progress_bar, value=i, title = NULL, label = NULL)
    outfile = paste0(outdir, "/", sample, ".snv_indel.vcf")
    file.create(outfile)
    df_ss_maf <- ls_maf[[sample]]
    df_vcf <- data.frame(
      CHROM = df_ss_maf[[col_chrom]],
      POS = df_ss_maf[[col_start_position]],
      ID = seq_along(df_ss_maf[[col_chrom]]),
      REF = df_ss_maf[[col_ref]],
      ALT = df_ss_maf[[col_alt]],
      QUAL = ".",
      FITLER = ".",
      INFO = ".",
      FORMAT = "GT",
      SAMPLE = "./."
    )

    # Sort VCF dataframe
    df_vcf <- df_vcf[order(df_vcf$CHROM, df_vcf$POS), ]

    # Write VCF header
    write("##fileformat=VCFv4.2", file = outfile, append = FALSE)
    write(paste0("##sample=", sample), file = outfile, append = TRUE)
    write('##FORMAT=<ID=GT,Number=1,Type=String,Description="Genotype">', ncolumns = 1, file = outfile, append = TRUE)
    write(paste0("#CHROM\tPOS\tID\tREF\tALT\tQUAL\tFILTER\tINFO\tFORMAT\t",sample), file = outfile, append = TRUE)

    # Write VCF body
    utils::write.table(df_vcf, col.names = FALSE, row.names = FALSE, sep = "\t", file = outfile, append = TRUE, quote = FALSE)

    # Compress with bgzip
    if(bgzip){
      Rsamtools::bgzip(file = outfile)
      file.remove(outfile)
      Rsamtools::indexTabix(paste0(outfile, ".bgz"), format="vcf")
    }
  }


  if(verbose) {
    message("\n")
    cli::cli_alert_success("Successfullly saved {nsamples} samples to  {.code <sample>.snv_indel.vcf} files in {.path {outdir}}")
  }

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
#' @param rename_columns should the output file column names be changed to specifically default expectations of [parse_cnv_to_sigminer()].
#' If TRUE, will also drop all column not specified by \strong{col_<propertyy>} arguments.
#' @param verbose verbose mode (flag)
#' @inheritParams parse_cnv_to_sigminer
#'
#' @return A vector with paths to each single sample copynumber segment file. Creates single sample copynumber segment files in the specified output directory.
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
    col_copynumber = "copyNumber",
    col_minor_cn = "minorAlleleCopyNumber",
    rename_columns = TRUE,
    outdir = "cnvs",
    bgzip = TRUE,
    verbose=TRUE
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
  if(verbose) cli::cli_alert_info("Found a total of {nsamples} samples in the segment file {.path {segment}}")

  # Create output directory
  dir.create(outdir, recursive = TRUE)

  # Split Samples
  ls_segment <- split(df_segment, df_segment[[col_sample]])

  # Iterate over samples, writing data to individual files
  if(verbose) progress_bar = utils::txtProgressBar(min=0, max=nsamples, style = 3, char="=")
  i=0

  ls_files <- list()
  for (sample in names(ls_segment)){
    i <- i + 1
    if(verbose) utils::setTxtProgressBar(progress_bar, value=i, title = NULL, label = NULL)
    outfile = paste0(outdir, "/", sample, ".copynumber.tsv")
    ls_files[[sample]] <- outfile
    df_ss_segment <- ls_segment[[sample]]
    df_ss_segment[[col_sample]] <- NULL # drop sample column (sample encoded in filename)

    # Rename (& select) Columns
    if(rename_columns){
      df_ss_segment <- sigshared::bselect(df_ss_segment, c(
        "chromosome" = col_chromosome,
        "start" = col_start,
        "end" = col_end,
        "copyNumber" = col_copynumber,
        "minorAlleleCopyNumber" = col_minor_cn))
    }

    # Write To File
    utils::write.table(df_ss_segment, col.names = TRUE, row.names = FALSE, sep = "\t", file = outfile, append = FALSE, quote = FALSE)

    # Compress with bgzip
    if(bgzip){
      Rsamtools::bgzip(file = outfile)
      file.remove(outfile)
    }
  }


  if(verbose) {
    message("\n")
    cli::cli_alert_success("Successfullly saved {nsamples} samples to  {.code <sample>.copynumber.tsv} files in {.path {outdir}}")
  }

  # Files
  return(unlist(ls_files))
}
