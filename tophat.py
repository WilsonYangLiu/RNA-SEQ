#!/usr/bin/env python
# -*- coding: utf-8 -*-
# NOTE: make sure in fastq.list, the (2k-1) and (2k) must be the pair for the pair-end sequence. (k = 1, 2, ...)

import sys, string
import os

GTF = "../BW_index/mm10_gene.gtf"
genome = "../BW_index/mm10"

f = open(sys.argv[1], 'r')	# the list of FastQ file
allfile = [line.strip() for line in f]
for i in range(0,len(allfile),2):
	word = allfile[i].split(r'_')
	cmd = "tophat2 -p 16 -o "+word[0]+"_thout --no-novel-juncs -G "+" ".join((GTF, gemone, allfile[i], allfile[i+1]) )
	os.system(cmd)
