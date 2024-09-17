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
