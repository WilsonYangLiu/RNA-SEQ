awk -vOFS='\t' '(NR>1){if($14=="yes"){print $3}}' gene_exp.diff > ../sig
awk -vOFS='\t' '(NR>1){if($14=="yes"){print $3,$10,$12,$13}}' gene_exp.diff > ../sig_detail
