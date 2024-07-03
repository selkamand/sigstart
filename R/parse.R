utils::globalVariables(c("Alt_Length", "FILTER", "Position_1based", "Ref_Length", "Reference_Allele",
                       "Tumor_Seq_Allele2", "name", "score"))

# Changing Ref:
# While the first Char of Reference_Allele and Tumor_Seq_Allele2 are the same, and both are non-empty
# go char by char and if the first char of Ref and Alt are the same, drop them. If empty - replace with a '-'
# Each time you drop a char, add 1 to Position_1based, and decrease 1 from --$ref_length; --$var_length;

# Need to add info about alleles
fix_alleles_scalar <- function(ref, alt) {
  # Assert both scalar: had to comment out because was taking too much time
  #assertions::assert_string(ref)
  #assertions::assert_string(alt)

  numdropped <- 0
  while (nchar(ref) != 0 & nchar(alt) != 0 & substr(ref, 1, 1) == substr(alt, 1, 1) & ref != alt) {
    ref <- substr(ref, 2, nchar(ref))
    alt <- substr(alt, 2, nchar(alt))
    if (nchar(ref) == 0) ref <- "-"
    if (nchar(alt) == 0) alt <- "-"
    numdropped <- numdropped + 1
  }

  list(ref = ref, alt = alt, numdropped = numdropped)
}

# Returns a 3col dataframe.
# 'ref': new reference allele
# 'alt': new alt allele
# 'numdropped': number of chars dropped from the start of reference/alt.
# numdropped should be subtracted from Ref_Length & Alt_Length and added to Pos
fix_alleles <- function(ref, alt) {
  assertions::assert_equal(length(ref), length(alt))


  ls_fixed_alleles <- lapply(seq_along(ref), FUN = function(i) {
    fix_alleles_scalar(
      ref = ref[i],
      alt = alt[i]
    )
  })

  df <- as.data.frame(do.call(rbind, ls_fixed_alleles), stringsAsFactors = FALSE)

  # Remove unnecessary list-ing of dataframe columns
  for (col in colnames(df)) {
    df[[col]] <- unlist(df[[col]])
  }

  return(df)
}

#' Convert VCFs into Sigminer-compatible MAF object
#'
#' This function reads a VCF file and converts it into a MAF-like structure compatible with Sigminer.
#' The conversion process includes renaming columns, filtering based on the FILTER field, and standardizing
#' allele representations.
#'
#' @param vcf_snv A character string specifying the path to the VCF file.
#' @param pass_only A logical value indicating whether to filter variants to include only those with a "PASS" filter status. Default is TRUE.
#' @return A data.frame with the MAF-like structure, ready for use with Sigminer.
#' @export
#'
#' @examples
#' # Convert SNVs and Indels from VCF -> MAF-like structure for Sigminer
#' path_vcf_snv <- system.file("somatics.vcf", package = "sigstart")
#' parse_vcf_to_sigminer_maf(path_vcf_snv)
parse_vcf_to_sigminer_maf <- function(vcf_snv, pass_only = TRUE){

  vcf <- vcfR::read.vcfR(vcf_snv, verbose = FALSE)
  df_vcf <- vcfR::vcfR2tidy(vcf, verbose=FALSE, single_frame = TRUE,toss_INFO_column = TRUE)[["dat"]]

  if(pass_only)
    df_vcf <- dplyr::filter(df_vcf, FILTER == "PASS")
  #return(vcf2mafR::df2maf(df_vcf, col_chrom = "CHROM", col_alt = "ALT", col_ref = "REF", col_sample_identifier = "Indiv"))

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

  return(dt_maf)
}

#' Convert Gridss/Purple VCFs to BEDPE format
#'
#' See [sigminer::read_sv_as_rs()] for details about the format returned.
#' Note this sigminer dataset only includes breakpoints (single breakends will be excluded).
#' By default will only include PASS variants, which will exclude both PON and copy-number inferred breakpoints.
#'
#' @param vcf_sv path to a vcf file produced by GRIDSS / PURPLE (purple SV VCFs are typically the better choice since those are produced post-gripss filtering)
#' @param pass_only only return breakpoints where FILTER=PASS
#'
#' @return data.frame of breakpoints in a sigminer compatible format "sample", "chr1", "start1", "end1", "chr2", "start2", "end2", "strand1", "strand2", "svclass"
#' @export
#'
#' @examples
#' path_vcf_sv <- system.file("tumor_sample.purple.sv.vcf", package = "sigstart")
#' parse_purple_sv_vcf_to_bedpe(path_vcf_sv)
#'
parse_purple_sv_vcf_to_bedpe <- function(vcf_sv, pass_only = TRUE){
  assertions::assert_file_exists(vcf_sv)

  vcf = VariantAnnotation::readVcf(vcf_sv)

  # Export breakpoints to BEDPE
  bpgr = StructuralVariantAnnotation::breakpointRanges(vcf)
  if(pass_only) {
    bpgr <- plyranges::filter(bpgr, FILTER == "PASS")
  }

  bedpe <- StructuralVariantAnnotation::breakpointgr2bedpe(bpgr)
  return(bedpe)
}


#' Convert Gridss/Purple VCFs to sigminer-compatible data.frame
#'
#' See [sigminer::read_sv_as_rs()] for details about the format returned.
#' Note this sigminer dataset only includes breakpoints (single breakends will be excluded).
#' By default will only include PASS variants, which will exclude both PON and copy-number inferred breakpoints.
#'
#' @param vcf_sv path to a vcf file produced by GRIDSS / PURPLE (purple SV VCFs are typically the better choice since those are produced post-gripss filtering)
#' @param sample_id string representing what the sample ID should be. Can be any valid string.
#' @param pass_only only return breakpoints where FILTER=PASS
#'
#' @return data.frame of breakpoints in a sigminer compatible format "sample", "chr1", "start1", "end1", "chr2", "start2", "end2", "strand1", "strand2", "svclass"
#' @export
#'
#' @examples
#' path_vcf_sv <- system.file("tumor_sample.purple.sv.vcf", package = "sigstart")
#' parse_purple_sv_vcf_to_sigminer(path_vcf_sv)
#'
parse_purple_sv_vcf_to_sigminer <- function(vcf_sv, sample_id = "Sample", pass_only = TRUE){

  # Assertions
  assertions::assert_file_exists(vcf_sv)
  assertions::assert_string(sample_id)

  # Get Just the breakpoints
  bedpe <- parse_purple_sv_vcf_to_bedpe(vcf_sv, pass_only = pass_only)
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
#' @param segment path to segment file produced by purple (TUMOR.purple.cnv.somatic.tsv)
#' @param sample_id string representing what the sample ID should be. Can be any valid string.
#' @param ignore_gender should gen
#' @return data.frame compatible with sigminer (containg the columns sample, chromosome, start, end, segVal, and minor_cn)
#' @export
#'
parse_purple_cnv_to_sigminer <- function(segment, sample_id = "Sample", exclude_sex_chromosomes = TRUE){

  # Gendder
  if(!exclude_sex_chromosomes){
   cli::cli_abort("We do not recommend including taking sex chromosomes into account when examining copynumber signatures. Please set {.arg exclude_sex_chromosomes} argument of sigstarts {.code parse_purple_cnv_to_sigminer()} function to TRUE to automatically filter them out")
  }
  # Assertions
  assertions::assert_file_exists(segment)
  assertions::assert_string(sample_id)

  # Read File
  df_segment <- utils::read.csv(file = segment, header = TRUE, sep = "\t")

  # Rename and Add Columns
  df_segment <- rename(df_segment, c(Chromosome = "chromosome", modal_cn = "copyNumber", Start.bp = "start", End.bp = "end", minor_cn = "minorAlleleCopyNumber"))
  df_segment[["sample"]] <- sample_id

  # Select just the columns sigminer needs
  df_sigminer <- df_segment[c("sample", "Chromosome", "Start.bp", "End.bp", "modal_cn", "minor_cn")]

  if(exclude_sex_chromosomes){
    df_sigminer <- df_sigminer[!is_sex_chromosome(df_sigminer$Chromosome), ]
  }

  return(df_sigminer)
}


is_sex_chromosome <- function(chr, verbose = FALSE){
  chrom_prefixes <- c("chr", "Chr", "CHR","chrom", "CHROM", "")
  sex_chromosomes <- c("x", "X", "y", "Y")
  df_chroms <- expand.grid(chrom_prefixes, sex_chromosomes)
  potential_sex_chroms <- paste0(df_chroms[[1]], df_chroms[[2]])

  if(verbose){
   message("Checking for potential sex chromosomes: ", paste0(potential_sex_chroms, collapse = ", "))
  }
  chr %in% potential_sex_chroms
}

relocate <- function(df, cols){
  df[c(cols, setdiff(colnames(df), cols))]
}

rename <- function(df, map){
  colnames(df) <- ifelse(
    colnames(df) %in% map,
    yes = names(map)[match(colnames(df), map)],
    no=colnames(df)
  )
  return(df)
}
