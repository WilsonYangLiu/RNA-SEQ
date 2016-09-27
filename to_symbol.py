#! /usr/bin python
import os

with open(r'mm10_with-symbol', 'rU') as f:
	f.readline()
	GeneDict = {}
	for line in f:
		word = line.split('\t')
		GeneDict[word[0]] = word[-1][:-1]
	print len(GeneDict)

with open(r'./diff_Sb-2w_result/sig_GeneId', 'rU') as f:
	for line in f:
		if line[:-1] != '-':
			ensGene = line.split(',')
			ensGene[len(ensGene)-1] = ensGene[len(ensGene)-1][:-1]
			
			for i in range(len(ensGene)):
				if GeneDict.has_key(ensGene[i]):
					print '{}\t{}'.format(ensGene[i],GeneDict[ensGene[i]]),
				else:
					print "key", ensGene[i], "doesn't exist"
			print

