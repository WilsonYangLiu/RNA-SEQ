help = ''' . '''
import sys, string
import os
f = open(sys.argv[1], 'r')	# the list of accepted_hits.bam file
allfile = f.readlines()
for i in range(len(allfile)):
	word = allfile[i].split('_')
	cmd = "samtools sort -n "+allfile[i][:-1]+" -o "+word[0]+".sort > "+word[0]+".sort.bam"
	os.system(cmd)
	cmd = "htseq-count -f bam -i gene_id -m intersection-nonempty "+word[0]+".sort.bam ../mm10_gene.gtf > "+word[0]+".count"
	os.system(cmd)
