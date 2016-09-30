#!/usr/bin/env python
# -*- coding: utf-8 -*-
#

import sys, string
import os

GTF = "../BW_index/mm10_gene.gtf"

with open(sys.argv[1], 'r') as f:	# the list of accepted_hits.bam file
	allfile = [line.strip() for line in f]

for i in range(len(allfile)):
	word = allfile[i].split('_')
	cmd = "samtools sort -n -o "+word[0]+".sort "+allfile[i]+" > "+word[0]+".sort.bam"
	os.system(cmd)
	cmd = "htseq-count -f bam -i gene_id -m intersection-nonempty "+word[0]+".sort.bam "+GTF+" > "+word[0]+".count"
	os.system(cmd)
