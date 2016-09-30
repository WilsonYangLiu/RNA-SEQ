#!/usr/bin/env python
# -*- coding: utf-8 -*-
# sys.argv[1]: file contains the cross link of one id to another id
# sys.argv[2]: file that want to transform the id

import os, sys
import csv

def usage():
	print '''
Convet the id to gene symbol
		
usage: 
   [python] id2symbol.py database in_file > out_file
		
argument:
   database:	file contains the cross link of one id to another id
   in_file:	file that want to transform the id
   out_file:	file that want to store the results

Example: 
   id2symbol.py mm10_with-symbol sig_GeneData.txt > sig_GeneData.csv
	'''

	sys.exit(1)

def diffFile(filename):
	GeneId = []
	with open(filename, 'rb') as csvfile:
		spamreader = csv.reader(csvfile, delimiter='\t')
		for row in spamreader:
			GeneId.append(row[0])
	
	GeneId.pop(0)
	return GeneId
	
if __name__ == '__main__':

	if len(sys.argv) != 3:
		usage()
	
	with open(sys.argv[1], 'rU') as f:
		f.readline()
		GeneDict = {}
		for line in f:
			word = line.split('\t')
			GeneDict[word[0]] = word[-1][:-1]
		#print len(GeneDict)
	
	GeneId = diffFile(sys.argv[2])
	
	for Gene in GeneId:
		if Gene != '-':
			ensGene = Gene.split(',')
			for i in range(len(ensGene)):
				if GeneDict.has_key(ensGene[i]):
					print '{},{}'.format(ensGene[i],GeneDict[ensGene[i]]),
				else:
					print "key", ensGene[i], "doesn't exist"
			print 
	
		else:
			print '{0},{0}'.format('-')



	
