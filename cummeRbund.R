rm(list = ls())
#setwd("/home/wilson/Downloads/RNA-seq")

library(cummeRbund)

# Create a CummeRbund database from the Cufflinks output
cuffdiff <- commandArgs(trailingOnly = TRUE)
cuff_data  <- readCufflinks(cuffdiff[1])
print("summary infomation")
cuff_data

if(FALSE){
# used to annotate codes
}
# Plot summary Information:
## Plot the distribution of expression levels for each sample, output density.png figure.
print("Plot the distribution of expression levels for each sample")
png("cR_density.png")
csDensity(genes(cuff_data), pseudocount=0.00001)
dev.off()

## Compare the expression of each gene in two conditions with a scatter plot
print("Compare the expression of each gene in two conditions with a scatter plot")
png("cR_scatter.png")
csScatterMatrix(genes(cuff_data))
dev.off()

## Create a volcano plot to inspect differentially expressed genes
print("Create a volcano plot to inspect differentially expressed genes")
png("cR_volcano.png")
csVolcanoMatrix(genes(cuff_data))
dev.off()

# Record differentially expressed genes and transcripts to files
gene_diff_data <- diffData(genes(cuff_data))
## Record significant gene subset
sig_GeneData <- subset(gene_diff_data, (significant == 'yes'))
print("number of significant genes: ")
nrow(sig_GeneData)
write.table(sig_GeneData, 'cR_sig_GeneData.txt', sep='\t', row.names=F, col.names=T, quote=F)
## Record genes with q value less < 0.1
q0.1_GeneData <- subset(gene_diff_data, (q_value < 0.1))
print("number of genes (q_value < 0.1): ")
nrow(q0.1_GeneData)
write.table(q0.1_GeneData, 'cR_q0.1_GeneData.txt', sep='\t', row.names=F, col.names=T, quote=F)
## Record genes with fold change > 2
fold_change2_GeneData <- subset(gene_diff_data, (log2_fold_change > 2))
print("number of genes (log2_fold_change > 2): ")
nrow(fold_change2_GeneData)
write.table(fold_change2_GeneData, 'cR_fold_change2_GeneData.txt', sep='\t', row.names=F, col.names=T, quote=F)

if(FALSE){
## Plot expression levels for genes of interest with bar plots
print("Plot expression levels for genes of interest with bar plots")
gene_of_interest = "NM_145223"	# gene of interest
print(gene_of_interest)
mygene <- getGene(cuff_data, gene_of_interest)
mygene
png(filename = paste("cR_", gene_of_interest, ".png", seq=""))
expressionBarplot(mygene)
dev.off()

## Plot individual isoform expression levels of selected genes of interest with bar plots
print("Plot individual isoform expression levels of selected genes of interest with bar plots")
png(filename = paste("cR_", gene_of_interest,"isoform", ".png", seq=""))
expressionBarplot(isoforms(mygene))
dev.off()
}


