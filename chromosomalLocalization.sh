#!/bin/bash

blastn -query Bout-locus-TRAD.fasta -subject CM017744.fasta -out blastResultCM017744.out -outfmt "6 qseqid sseqid pident qlen length qstart qend sstart send sstrand sseq"

# RESUME DES CHAMPS SELECTIONNES :
#	le numero d’acces de la sequence de reference (qseqid)			→ colonne 1 champ 1 ($1)
#	le nom de l’allele 												→ colonne 1 champ 2 ($1)
#	l’espece 														→ colonne 1 champ 3 ($1)
#	la fonctionnalite 												→ colonne 1 champ 4 ($1)
#	le label (X-REGION, X-GENE-UNIT ou l’exon) 						→ colonne 1 champ 5 ($1)
#	les positions de la sequence de reference (format ‘debut..fin’)	→ colonne 1 champ 6 ($1)
#	le numero d’acces du chromosome (sseqid) 						→ colonne 2 ($2)
#	le % d’identite (sequence de reference contre chromosome) 		→ colonne 3 ($3)
#	la longueur de la sequence de reference en nt (qlen) 			→ colonne 4 ($4)
#	la longueur de la sequence chromosomique en nt (length) 		→ colonne 5 ($5)
#	la position de debut de la sequence de reference (qstart) 		→ colonne 6 ($6)
#	la position de fin de la sequence de reference (qend) 			→ colonne 7 ($7)
#	la position de debut de la sequence chromosomique (sstart) 		→ colonne 8 ($8)
#	la position de fin de la sequence chromosomique (send) 			→ colonne 9 ($9)
#	l’orientation de l’allele dans le chromosome (sstrand) 			→ colonne 10 ($10)
#	la sequence nucleotidique resultant du Blast (optionnel) 		→ colonne 11 ($11)

# Nettoyer les resultats bruts
awk '{ if ($3>80) print $1"\t"$2"\t"$3"\t"$4"\t"$5"\t"$5-$4"\t"$6"\t"$7"\t"$8"\t"$9"\t"$10"\t"$11 }' blastResult.out > blastResultCM017744_flt.out

# Pretraiter les resultats et les formater 
awk -F'[|\t]' '{if ($25 > $24 && ($21==-1 || $21==0 || $21==1)) print $2 "|" $5 "\t" $18 "\t" $24 "\t" $25 "\t" $26 "\t" $27 ; if ($25 < $24 && ($21==-1 || $21==0 || $21==1)) print $2 "|" $5 "\t" $18 "\t" $25 "\t" $24 "\t" $26 "\t" $27 } BEGIN{print "Allele_IMGT|Label_IMGT\t%identity\tStart_position\tEnd_position\tChrStrand\tAligned_sequence"}' blastResult_flt.out > blastResultCM017744_fmt.out

# Ordonner les resultats par position de debut (ou par nom d'alleles utiliser -k1 a la place de -k)
# sort -k1 blastResult_fmt.out > blastResult_srt.out
sort -k3 blastResultCM017744_fmt.out > blastResultCM017744_srt.out
