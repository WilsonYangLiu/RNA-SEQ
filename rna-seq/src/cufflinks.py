#!/usr/bin/env python
# -*- coding: utf-8 -*-
#

import sys, string
import os
f = open(sys.argv[1], 'r')	# the list of accepted_hits.bam file
allfile = [line.strip() for line in f]
for i in range(len(allfile)):
	word = allfile[i].split('/')
	# filter discordant reads (some problem may exist and should cosider deeper. See: link)
	#cmd = "samtools view -b -f 0x2 "+allfile[i][:-1]+" > concordant_"+word[0]+".bam"
	#os.system(cmd)
	cmd = "cufflinks -p 16 -o "+word[0]+"_clout "+"concordant_"+word[0]+".bam"
	os.system(cmd)
	
