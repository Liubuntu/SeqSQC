#' Obtain the problematic sample list from IBD relatedness.
#'
#' Function to extract the related sample pairs from IBD results, and
#' to generate the sample list for removal from the related pairs
#' based on sample missing rate.
#' @param seqfile SeqSQC object, with IBD results.
#' @param all whether to check the IBD for all sample pairs (including
#'     the benchmark samples). The default is FALSE.
#' @return a list of 2 elements: \code{$ibd.pairs} is a data frame
#'     with 5 columns including sample names(id1, id2), IBD
#'     coefficients of k0 and k1, and kinship for samples with cryptic
#'     relatedness. \code{$ibd.remove} is a vector of samples to be
#'     removed, which are generated by extracting the sample with
#'     higher missing rate in each problematic sample pair.
#' @export
#' @examples
#' load(system.file("extdata", "example.seqfile.Rdata", package="SeqSQC"))
#' gfile <- system.file("extdata", "example.gds", package="SeqSQC")
#' seqfile <- SeqSQC(gdsfile = gfile, QCresult = QCresult(seqfile))
#' seqfile <- IBDCheck(seqfile, remove.samples=NULL, LDprune=TRUE, missing.rate=0.1)
#' IBDRemove(seqfile)
#' @author Qian Liu \email{qliu7@@buffalo.edu}

IBDRemove <- function(seqfile, all = FALSE){

    ## check
    if (!inherits(seqfile, "SeqSQC")){
        return("object should inherit from 'SeqSQC'.")
    }
    if(!"IBD" %in% names(QCresult(seqfile))) stop("no IBD result.")

    sampleanno <- QCresult(seqfile)$sample.annot
    samples <- sampleanno$sample
    studyid <- sampleanno[sampleanno[,5] == "study", 1]
    res.ibd <- QCresult(seqfile)$IBD
    
    
    ## IBD results for only samples in study cohorts
    res.study <- res.ibd[res.ibd$id1 %in% studyid & res.ibd$id2 %in% studyid,]

    ## IBD results for all samples (including benchmark samples)
    ## res.study <- res.ibd

    ## ## IBD results for samples that are related with study samples
    ## res.study <- res.ibd[res.ibd$id1 %in% studyid | res.ibd$id2 %in% studyid,]

    ## check if any study sample is related with multiple samples
    ibd.related <- res.study[as.character(res.study$label) != as.character(res.study$pred.label) &
                             res.study$kin > 0.08, ]
    ibd.pairs <- ibd.related[, 1:5]
    
    if(nrow(ibd.related) > 0){
        ibd.related.tmp <- ibd.related
        remove.multi <- c()
        repeat{
            ibd.multi <- table(c(as.character(ibd.related.tmp$id1),
                                 as.character(ibd.related.tmp$id2)))
            ibd.multi <- sort(ibd.multi, decreasing=TRUE)[1]
            if(ibd.multi==1){break}
            remove.multi <- rbind(remove.multi, c(names(ibd.multi), unname(ibd.multi)))
            ibd.related.tmp <- ibd.related.tmp[!ibd.related.tmp$id1 %in% remove.multi &
                                               !ibd.related.tmp$id2 %in% remove.multi, ]
            if(nrow(ibd.related.tmp) == 0) {break}
        }
        ## remove the sample in the related pairs with higher missing rate. 
        message("remove samples in problematic pairs with higher missing rate...")
        if(! "MissingRate" %in% names(QCresult(seqfile))){
            seqfile <- MissingRate(seqfile)
        }
        mr <- QCresult(seqfile)$MissingRate
        mr <- mr[match(c(ibd.related$id1, ibd.related$id2), mr$sample), 1:2]
        ## }else{
        ##     gfile <- SeqOpen(seqfile, readonly=TRUE)
        ##     on.exit(closefn.gds(gfile))
        ##     gt <- readex.gdsn(index.gdsn(gfile, "genotype"),
        ##                       list(NULL, samples %in% c(ibd.related$id1, ibd.related$id2)))
        ##     mr <- apply(gt, 2, function(x) sum(! x %in% c(0, 1, 2))/length(x))
        ##     mr <- data.frame(sample = c(ibd.related$id1, ibd.related$id2), missingRate = mr, stringsAsFactors=FALSE)
        ##     ## closefn.gds(gfile)
        ## }    

        mr.rm <- function(x){
            mr.pair <- mr[match(x, mr$sample), 2]
            remove <- x[order(mr.pair, decreasing=TRUE)][1]
            return(remove)
        }
        remove.single <- unname(apply(ibd.related[, 1:2], 1, mr.rm))
        remove.ibd <- c(remove.multi[,1], remove.single)
    }else{
        remove.ibd=NULL
    }
    return(list(ibd.pairs=ibd.pairs, ibd.remove=remove.ibd))
}

        
