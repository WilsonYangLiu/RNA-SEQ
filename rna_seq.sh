cd /media/wilson/b776f228-366c-4e52-acd6-65df5b458e8c/Project_s542r04002/rawData

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
ls *.fastq.gz > fastq.list
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

# cummeRbund
Rscript ../cummeRbund.R

# HTSeq count read
ls *_thout/accepted_hits.bam > accepted_hits.list
python ../htseq-count.py accepted_hits1.list
rm *list
mkdir sortByName-Bam && mv *sort.bam sortByName-Bam
BLOCK
# count modify
ls *.count | while read id ; do 
	( head --line=-5 $id | sort -s -t , -k1,1 ) > $id.tmp
done

awk 'BEGIN{FS="\t"} FILENAME=="WGC075467R.count.tmp" { dat[$1]=","$2 } \
	FILENAME=="WGC075468R.count.tmp" { dat[$1]=dat[$1]","$2 } \
	FILENAME=="WGC075469R.count.tmp" { dat[$1]=dat[$1]","$2 } \
	FILENAME=="WGC075470R.count.tmp" { print $1dat[$1]","$2 }' \
	WGC075467R.count.tmp WGC075468R.count.tmp WGC075469R.count.tmp WGC075470R.count.tmp \
	> off-2w.csv

awk 'BEGIN{FS="\t"} FILENAME=="WGC075467R.count.tmp" { dat[$1]=","$2 } \
	FILENAME=="WGC075468R.count.tmp" { dat[$1]=dat[$1]","$2 } \
	FILENAME=="WGC075471R.count.tmp" { dat[$1]=dat[$1]","$2 } \
	FILENAME=="WGC075472R.count.tmp" { dat[$1]=dat[$1]","$2 } \
	FILENAME=="WGC075473R.count.tmp" { print $1dat[$1]","$2 }' \
	WGC075467R.count.tmp WGC075468R.count.tmp WGC075471R.count.tmp WGC075472R.count.tmp WGC075473R.count.tmp \
	> Sb-2w.csv

rm *count.tmp
mkdir HTseqCountData && mv *.count HTseqCountData




