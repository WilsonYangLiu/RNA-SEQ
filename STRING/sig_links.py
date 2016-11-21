from __future__ import print_function

#!/usr/bin/env python
# -*- coding: utf-8 -*-
#

import os, gzip
from pickle import load
from itertools import islice

os.chdir(r'E:/Project_bak/Project_s542r04002/STRING')
suffix = 'Sb'	# 'off'

with open(r'cR_sig_symbol_{}.txt'.format(suffix), 'rb') as f:
	sig_symbol = [item.strip() for item in f]
	
Out = open(r'sig_links_{}.txt'.format(suffix), 'wb')
sig_links_DB = set()
with open(r'links.score.higher.9.txt', 'rb') as f:
	for line in f:
		line = [item for item in line.strip().split('\t') ]
		if (line[0] in sig_symbol) and (line[1] in sig_symbol):
			sig_links_DB |= set(line)
			Out.writelines('\t'.join(line) )
			Out.write('\n')
			
Out.close()

with open(r'sig_links_DB_{}.txt'.format(suffix), 'wb') as f:
	sig_links_DB = list(sig_links_DB)
	f.writelines('\n'.join(sig_links_DB) )