#!/usr/bin/env python
# -*- coding: utf-8 -*-
#

import re
import os, sys
import csv

PATTERN = re.compile(r'<tr><td>(.+?)</td><td>(.+?)</td></tr>')

def processHTML(filename):
	with open(filename, 'rb') as f:
		HTML = f.read()
		
	allMatch = re.findall(PATTERN, HTML)
	Dict = {}
	for item in allMatch:
		Dict[item[0]] = item[1]

	return Dict
	
if __name__ == '__main__':
	
	with open(sys.argv[1], 'rb') as f:
		htmlNames = [line.strip() for line in f]
		
	Dict = {}
	for name in htmlNames:
		Dict[name] = processHTML(name)
		
	Measure = ['Filename', 'File type', 'Encoding', 'Total Sequences', 'Sequences flagged as poor quality', 'Sequence length', '%GC']
	with open(r'QC.summary.csv', 'wb') as csvfile:
		spamwriter = csv.writer(csvfile)	
		for name, item in Dict.items():
			spamwriter.writerow([name])
			spamwriter.writerow([key for key in item.keys() if key in Measure] )
			spamwriter.writerow([val for key, val in item.items() if key in Measure])


