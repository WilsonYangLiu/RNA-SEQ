# check pair-end or single-end

# combine 'Hh-O-E' files
cat Hh-O-E_L3_I394.R2.clean.fastq Hh-O-E_L7_I394.R2.clean.fastq > Hh-O-E_L3+7_I394.R2.clean.fastq
cat Hh-O-E_L3_I394.R1.clean.fastq Hh-O-E_L7_I394.R1.clean.fastq > Hh-O-E_L3+7_I394.R1.clean.fastq

# Quality check: fastqc

#? How to get genome sequence and annotation file
#	see /BW_index/readme

# tophat: mapping the processed reads to the genome. (bowtie2_based)
tophat.py

# samtools: remove duplicate reads? remove discondant alignments!
# check aligned stuation:
samtools view -h Hh-O-E/accepted_hits.bam | grep -v '@' | awk '{print $5}' | sort | uniq -c | less

2057997 0
 654705 1
 408306 3
27742423 50

# samtools amd cufflink: filter discordant reads and Assemble transcripts for each sample
cufflinks.py

# Run Cuffmerge on all your assemblies to create a single merged transcriptome annotation.
cuffmerge -g dm6_gene.gtf -s dm6.fa -p 16 -o merge_activate Hh-activate
cuffmerge -g dm6_gene.gtf -s dm6.fa -p 16 -o merge_inhibit Hh-inhibit

# Identify differentially expressed genes and transcript
## Run cuffdiff by using the merged transcriptome assembly along with the BAM files from TopHat for each replicate
GENOME=BW_index/dm6.fa
cuffdiff -o diff_activate -p 16 -b $GENOME -L Hh-O-E,MS-R13S -u merge_activate/merged.gtf \
tophat_out/Hh-O-E/accepted_hits.bam \
tophat_out/MS-R13S/accepted_hits.bam

cuffdiff -o diff_inhibit -p 16 -b $GENOME -L Smo-RNAi,3954R13S -u merge_inhibit/merged.gtf \
tophat_out/Smo-RNAi/accepted_hits.bam \
tophat_out/3954R13S/accepted_hits.bam

# CummeRbund: Explore differential analysis results
## In this step, you may find some differentially expressed genes and transcripts, and can be shown in graphs
## CummeRbund: Record differentially expressed genes and transcripts to file for use in downstream analysis
cummeRbund.R
## extract significant differential expression gene (using R or any tool, here we use the 'awk' cmd)
getSigGene.sh	#(in 'diff_out' folder: 'sig' and 'sig_detail')
## ensGene to gene symbol, you need to find the cross database in the ucsc first
to_symbol.py	



