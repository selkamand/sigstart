utils::globalVariables(c("Alt_Length", "FILTER", "Position_1based", "Ref_Length", "Reference_Allele",
                       "Tumor_Seq_Allele2", "name", "score"))


#' Convert VCFs into Sigminer-compatible MAF object
#'
#' This function reads a VCF file and converts it into a MAF-like structure compatible with Sigminer.
#' The conversion process includes renaming columns, filtering based on the FILTER field, and standardizing
#' allele representations.
#' The VCF file must be either a 1-sample tumor-only VCF or a 2-sample tumor-normal VCF.
#' If a 2-sample VCF is supplied, you must indicate which is the tumour sample using the\code{sample_id} argument.
#' Note this function assumes every mutation in the VCF relates to the \code{sample_id} supplied.
#' (If the VCF includes homozygous ref alleles for your sample of interest please filter these upstream)
#'
#' @param vcf_snv A character string specifying the path to the VCF file.
#' @param include Which variants to include in the final data.frame. Valid values include:
#'   \itemize{
#'     \item \strong{pass}: FILTER column is `PASS` or `.`.
#'     \item \strong{pass_strict}: FILTER column is `PASS`.
#'     \item \strong{all}: Include all variants in VCF regardless of FILTER status.
#'   }
#' @param sample_id  string representing the tumour sample identifier should be.
#' This is required if you supply a 2-sample tumour normal VCF.
#' Must be one of the samples described in the VCF.
#' @param allow_multisample Do NOT throw an error for VCFs with >2 samples.
#' Added since some tumor-normal pipelines add a third sample describing RNA genotypes of mutations found in DNA and these 3-sample VCFs would fail purely because they have 3 samples present.
#' Whether TRUE/FALSE, this function still assumes every mutation in the VCF relates to the \code{sample_id} supplied, so please exclude any homozygous ref alleles for your sample of interest upstream.
#' @param verbose verbose (flag)
#' @return A data.frame with the MAF-like structure, ready for use with Sigminer.
#' @export
#'
#' @examples
#' # Convert SNVs and Indels from VCF -> MAF-like structure for Sigminer
#' path_vcf_snv <- system.file("somatics.vcf", package = "sigstart")
#' parse_vcf_to_sigminer_maf(path_vcf_snv)
parse_vcf_to_sigminer_maf <- function(
    vcf_snv,
    sample_id = NULL,
    include = c("pass", "pass_strict", "all"),
    allow_multisample = FALSE,
    verbose = TRUE
  ){
  assertions::assert_file_exists(vcf_snv)
  include <- rlang::arg_match(include)

  vcf <- vcfR::read.vcfR(vcf_snv, verbose = FALSE)
  samples <- colnames(vcf@gt)[-1]
  nsamples <- length(samples)

  if(verbose) cli::cli_alert_info("Found {nsamples} samples described in the VCF [{samples}]")

  # Ensure VCF is a 2-sample tumour-normal or 1-sample tumor only
  if(!allow_multisample){
    assertions::assert(nsamples <= 2, msg = "{.code parse_vcf_to_sigminer_maf} does not currently support VCFs with > 2 samples [{nsamples} samples were found]. We expect either 1-sample tumor-only VCFs or 2-sample tumour-normal VCFs (the latter requires tumor sample ID is specified by user supplying the {.arg sample_id} argument.")
  }

  # If VSC is a 2-sample tumour-normal, ensure sample_id is specified (so we can pull out just the tumour)
  if(nsamples > 1 & is.null(sample_id)){
    cli::cli_abort("VCF contains multiple samples, but {.arg sample_id} has not been supplied to indicate which is the tumor sample")
  }

  # Filter VCF to describe only the tumour sample
  if(!is.null(sample_id)){
    assertions::assert_string(sample_id)
    assertions::assert_subset(sample_id, samples)

    if(verbose) cli::cli_alert_info("Returning data for only sample [{sample_id}] samples in format column of VCF.")

    vcf <- vcf[sample = sample_id]
  }


  if(nsamples == 0){
    cli::cli_abort("No samples could be found in the VCF {.path {vcf_snv}}. We do not currently support VCFs where genotype columns are missing")
  }

  df_vcf <- vcfR::vcfR2tidy(vcf, verbose=FALSE, single_frame = TRUE,toss_INFO_column = TRUE)[["dat"]]

  if(include == "pass")
    # Include FILTER = PASS / missing (e.g. `.`)
    # Note that vcfR parses '.' to NA_character
    df_vcf <- dplyr::filter(df_vcf, FILTER %in% c("PASS", ".", NA_character_))
  else if(include == "pass_strict")
    df_vcf <- dplyr::filter(df_vcf, FILTER == "PASS")
  else if(include == "all") {
    # Don't subset data at all
  }
  else
    stop("`include` = [", include, "] is not supported. Please open an issue on github and include this error message")

  dt_maf <- data.table::data.table(df_vcf)

  old_names <- c("CHROM", "POS", "Indiv", "REF", "ALT")
  new_names <- c("Chromosome", "Position_1based", "Tumor_Sample_Barcode", "Reference_Allele", "Tumor_Seq_Allele2")

  # Rename Columns
  data.table::setnames(
    dt_maf,
    old = old_names,
    new = new_names
  )

  # Calculate Ref and Alt lengths
  dt_maf[, "Ref_Length" := nchar(Reference_Allele)]
  dt_maf[, "Alt_Length" := nchar(Tumor_Seq_Allele2)]

  # Standardise Ref and Alt allele representations, and fix Lengths & Positions
  df_fixed <- fix_alleles(ref = dt_maf[["Reference_Allele"]], alt = dt_maf[["Tumor_Seq_Allele2"]])
  dt_maf[, "Ref_Length" := Ref_Length - df_fixed[["numdropped"]]]
  dt_maf[, "Alt_Length" := Alt_Length - df_fixed[["numdropped"]]]
  dt_maf[, "Position_1based" := Position_1based + df_fixed[["numdropped"]]]
  dt_maf[, "Reference_Allele" := df_fixed[["ref"]]]
  dt_maf[, "Tumor_Seq_Allele2" := df_fixed[["alt"]]]

  # Calculate Start_Position, End_Position, Variant_Types and Inframe status
  dt_maf[, "Start_Position" := data.table::fcase(
    # SNPs
    Ref_Length == Alt_Length, Position_1based,
    # Insertions (potentially with '-' Reference Alleles)
    Ref_Length < Alt_Length, ifelse(Reference_Allele == "-", yes = Position_1based - 1, Position_1based),
    # Deletions
    Ref_Length > Alt_Length, Position_1based,
    TRUE, stop("non-explicitly handled mutation type")
  )]
  dt_maf[, "End_Position" := data.table::fcase(
    # SNPs
    Ref_Length == Alt_Length, Position_1based + Alt_Length - 1,
    # Insertions (potentially with '-' Reference Alleles)
    Ref_Length < Alt_Length, ifelse(Reference_Allele == "-", yes = Position_1based, no = Position_1based + Ref_Length - 1),
    # Deletions
    Ref_Length > Alt_Length, Position_1based + Ref_Length - 1,
    TRUE, stop("non-explicitly handled mutation type")
  )]
  dt_maf[, "Inframe" := data.table::fcase(
    Ref_Length == Alt_Length, TRUE,
    abs(Ref_Length - Alt_Length) %% 3 == 0, TRUE,
    default = FALSE
  )]
  dt_maf[, "Variant_Type" := data.table::fcase(
    # SNPs
    Ref_Length == Alt_Length & Alt_Length == 1, "SNP",
    Ref_Length == Alt_Length & Alt_Length == 2, "DNP",
    Ref_Length == Alt_Length & Alt_Length == 3, "TNP",
    Ref_Length == Alt_Length & Alt_Length > 3, "ONP",
    # Insertions (potentially with '-' Reference Alleles)
    Ref_Length < Alt_Length, "INS",
    # Deletions
    Ref_Length > Alt_Length, "DEL",
    TRUE, stop("non-explicitly handled mutation type")
  )]

  if("gt_GT" %in% colnames(dt_maf)){
    n_hom_ref_variants <- sum(stats::na.omit(dt_maf[["gt_GT"]]) == "0/0")
    assertions::assert(n_hom_ref_variants == 0, msg = "Resulting MAF includes [{n_hom_ref_variants}] variants whose genotype are 0/0 (homozygous ref). Are you sure you've supplied an appropriate VCF file and {.arg sample_id} is truly a tumour sample?")
  }

  return(dt_maf)
}

#' Convert Gridss/Purple VCFs to BEDPE format
#'
#' See [sigminer::read_sv_as_rs()] for details about the format returned.
#' Note this sigminer dataset only includes breakpoints (single breakends will be excluded).
#' By default will only include PASS variants, which will exclude both PON and copy-number inferred breakpoints.
#'
#' @param vcf_sv path to a vcf file produced by GRIDSS / PURPLE (purple SV VCFs are typically the better choice since those are produced post-gripss filtering)
#' @inheritParams parse_vcf_to_sigminer_maf
#' @return data.frame of breakpoints in a sigminer compatible format "sample", "chr1", "start1", "end1", "chr2", "start2", "end2", "strand1", "strand2", "svclass"
#' @export
#'
#' @examples
#' path_vcf_sv <- system.file("tumor_sample.purple.sv.vcf", package = "sigstart")
#' parse_purple_sv_vcf_to_bedpe(path_vcf_sv)
#'
parse_purple_sv_vcf_to_bedpe <- function(vcf_sv, include = c("pass", "pass_strict", "all")){
  include <- rlang::arg_match(include)

  assertions::assert_file_exists(vcf_sv)

  vcf = VariantAnnotation::readVcf(vcf_sv)

  # Export breakpoints to BEDPE
  bpgr = StructuralVariantAnnotation::breakpointRanges(vcf)
  if(include == "pass_strict") {
    bpgr <- plyranges::filter(bpgr, FILTER == "PASS")
  }
  else if(include == "pass"){ # Allow PASS or missing
    bpgr <- plyranges::filter(bpgr, FILTER %in% c("PASS", "."))
  }
  else if(include == "all"){
     #"Include all variants"
  }

  bedpe <- StructuralVariantAnnotation::breakpointgr2bedpe(bpgr)
  return(bedpe)
}

#' TSV to MAF
#'
#' Convert a tabular file to a minimal MAF for signature analysis
#'
#' @param file path to tsv file describing variants
#' @param col_sample name of column containing sample ID
#' @param col_chrom  name of column containing chromosome
#' @param col_position name of column containing position
#' @param col_ref name of column describing ref allele
#' @param col_alt name of column describing alt allele
#' @param sep column delimiter
#'
#' @returns a maf-like minimal dataframe that can be parsed by [sigminer::read_maf_minimal()]
#' @export
#'
parse_tsv_to_sigminer_maf <- function(file, col_sample, col_chrom, col_position, col_ref, col_alt, sep = "\t"){
  assertions::assert_file_exists(file)

  df_tsv <- read.csv(file, header = TRUE, sep = sep)
  df2maf_minimal(df_tsv, ref_genome = NA, col_chrom = col_chrom, col_sample_identifier = col_sample, col_pos = col_position, col_ref = col_ref, col_alt = col_alt)
}


#' Convert Gridss/Purple VCFs to sigminer-compatible data.frame
#'
#' See [sigminer::read_sv_as_rs()] for details about the format returned.
#' Note this sigminer dataset only includes breakpoints (single breakends will be excluded).
#' By default will only include PASS variants, which will exclude both PON and copy-number inferred breakpoints.
#'
#' @param vcf_sv path to a vcf file produced by GRIDSS / PURPLE (purple SV VCFs are typically the better choice since those are produced post-gripss filtering)
#' @param sample_id string representing what the sample ID should be. Can be any valid string.
#' @inheritParams parse_vcf_to_sigminer_maf
#'
#' @return data.frame of breakpoints in a sigminer compatible format "sample", "chr1", "start1", "end1", "chr2", "start2", "end2", "strand1", "strand2", "svclass"
#' @export
#'
#' @examples
#' path_vcf_sv <- system.file("tumor_sample.purple.sv.vcf", package = "sigstart")
#' parse_purple_sv_vcf_to_sigminer(path_vcf_sv)
#'
parse_purple_sv_vcf_to_sigminer <- function(vcf_sv, sample_id = "Sample", include = c("pass", "pass_only", "all")){

  # Arg matching
  include <- rlang::arg_match(include)

  # Assertions
  assertions::assert_file_exists(vcf_sv)
  assertions::assert_string(sample_id)

  # Get Just the breakpoints
  bedpe <- parse_purple_sv_vcf_to_bedpe(vcf_sv, include = include)
  bedpe[["Sample"]] <- sample_id
  subset(bedpe, select=-c(name, score))
  sigminer <- relocate(bedpe, "Sample")
  sigminer <- rename(sigminer, c(chr1="chrom1", chr2="chrom2"))

  # Add SVclass
  sigminer[["svclass"]] <- with(sigminer, {
    dplyr::case_when(
      chr1 != chr2 ~ "translocation",
      strand1== "+" & strand2=="+" ~ "deletion",
      strand1== "-" & strand2=="-" ~ "tandem-duplication",
      strand1 != strand2 ~ "inversion",
      .default = "unsure"
    )})

  return(sigminer)
}

#'@inherit parse_purple_sv_vcf_to_bedpe
#'@export
parse_purple_sv_vcf_to_sigprofiler <- parse_purple_sv_vcf_to_bedpe


#' Parse CNVs to sigminer format
#'
#' Parse a single-sample copynumber segment file to sigminer compatible format.
#' \strong{This function assumes your segment file is single-sample}.
#' If you have a multi-sample copynumber file, see [convert_cohort_segment_file_to_single_samples()].
#' If working from oncoanalyser outputs see [parse_purple_cnv_to_sigminer()].
#'
#' @param segment path to segment file
#' @param sample_id string representing what the sample ID should be. Can be any valid string.
#' @param col_chromosome column in segment file describing chromosome of the copynumber change
#' @param col_start column in segment file describing start position of the copynumber change
#' @param col_end column in segment file describing end position of the copynumber change
#' @param col_copynumber column in segment file describing the total copynumber
#' @param col_minor_cn column in segment file describing the copynumber of the minor allele
#' @param exclude_sex_chromosomes drop sex chromosomes from dataframe output
#'
#' @return data.frame compatible with sigminer (containg the columns sample, chromosome, start, end, segVal, and minor_cn), ready for reading with [sigminer::read_copynumber()]
#'
#' @export
#'
#' @examples
#' path_cn <- system.file("COLO829v003T.purple.cnv.somatic.tsv", package = "sigstart")
#' parse_cnv_to_sigminer <- parse_purple_cnv_to_sigminer(path_cn, sample_id = "tumor_sample")
#'
parse_cnv_to_sigminer <- function(segment,
                                  sample_id = "Sample",
                                  col_chromosome = "chromosome",
                                  col_start = "start",
                                  col_end = "end",
                                  col_copynumber = "copyNumber",
                                  col_minor_cn = "minorAlleleCopyNumber",
                                  exclude_sex_chromosomes = TRUE
                                  ){
  # Gender
  if(!exclude_sex_chromosomes){
    cli::cli_abort("We do not recommend including taking sex chromosomes into account when examining copynumber signatures. Please set {.arg exclude_sex_chromosomes} argument of sigstarts {.code parse_purple_cnv_to_sigminer()} function to TRUE to automatically filter them out")
  }
  # Assertions
  assertions::assert_file_exists(segment)
  assertions::assert_string(sample_id)

  # Read File
  df_segment <- utils::read.csv(file = segment, header = TRUE, sep = "\t")
  assertions::assert_names_include(df_segment, c(col_chromosome,col_start, col_end, col_copynumber,col_minor_cn))

  # Rename and Add Columns
  df_segment <- rename(df_segment, c(Chromosome = col_chromosome, modal_cn = col_copynumber, Start.bp = col_start, End.bp = col_end, minor_cn = col_minor_cn))
  df_segment[["sample"]] <- sample_id

  # Select just the columns sigminer needs
  df_sigminer <- df_segment[c("sample", "Chromosome", "Start.bp", "End.bp", "modal_cn", "minor_cn")]

  if(exclude_sex_chromosomes){
    df_sigminer <- df_sigminer[!is_sex_chromosome(df_sigminer$Chromosome),]
  }

  return(df_sigminer)

}

#' Parse CNVs to sigminer format
#'
#' @inheritParams parse_cnv_to_sigminer
#' @inherit parse_cnv_to_sigminer return description
#'
#' @examples
#' path_cn <- system.file("COLO829v003T.purple.cnv.somatic.tsv", package = "sigstart")
#' sigminer_cn_dataframe <- parse_purple_cnv_to_sigminer(path_cn, sample_id = "tumor_sample")
#'
#' @export
parse_purple_cnv_to_sigminer <- function(
    segment,
    sample_id = "Sample",
    exclude_sex_chromosomes = TRUE
    ){

  # Call parse_cnv_to_sigminer with the expected column names for purple
  df_sigminer <- parse_cnv_to_sigminer(
    segment,
    sample_id = sample_id,
    col_chromosome = "chromosome",
    col_start = "start",
    col_end = "end",
    col_copynumber = "copyNumber",
    col_minor_cn = "minorAlleleCopyNumber",
    exclude_sex_chromosomes = exclude_sex_chromosomes
    )

  return(df_sigminer)
}


