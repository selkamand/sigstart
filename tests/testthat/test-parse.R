test_that("fix_alleles_scalar works correctly", {
  result <- fix_alleles_scalar("ATCG", "ATG")
  expect_equal(result$ref, "CG")
  expect_equal(result$alt, "G")
  expect_equal(result$numdropped, 2)

  result <- fix_alleles_scalar("A", "T")
  expect_equal(result$ref, "A")
  expect_equal(result$alt, "T")
  expect_equal(result$numdropped, 0)

  result <- fix_alleles_scalar("AT", "A-")
  expect_equal(result$ref, "T")
  expect_equal(result$alt, "-")
  expect_equal(result$numdropped, 1)
})

test_that("fix_alleles works correctly", {
  ref <- c("ATCG", "A", "AT")
  alt <- c("ATG", "T", "A-")
  result <- fix_alleles(ref, alt)

  expect_equal(result$ref, c("CG", "A", "T"))
  expect_equal(result$alt, c("G", "T", "-"))
  expect_equal(result$numdropped, c(2, 0, 1))
})

test_that("parse_vcf_to_sigminer_maf works correctly", {
  path_vcf <- system.file("somatics.vcf", package = "sigstart")

  df_maf <- parse_vcf_to_sigminer_maf(path_vcf, pass_only = TRUE)

  expect_true(is.data.frame(df_maf))
  expect_true(all(c("Chromosome", "Tumor_Sample_Barcode", "Reference_Allele", "Tumor_Seq_Allele2", "Start_Position", "End_Position", "Variant_Type") %in% colnames(df_maf)))
})

test_that("parse_purple_sv_vcf_to_bedpe works correctly", {
  path_vcf_sv <- system.file("tumor_sample.purple.sv.vcf", package = "sigstart")

  bedpe <- parse_purple_sv_vcf_to_bedpe(path_vcf_sv, pass_only = TRUE)

  expect_true(is.data.frame(bedpe))
  expect_named(bedpe, c("chrom1", "start1", "end1", "chrom2", "start2", "end2", "name", "score", "strand1", "strand2"))
})

test_that("parse_purple_sv_vcf_to_sigminer works correctly", {
  path_vcf_sv <- system.file("tumor_sample.purple.sv.vcf", package = "sigstart")
  sample_id <- "Sample"

  sigminer <- parse_purple_sv_vcf_to_sigminer(path_vcf_sv, sample_id = sample_id, pass_only = TRUE)

  expect_true(is.data.frame(sigminer))
  expect_true(all(c("Sample", "chr1", "start1", "end1", "chr2", "start2", "end2", "strand1", "strand2", "svclass") %in% colnames(sigminer)))
  expect_equal(sigminer$Sample[1], sample_id)
})
