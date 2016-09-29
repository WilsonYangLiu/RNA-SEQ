#!/usr/bin/env python
# -*- coding: utf-8 -*-
#

import sys, string
import os
f = open(sys.argv[1], 'r')	# the list of FastQ file
allfile = [line.strip() for line in f]
for i in range(0,len(allfile),2):
	word = allfile[i].split(r'_')
	cmd = "tophat2 -p 16 -G ../BW_index/mm10_gene.gtf -o "+word[0]+"_thout --no-novel-juncs ../BW_index/mm10 "+allfile[i]+" "+allfile[i+1]
	os.system(cmd)
