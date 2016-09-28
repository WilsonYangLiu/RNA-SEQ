rm(list = ls())
setwd(dir = '/media/wilson/b776f228-366c-4e52-acd6-65df5b458e8c/Project_s542r04002/')

library(ggplot2)

off.2w <- read.table(file = 'diff_off-2w_result/DAVID-kegg.enrichment', header = TRUE, sep = '\t')
Sb.2w <- read.table(file = 'diff_Sb-2w_result/DAVID-kegg.enrichment', header = TRUE, sep = '\t')

off.name <- as.data.frame(strsplit(as.character(off.2w$Term), ':'))
ggplot(off.2w,aes(x=factor(Count)))

#as.character(t(off.name[2,]))