cd /home/liuwx/Desktop/liuwx/Project_s542r04002/rawData

:<<BLOCK
# move the fastq.gz file to the same folder
ls | while read id; do
	mv $id/* ./
	rm $id
done

mkdir md5 && mv *.md5 md5

# QC check
ls *.fastq.gz | while read id ; do fastqc $id;done
mkdir QC_results && mv *zip *html QC_results

# Alignment
# data.report contains the filenames of each fastq.gz file
ls *.fastq.gz > data.report
python ../tophat.py data.report

mkdir fastq && mv *.fastq.gz fastq
rm data.report

# cufflink and cuffmerge

# Identify differentially expressed genes and transcript
GENOME=../BW_index/mm10.fa
condition1=diff_off-2w
condition2=diff_Sb-2w
cuffdiff -u -o $condition1 -p 16 -b $GENOME -L $condition1,0d ../BW_index/mm10_gene.gtf \
WGC075469R_thout/accepted_hits.bam,WGC075470R_thout/accepted_hits.bam \
WGC075467R_thout/accepted_hits.bam,WGC075468R_thout/accepted_hits.bam

cuffdiff -u -o $condition2 -p 4 -b $GENOME -L $condition2,0d ../BW_index/mm10_gene.gtf \
WGC075471R_thout/accepted_hits.bam,WGC075472R_thout/accepted_hits.bam,WGC075473R_thout/accepted_hits.bam \
WGC075467R_thout/accepted_hits.bam,WGC075468R_thout/accepted_hits.bam
BLOCK
# cummeRbund
Rscript ../cummeRbund.R




