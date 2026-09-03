# CDC gene identification in annotated genome
for i in `cat Genome_ID`
do
formatdb -i ${i}_protein.faa -p T
blastall -i all_cytolysin.pep.fa -p blastp -d ${i}_protein.faa -m 8 -o ${i}_CDC_blastp.tab
done

# CDC gene prediction using genome assembly
export PATH=$PATH:/data/wise2.4.1/src/bin/
export WISECONFIGDIR=/data/wise2.4.1/wisecfg/

samtools faidx genome.fa

for i in `cat Genome_ID`
do
samtools faidx ${i}_genome.fa
python genewise.py -q all_cytolysin.pep.fa -r ${i}_genome.fa -o ${i}_genome_CDC_wise
python genewise2gff3.py -i ${i}_genome_CDC_wise -o ${i}_genome_CDC_wise.gff3
done

# protein ML tree
muscle3.8.31_i86linux64 -in All_Cicadellidae_CDC.pep.fa -out All_Cicadellidae_CDC_align
raxmlHPC -f a -m PROTGAMMAJTT -p 12345 -x 12345 -# 100 -T 20 -s All_Cicadellidae_CDC_align.phy -n All_Cicadellidae_CDC

# hierarchical clustering
formatdb -i TCDB_1.C.12_97.1_39.S.pep.fa -p T
blastall -i TCDB_1.C.12_97.1_39.S.pep.fa -p blastp -d TCDB_1.C.12_97.1_39.S.pep.fa -e 10 -m 8 -o TCDB_1.C.12_97.1_39.S_blastp_e10.tab

python blast2distance.py -i TCDB_1.C.12_97.1_39.S.ID -b TCDB_1.C.12_97.1_39.S_blastp_e10.tab -o TCDB_1.C.12_97.1_39.S_blastp_e10.Distance
python blast2distance.py -i TCDB_1.C.12.ID -b TCDB_1.C.12_97.1_39.S_blastp_e10.tab -o TCDB_1.C.12_blastp_e10.Distance

Rscript hclust.R
