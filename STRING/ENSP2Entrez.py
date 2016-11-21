from __future__ import print_function

#!/usr/bin/env python
# -*- coding: utf-8 -*-
#

import os, gzip
from itertools import islice
from pickle import load, dump

os.chdir(r'E:/Project_bak/Project_s542r04002/STRING')

Out = gzip.open(r'ENSP2Entrez_DB.txt.gz', 'wb')
ENSP2Entrez_DB = {}
with gzip.open(r'10090.protein.aliases.v10.txt.gz', 'rb') as f:
	for line in islice(f, 1, None):
		line = line.strip()
		line = [item for item in line.split('\t') ]
		line[2] = [item for item in line[2].split(' ') ]
		# Use src: Ensembl_EntrezGene
		if 'Ensembl_EntrezGene' in line[2]:
			if ENSP2Entrez_DB.has_key(line[0] ):
				ENSP2Entrez_DB[line[0] ].append(line[1] )
			else:
				ENSP2Entrez_DB[line[0] ] = [line[1] ]
				
			Out.writelines('\t'.join(line[:2] ) )
			Out.write('\n')
			
with open(r'ENSP2Entrez_DB.pickle', 'wb') as f:
	dump(ENSP2Entrez_DB, f)
	
Out.close()