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
  df_maf <- parse_vcf_to_sigminer_maf(path_vcf, verbose=FALSE)


  expect_true(is.data.frame(df_maf))
  expect_true(all(c("Chromosome", "Tumor_Sample_Barcode", "Reference_Allele", "Tumor_Seq_Allele2", "Start_Position", "End_Position", "Variant_Type") %in% colnames(df_maf)))
  expect_equal(unique(df_maf$Tumor_Sample_Barcode), "sample")

  # Add a snapshot test
  expect_snapshot(df_maf)
})

test_that("parse_vcf_to_sigminer_maf works correctly with tumor_normal samples", {
  path_vcf <- system.file("tumor_normal.purple.somatic.vcf.gz", package = "sigstart")

  expect_error(parse_vcf_to_sigminer_maf(path_vcf, verbose=FALSE), "VCF contains multiple samples, but `sample_id` has not been supplied")
  expect_error(parse_vcf_to_sigminer_maf(path_vcf, verbose=FALSE, sample_id = "normal_sample"), "Resulting MAF includes .* variants whose genotype are 0/0")
  expect_error(parse_vcf_to_sigminer_maf(path_vcf, verbose=FALSE, sample_id = "made_up_sample"), "Valid values include: normal_sample and tumor_sample")
  expect_error(parse_vcf_to_sigminer_maf(path_vcf, verbose=FALSE, sample_id = "tumor_sample"), NA)

  df_maf <- parse_vcf_to_sigminer_maf(path_vcf, verbose=FALSE, sample_id = "tumor_sample")


  expect_true(is.data.frame(df_maf))
  expect_true(all(c("Chromosome", "Tumor_Sample_Barcode", "Reference_Allele", "Tumor_Seq_Allele2", "Start_Position", "End_Position", "Variant_Type") %in% colnames(df_maf)))
  expect_equal(nrow(df_maf), 2827)

  # Add a snapshot test
  expect_snapshot(df_maf)
})

test_that("parse_vcf_to_sigminer_maf works correctly with tumor_normal_rna samples", {
  path_vcf <- system.file("tumor_normal_rna.purple.somatic.vcf.gz", package = "sigstart")

  expect_error(parse_vcf_to_sigminer_maf(path_vcf, allow_multisample = TRUE, verbose=FALSE), "VCF contains multiple samples, but `sample_id` has not been supplied")
  expect_error(parse_vcf_to_sigminer_maf(path_vcf, allow_multisample = TRUE, verbose=FALSE, sample_id = "normal_sample"), "Resulting MAF includes .* variants whose genotype are 0/0")
  expect_error(parse_vcf_to_sigminer_maf(path_vcf, allow_multisample = TRUE, verbose=FALSE, sample_id = "made_up_sample"), "Valid values include: normal_sample, tumor_sample, and rna_sample")
  expect_error(parse_vcf_to_sigminer_maf(path_vcf, allow_multisample = TRUE, verbose=FALSE, sample_id = "tumor_sample"), NA)

  df_maf <- parse_vcf_to_sigminer_maf(path_vcf, allow_multisample = TRUE, verbose=FALSE, sample_id = "tumor_sample")


  expect_true(is.data.frame(df_maf))
  expect_true(all(c("Chromosome", "Tumor_Sample_Barcode", "Reference_Allele", "Tumor_Seq_Allele2", "Start_Position", "End_Position", "Variant_Type") %in% colnames(df_maf)))
  expect_equal(nrow(df_maf), 2827)

  # Add a snapshot test
  expect_snapshot(df_maf)
})

test_that("parse_purple_sv_vcf_to_bedpe works correctly", {
  path_vcf_sv <- system.file("tumor_sample.purple.sv.vcf", package = "sigstart")

  bedpe <- parse_purple_sv_vcf_to_bedpe(path_vcf_sv)

  expect_true(is.data.frame(bedpe))
  expect_named(bedpe, c("chrom1", "start1", "end1", "chrom2", "start2", "end2", "name", "score", "strand1", "strand2"))

  # Add a snapshot test
  expect_snapshot(bedpe)
})

test_that("parse_purple_sv_vcf_to_sigminer works correctly", {
  path_vcf_sv <- system.file("tumor_sample.purple.sv.vcf", package = "sigstart")
  sample_id <- "Sample"

  sigminer <- parse_purple_sv_vcf_to_sigminer(path_vcf_sv, sample_id = sample_id)

  expect_true(is.data.frame(sigminer))
  expect_true(all(c("Sample", "chr1", "start1", "end1", "chr2", "start2", "end2", "strand1", "strand2", "svclass") %in% colnames(sigminer)))
  expect_equal(sigminer$Sample[1], sample_id)

  # Add a snapshot test
  expect_snapshot(sigminer)
})


test_that("parse_purple_cnv_to_sigminer works correctly", {
  path_cn <- system.file("COLO829v003T.purple.cnv.somatic.tsv", package = "sigstart")

  sample_id = "bobby"
  expect_error(parse_purple_cnv_to_sigminer(path_cn, sample_id = sample_id), NA)
  sigminer <- parse_purple_cnv_to_sigminer(path_cn, sample_id = sample_id)

  expect_true(is.data.frame(sigminer))
  expect_true(all(c("sample", "Chromosome", "Start.bp", "End.bp", "modal_cn", "minor_cn") %in% colnames(sigminer)))
  expect_equal(sigminer$sample[1], sample_id)

  # Doesnt include sex chromosomes
  expect_true(!any(c("chrX", "chrY") %in% sigminer[["Chromosome"]]))

  # Add a snapshot test
  expect_snapshot(sigminer)

})


test_that("parse_purple_cnv_to_sigminer & parse_cnv_to_sigminer work the same", {

  # parse_cnv_to_sigminer is a generalised version of parse_purple_cnv_to_sigminer
  # that lets users specify column name mappings and therefore read in any filetype
  # but the default column names are set up for purple
  path_cn <- system.file("COLO829v003T.purple.cnv.somatic.tsv", package = "sigstart")

  sample_id = "bobby"
  sigminer_purple_cnv <- expect_no_error(parse_purple_cnv_to_sigminer(path_cn, sample_id = sample_id))
  sigminer_cnv <- expect_no_error(parse_cnv_to_sigminer(path_cn, sample_id = sample_id))

  expect_equal(sigminer_purple_cnv, sigminer_cnv)
})


