% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/Inbreeding.R
\name{Inbreeding}
\alias{Inbreeding}
\title{Sample inbreeding check with SeqSQC object input file.}
\usage{
Inbreeding(seqfile, remove.samples = NULL, LDprune = TRUE,
  missing.rate = 0.1, ss.cutoff = 300, maf = 0.01, hwe = 1e-06,
  ...)
}
\arguments{
\item{seqfile}{SeqSQC object, which includes the merged gds file
for study cohort and benchmark.}

\item{remove.samples}{a vector of sample names for removal from
inbreeding coefficient calculation. Could be problematic
samples identified from previous QC steps, or user-defined
samples.}

\item{LDprune}{whether to use LD-pruned snp set. The default is
TRUE.}

\item{missing.rate}{to use the SNPs with "<= \code{missing.rate}"
only; if NaN, no threshold. By default, we use
\code{missing.rate = 0.1} to filter out variants with missing
rate greater than 10\%.}

\item{ss.cutoff}{the minimum sample size (300 by default) to apply
the MAF filter. This sample size is the sum of study samples
and the benchmark samples of the same population as the study
cohort.}

\item{maf}{to use the SNPs with ">= \code{maf}" if sample size
defined in above argument is greater than \code{ss.cutoff};
otherwise NaN is used by default for no MAF threshold.}

\item{hwe}{to use the SNPs with Hardy-Weinberg equilibrium p >=
\code{hwe} if sample size defined in above argument is greater
than \code{ss.cutoff}; otherwise no hwe threshold. The default
is 1e-6.}

\item{...}{Arguments to be passed to other methods.}
}
\value{
a data frame with sample name, inbreeding coefficient, and
    an indicator of whether the inbreeding coefficient is five
    standard deviation beyond the mean.
}
\description{
Function to calculate population-specific inbreeding coefficients,
and to predict inbreeding outliers that are five standard deviation
beyond the mean.
}
\details{
Using LD-pruned variants (by default), we calculate the
    inbreeding coefficients for each sample in the study cohort and
    for benchmark samples of the same population as the study
    cohort. Samples with inbreeding coefficients that are five
    standard deviations beyond the mean are considered problematic
    and are shown as "Yes" in the column of
    \code{outlier.5sd}. Benchmark samples in this column are set to
    be “NA”.
}
\examples{
load(system.file("extdata", "example.seqfile.Rdata", package="SeqSQC"))
gfile <- system.file("extdata", "example.gds", package="SeqSQC")
seqfile <- SeqSQC(gdsfile = gfile, QCresult = QCresult(seqfile))
seqfile <- Inbreeding(seqfile, remove.samples=NULL, LDprune=TRUE, missing.rate=0.1)
res.inb <- QCresult(seqfile)$Inbreeding
tail(res.inb)
}
\author{
Qian Liu \email{qliu7@buffalo.edu}
}
\keyword{inbreeding}
