#!/usr/bin/env bash
# -*- coding:utf-8 -*-
# This script is the pipeline of process rna expression sequencing data
# Next 1: Add DESeq pipeline
# Next 2: GSEA

cd /media/wilson/b776f228-366c-4e52-acd6-65df5b458e8c/Project_s542r04002/rawData

:<<BLOCK
BLOCK
# move the fastq.gz file to one folder
ls | while read id; do
	mv $id/* ./
	rm $id
done

mkdir md5 && mv *.md5 md5

# QC check
ls *.fastq.gz | while read id ; do fastqc $id; done
mkdir QC_results && mv *zip *html QC_results

# QC summary
ls  QC_results/*.html > html.list
python ../QC.summary.py html.list
rm html.list

# Alignment
# fastq.list contains the list of all fastq.gz file
# NOTE: make sure in fastq.list, the (2k-1) and (2k) must be the pair for the pair-end sequence. (k = 1, 2, ...)
ls *.fastq.gz > fastq.list
python ../tophat.py fastq.list

mkdir fastq && mv *.fastq.gz fastq
rm fastq.list

# cufflink and cuffmerge
# Check your data if this process is neccesary.

# Identify differentially expressed genes and transcript
nTHREAD=16
GENOME=../BW_index/mm10.fa
GTF=../BW_index/mm10_gene.gtf
control=control
condition1=diff_off-2w
condition2=diff_Sb-2w
cuffdiff -u -o $condition1 -p $nTHREAD -b $GENOME -L $condition1,$control $GTF \
WGC075469R_thout/accepted_hits.bam,WGC075470R_thout/accepted_hits.bam \
WGC075467R_thout/accepted_hits.bam,WGC075468R_thout/accepted_hits.bam

cuffdiff -u -o $condition2 -p $nTHREAD -b $GENOME -L $condition2,$control $GTF \
WGC075471R_thout/accepted_hits.bam,WGC075472R_thout/accepted_hits.bam,WGC075473R_thout/accepted_hits.bam \
WGC075467R_thout/accepted_hits.bam,WGC075468R_thout/accepted_hits.bam

# cummeRbund
Rscript ../cummeRbund.R $condition1 > cR_summary
mkdir ${condition1}_result && mv cR_* ${condition1}_result
Rscript ../cummeRbund.R $condition2 > cR_summary
mkdir ${condition2}_result && mv cR_* ${condition2}_result

# HTSeq count read
ls *_thout/accepted_hits.bam > accepted_hits.list
python ../htseq-count.py accepted_hits.list
rm accepted_hits.list
mkdir sortByName-Bam && mv *sort.bam sortByName-Bam

# count modify
ls *.count | while read id ; do 
	( head --line=-5 $id | sort -s -t , -k1,1 ) > ${id}.tmp
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

rm *.count.tmp
mkdir HTseqCountData && mv *.count HTseqCountData

# DESeq


