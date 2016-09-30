# see: https://cartwrightlab.wikispaces.com/DESeq

#0 header=TRUE indicates that the first line contains column names and row.names=1 means that the
# first column should be used as row names.
countTable <- read.csv( "activate.csv", header=TRUE, row.names=1)

#1 filter out genes which have very low cumulative read mapping counts (low row sum, 10 in the example below)
rs <- rowSums(countTable)
use <- (rs 10)
countTableFilt <- countTable[ use, ]

#2 Create a factor which describes the condition for each sample
## replicates
#conds <- factor( c( "larva", "larva", "adult", "adult" ) )
 
## partial replicates
#conds < factor( c( "larva", "larva", "adult" ) )
 
## no replicates
conds <- factor( c( "Hh-O-E", "MS-R13S" ) )

#3 Create a CountDataSet, the central data structure in the DESeq package
cds <- newCountDataSet( countTableFilt, conds )

#4 Estimate the effective library size for each sample
cds <- estimateSizeFactors( cds )
pirnt("the size factor: ")
sizeFactors( cds )
## divide each column of the count table by the size factor for this column, the count values are brought to a common scale, making them comparable. When  called  with normalized=TRUE, the counts accessor function performs this calculation. 
#countTableFiltNor <- counts( cds, normalized=TRUE )

#5 Estimate the dispersion/variance of the data.
## With biological replicates or with partial replicates.
## When you have partial replicates only the conditions with replicates will be used to estimate the dispersion.
#cds <- estimateDispersions( cds )

## without biological replicates
cds <- estimateDispersions( cds, method="blind", sharingMode="fit-only" )
#pdf("DispEsts_plop.pdf")
#plotDispEsts(cds)
#dev.off()

#6 Test for differential expression.
res <- nbinomTest( cds, "Hh-O-E", "MS-R13S" )
## Plot the log2 fold changes against the base means (sometimes call the MA-plot)
#pdf("MA-plot.pdf")
plotMA(res, col = ifelse(res$padj>=0.5, "gray32", "green"),)
#dev.off()
## the histogram of p value
#pdf("p-values-plot.pdf")
hist(res$pval, breaks=100, col="skyblue", border="slateblue", main="")
#dev.off()

write.csv(res, "DESeq_genes.csv")

#7 Visualizing differential expression using heat maps
cdsBlind <- estimateDispersions( cds, method="blind" )
vsd <- getVarianceStabilizedData( cdsBlind )
select <- order(res$pval)[1:100]
colors <- colorRampPalette(c("white","darkblue"))(100)
heatmap( vsd[select,], col = colors, scale = "none")



