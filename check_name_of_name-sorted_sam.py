#!/usr/bin/env python 
# the -f 0x2 part will get only "properly paired" alignments, which will effectively be the concordant alignments. For the definition of "map only once", you can take advantage of the fact that bowtie2 will add an XS auxiliary tag to reads that have another "valid" mapping. So, a quick inverse grep (grep -v) can get rid of those :
# samtools view -hf 0x2 alignments.bam | grep -v "XS:i:" > filtered.alignments.sam  
# One possible problem with this is if only one read of a pair can map to multiple places (e.g., the original fragment partly overlapped a simple tandem repeat) then you'd end up with orphans (the first line of a paragraph set as the last line of a page or column, considered undesirable.). The easiest fix to that (if it's a problem) would be to just check if the read names of pairs of alignments are the same
# see: https://www.biostars.org/p/95929/

# sorted the sam file first !!
import csv 
import sys 
 
f = csv.reader(sys.stdin, dialect="excel-tab") 
of = csv.writer(sys.stdout, dialect="excel-tab") 
last_read = None 
for line in f : 
    #take care of the header 
    if(line[0][0] == "@") : 
        of.writerow(line) 
        continue 
 
    if(last_read == None) :  
        last_read = line 
    else : 
        if(last_read[0] == line[0]) : 
            of.writerow(last_read) 
            of.writerow(line) 
            last_read = None 
        else : 
            last_read = line 
