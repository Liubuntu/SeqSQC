# SeqSQC
sample QC for next generation sequencing data
 SeqSQC is a bioconductor package for sample-level quality check in next generation sequencing (NGS) study. It is designed to automate and accelerate the sample cleaning of NGS data in any scale, including identifying problematic samples with high missing rate, gender mismatch, contamination, abnormal inbreeding coefficient, cryptic relatedness, and discordant population information. SeqSQC takes Variant Calling Format (VCF) files and sample annotation file containing sample population and gender information as input and report problematic samples to be removed from downstream analysis. Through incorporation a benchmark data assembled from the 1000 Genomes Project, it can accommodate NGS study of small sample size and low number of variants. 