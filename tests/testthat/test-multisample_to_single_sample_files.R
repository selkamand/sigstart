
# MAF to VCFs -------------------------------------------------------------

# Test for convert_maf_to_vcfs function
test_that("convert_maf_to_vcfs works correctly with valid input", {
  # Setup: Use a sample MAF file from the sigstart package
  path_maf <- system.file("pcawg.3sample.snvs_indel.maf", package = "sigstart")
  expect_true(file.exists(path_maf))

  # Create a temporary output directory using withr::withr::local_tempdir()
  tmp_dir <- withr::local_tempdir()
  outdir <- paste0(tmp_dir, "/vcfs")
  # Run the function
  expect_no_error(convert_maf_to_vcfs(path_maf, outdir = outdir, bgzip=FALSE, verbose = FALSE))

  # Check that output directory contains VCF files
  vcf_files <- list.files(outdir, pattern = "\\.snv_indel\\.vcf$", full.names = TRUE)
  expect_gt(length(vcf_files), 0)

  # Snapshot test: For each VCF file, compare its content to a stored snapshot
  for (vcf_file in vcf_files) {
    # Snapshot
    expect_snapshot_file(vcf_file)

    # Parse MAF
    df_maf <- expect_no_error(parse_vcf_to_sigminer_maf(vcf_file, verbose = FALSE))
    expect_true(nrow(df_maf) > 0)
    expect_snapshot(df_maf)
  }
})

test_that("convert_maf_to_vcfs fails with non-existent input file", {
  path_maf <- "non_existent_file.maf"

  tmp_dir <- withr::local_tempdir()
  outdir <- paste0(tmp_dir, "/vcfs")
  expect_error(
    convert_maf_to_vcfs(path_maf, outdir = outdir, verbose = FALSE),
    regexp = "Failed to find file"
  )
})

test_that("convert_maf_to_vcfs fails when required columns are missing", {
  df_maf <- data.table(
    Chromosome = c("1", "2"),
    Start_Position = c(100000, 200000),
    End_Position = c(100001, 200001),
    Reference_Allele = c("A", "T"),
    Tumor_Seq_Allele2 = c("G", "C")
    # Missing 'Tumor_Sample_Barcode'
  )
  temp_maf <- withr::local_file("unorthodox_maf_file")
  write.table(df_maf, temp_maf,sep = "\t", quote = FALSE, col.names = TRUE, row.names = FALSE)

  tmp_dir <- withr::local_tempdir()
  outdir <- paste0(tmp_dir, "/vcfs")

  expect_error(
    convert_maf_to_vcfs(temp_maf, outdir = outdir, verbose = FALSE),
    regexp = "missing.*Tumor_Sample_Barcode"
  )
})


# Cohort CNV to single sample ---------------------------------------------

# Test for convert_cohort_segment_file_to_single_samples function
test_that("convert_cohort_segment_file_to_single_samples works correctly with valid input", {
  # Setup: Use a sample CNV segment file from the sigstart package
  path_cnv <- system.file("pcawg.3sample.copynumber.segment", package = "sigstart")
  expect_true(file.exists(path_cnv))

  # Create a temporary output directory using withr::local_tempdir()
  tmp_dir <- withr::local_tempdir()
  outdir <- file.path(tmp_dir, "cnvs")

  # Run the function
  expect_no_error(convert_cohort_segment_file_to_single_samples(
    segment = path_cnv,
    outdir = outdir,
    bgzip = FALSE,
    verbose = FALSE
  ))



  # Check that output directory contains CNV files
  cnv_files <- list.files(outdir, pattern = "\\.copynumber\\.tsv$", full.names = TRUE)
  expect_gt(length(cnv_files), 0)


  #announce_snapshot_file(name = basename(cnv_file))
  # For each CNV file, check that it can be parsed by parse_cnv_to_sigminer without error
  for (cnv_file in cnv_files) {
    sample_id <- sub("\\..*$", "", basename(cnv_file))
    df_cnv <- expect_no_error(parse_cnv_to_sigminer(cnv_file, sample_id = sample_id))

    # Snapshot test: compare the CNV file to a stored snapshot
    expect_true(file.exists(cnv_file), info = paste("File not found:", cnv_file))
    expect_snapshot(read.delim(cnv_file, header = TRUE, sep = "\t"))
    expect_snapshot(df_cnv)
  }
})

test_that("convert_cohort_segment_file_to_single_samples fails when input file does not exist", {
  # Provide a non-existent input file
  path_cnv <- "non_existent_file.tsv"
  expect_false(file.exists(path_cnv))

  # Run the function, expecting an error
  expect_error(convert_cohort_segment_file_to_single_samples(
    segment = path_cnv,
    outdir = "some_dir"
  ), "Failed to find file.*non_existent_file.tsv")
})

test_that("convert_cohort_segment_file_to_single_samples fails when output directory already exists", {
  # Setup: Use a sample CNV segment file from the sigstart package
  path_cnv <- system.file("pcawg.3sample.copynumber.segment", package = "sigstart")
  expect_true(file.exists(path_cnv))

  # Create a temporary output directory
  tmp_dir <- withr::local_tempdir()
  outdir <- file.path(tmp_dir, "cnvs")

  # Create the output directory before running the function
  dir.create(outdir, recursive = TRUE)

  # Run the function, expecting an error
  expect_error(convert_cohort_segment_file_to_single_samples(
    segment = path_cnv,
    outdir = outdir,
    verbose = FALSE
  ), "Directory .* already exists")
})

