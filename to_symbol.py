#!/usr/bin/env python
# -*- coding: utf-8 -*-
#

import os
import csv

def diffFile(filename):
	GeneId = []
	with open(filename, 'rb') as csvfile:
		spamreader = csv.reader(csvfile, delimiter='\t')
		for row in spamreader:
			GeneId.append(row[0])
	
	GeneId.pop(0)
	return GeneId
	
if __name__ == '__main__':
	os.chdir(r'E:/Project_s542r04002/diff_off-2w_result')
	
	with open(r'../mm10_with-symbol', 'rU') as f:
		f.readline()
		GeneDict = {}
		for line in f:
			word = line.split('\t')
			GeneDict[word[0]] = word[-1][:-1]
		#print len(GeneDict)
	
	GeneId = diffFile(r'./gene_exp.diff')
	
	for Gene in GeneId:
		if Gene != '-':
			ensGene = Gene.split(',')
			for i in range(len(ensGene)):
				if GeneDict.has_key(ensGene[i]):
					print '{},{}'.format(ensGene[i],GeneDict[ensGene[i]]),
				else:
					print "key", ensGene[i], "doesn't exist"
			print 
	
