rm(list = ls())
setwd(dir = '/media/wilson/b776f228-366c-4e52-acd6-65df5b458e8c/Project_s542r04002/')

library(gplots)

off.2w <- read.table(file = 'diff_off-2w_result/DAVID-kegg.enrichment', header = TRUE, sep = '\t')
Sb.2w <- read.table(file = 'diff_Sb-2w_result/DAVID-kegg.enrichment', header = TRUE, sep = '\t')

off.name <- as.data.frame(strsplit(as.character(off.2w$Term), ':'))
off <- off.2w$Count
names(off) <- as.character(t(off.name[2,]))
off <- sort(off)

bp <- barplot2(height = off, horiz = TRUE, axes = FALSE, las = 1)
axis(side = 3)
