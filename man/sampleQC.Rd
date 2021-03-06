% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/sampleQC.R
\name{sampleQC}
\alias{sampleQC}
\title{The wrap-up function for sample QC of sequencing/GWAS data.}
\usage{
sampleQC(vfile = NULL, output = "sampleqc", capture.region = NULL,
  sample.annot = NULL, LDprune = TRUE, vfile.restrict = FALSE,
  slide.max.bp = 5e+05, ld.threshold = 0.3, format.data = "NGS",
  format.file = "vcf", QCreport = TRUE, out.report = "report.html",
  interactive = TRUE, results = TRUE, plotting = TRUE, ...)
}
\arguments{
\item{vfile}{vcf or PLINK input file (ped/map/bed/bim/fam with same
basename). The default is NULL. Vfile could be a vector of
character strings, see details. Could also take file in
\code{SeqSQC} object generated from \code{LoadVfile}.}

\item{output}{a character string for name of merged data of SeqSQC
object. The \code{dirname(output)} would be used as the
directory to save the QC result and plots. The default is
\code{sampleqc} in the working directory.}

\item{capture.region}{the BED file of sequencing capture
regions. The default is NULL. For exome-sequencing data, the
capture region file must be provided.}

\item{sample.annot}{sample annotation file with 3 columns (with
header) in the order of sample id, sample population and sex
info. The default is NULL.}

\item{LDprune}{whether to use LD-pruned snp set. The default is
TRUE.}

\item{vfile.restrict}{whether the input vcf or plink file has
already been restricted by capture region. The default is
FALSE.}

\item{slide.max.bp}{the window size of SNPs when calculating
linkage disequilibrium. The default is 5e+05.}

\item{ld.threshold}{the r^2 threshold for LD-based SNP pruning if
\code{LDprune = TRUE}. The default is 0.3.}

\item{format.data}{the data source. The default is \code{NGS} for
sequencing data.}

\item{format.file}{the data format. The default is \code{vcf}.}

\item{QCreport}{Whether to generate the sample QC report in html
format.}

\item{out.report}{the file name for the sample QC report. The
default is \code{report.html}.}

\item{interactive}{whether to generate interactive plots in the
sample QC report if \code{QCreport = TRUE}.}

\item{results}{whether to write out the results for each QC steps
in .txt files. The default is TRUE.}

\item{plotting}{whether to output the plots for each QC steps in
.pdf files. the default is TRUE.}

\item{...}{Arguments to be passed to other methods.}
}
\value{
a SeqSQC object with the filepath to the gds file which
    stores the genotype, the summary of samples and variants, and
    the QCresults including the sample annotation information and
    all QC results.
}
\description{
A wrap-up function for sample QC. It reads in the variant genotypes
in vcf/PLINK format, merges study cohort with benchmark data, and
performs sample QC for the merged dataset.
}
\details{
For \code{vfile} with more than one file names,
    \code{sampleQC} will merge all dataset together if they all
    contain the same samples. It is useful to combine
    genetic/genomic data together if VCF data is divided by
    chromosomes. \cr There are 3 columns in \code{sample.annot}
    file. col 1 is \code{sample} with sample ids, col 2 is
    \code{population} with values of "AFR/EUR/ASN/EAS/SAS", col 3
    is \code{gender} with values of "male/female".
}
\examples{
\dontrun{
infile <- system.file("extdata", "example_sub.vcf", package="SeqSQC")
sample.annot <- system.file("extdata", "sampleAnnotation.txt", package="SeqSQC")
cr <- system.file("extdata", "CCDS.Hs37.3.reduced_chr1.bed", package="SeqSQC")
outfile <- file.path(tempdir(), "testWrapUp")
seqfile <- sampleQC(vfile = infile, output = outfile, capture.region = cr,
sample.annot = sample.annot, format.data = "NGS", format.file = "vcf",
QCreport = TRUE, out.report="report.html", interactive = TRUE)
## save(seqfile, file="seqfile.RData")

load(system.file("extdata", "example.seqfile.Rdata", package="SeqSQC"))
gfile <- system.file("extdata", "example.gds", package="SeqSQC")
seqfile <- SeqSQC(gdsfile = gfile, QCresult = QCresult(seqfile))
seqfile <- sampleQC(sfile = seqfile, output = outfile, QCreport = FALSE,
out.report="report.html", interactive = TRUE)
}
}
\author{
Qian Liu \email{qliu7@buffalo.edu}
}
