rm(list = ls())
setwd(dir = "/media/wilson/b776f228-366c-4e52-acd6-65df5b458e8c/Project_s542r04002/")

diff_exp <- read.table(file = "diff_off-2w_result/sig_GeneData.txt", header = TRUE, sep = "\t")
write.table(diff_exp$gene_id, file = 'sig_GeneId', sep = '\n', 
            row.names = FALSE, col.names = FALSE,
            quote = FALSE)
