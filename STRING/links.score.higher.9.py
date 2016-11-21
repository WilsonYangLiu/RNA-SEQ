from __future__ import print_function

#!/usr/bin/env python
# -*- coding: utf-8 -*-
#

import os, gzip
from pickle import load
from itertools import islice

os.chdir(r'E:/Project_bak/Project_s542r04002/STRING')

with open(r'ENSP2Entrez_DB.pickle', 'rb') as f:
	ENSP2Entrez_DB = load(f)

Drop = open(r'Drop.links.score.higher.9.txt', 'wb')
Out = open(r'links.score.higher.9.txt', 'wb')
with gzip.open(r'10090.protein.links.v10.txt.gz', 'rb') as In:
	for line in islice(In, 1, None):
		line = line.strip()
		tmp = [item for item in line.split(' ')]
		if int(tmp[2]) >= 900:
			if ENSP2Entrez_DB.has_key(tmp[0]) and ENSP2Entrez_DB.has_key(tmp[1]):
				for gene1 in ENSP2Entrez_DB[tmp[0] ]:
					for gene2 in ENSP2Entrez_DB[tmp[1] ]:
						Out.writelines('\t'.join([gene1, gene2] ) )
						Out.write('\n')
				
			else:
				Drop.writelines('\t'.join([tmp[0], tmp[1] ] ) )
				Drop.write('\n')
			
Drop.close()
Out.close()
