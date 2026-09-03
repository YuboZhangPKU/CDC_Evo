## genome assembly using NextDenovo
nextDenovo run_nextDenovo.cfg

## genome polish using NextPolish
nextPolish run_nextPolish.cfg

## run Polar Star
# map TGS data to genome
minimap2 -K 50M -t 20 -ax map-pb genome.fasta filtered_subreads.fasta.gz --secondary=no > TGS2purge_haplotigs.sam
samtools sort --threads 20 -o TGS2purge_haplotigs.bam TGS2purge_haplotigs.sam

# calculate depth in sliding window 
samtools depth -aa TGS2purge_haplotigs.bam > TGS2purge_haplotigs.read.depth.txt

smoother -o col3 -w 100000 -s 100000 -t -f TGS2purge_haplotigs.read.depth.txt > TGS2purge_haplotigs.read.depth.smooth.100k.txt 
cat TGS2purge_haplotigs.read.depth.smooth.100k.txt | perl ./polar_star/polar_star-master/scripts/mean.pl > TGS2purge_haplotigs.read.depth.smooth.mean.txt

# break genome in low and high depth windows
cat TGS2purge_haplotigs.read.depth.smooth.100k.txt | perl -lane 'print if $F[4] <= 120' | ./polar_star/bedtools2-master/bin/bedtools merge  -c 5 -o collapse -i - | perl -lane '$F[3] = "$F[0]_ld_$F[1]-$F[2]"; print join "\\t", @F' > TGS2purge_haplotigs.100k.broken.bed 
export HIGH=$(cat TGS2purge_haplotigs.read.depth.smooth.mean.txt)
cat TGS2purge_haplotigs.read.depth.smooth.100k.txt | perl -lane 'print if $F[4] >= 3 * '"$HIGH"';' | ./polar_star/bedtools2-master/bin/bedtools merge  -c 5 -o collapse -i - | perl -lane '$F[3] = "$F[0]_hd_$F[1]-$F[2]"; print join "\\t", @F' >> TGS2purge_haplotigs.100k.broken.bed
cat TGS2purge_haplotigs.read.depth.smooth.100k.txt | perl -lane 'print if ($F[4] < 3 * '"$HIGH"' ) && ($F[4] > 120)' |  ./polar_star/bedtools2-master/bin/bedtools merge  -c 5 -o collapse -i - | perl -lane '$F[3] = "$F[0]_nd_$F[1]-$F[2]"; print join "\\t", @F' >> TGS2purge_haplotigs.100k.broken.bed

sort -k1,1 -k2,2n TGS2purge_haplotigs.100k.broken.bed > TGS2purge_haplotigs.100k.broken.sorted.bed
sed -i 's/\\t/\t/g' TGS2purge_haplotigs.100k.broken.sorted.bed

# generate new genome fasta
bedtools getfasta -name -fi genome.fasta -fo purge_haplotigs_polar_star.100k.fasta -bed TGS2purge_haplotigs.100k.broken.sorted.bed

## run purge haplotigs 
minimap2 -t 20 -ax map-pb -K 100M purge_haplotigs_polar_star.100k.fasta filtered_subreads.fasta.gz --secondary=no > TGS2purge_haplotigs_polar_star.100k.sam
samtools sort --threads 20 -o TGS2purge_haplotigs_polar_star.100k.bam TGS2purge_haplotigs_polar_star.100k_merge.sam

purge_haplotigs  hist  -b TGS2purge_haplotigs_polar_star.100k.bam  -g purge_haplotigs_polar_star.100k.fasta -t 20 
purge_haplotigs  cov  -i TGS2purge_haplotigs_polar_star.100k.bam.gencov  -l 35  -m 120  -h 195 -o TGS2purge_haplotigs_polar_star_coverage_stats.csv
purge_haplotigs  purge -t 20 -g purge_haplotigs_polar_star.100k.fasta  -c TGS2purge_haplotigs_polar_star_coverage_stats.csv -b TGS2purge_haplotigs_polar_star.100k.bam -d

## run juicer 
python ./juicer/misc/generate_site_positions.py HindIII Nci genome.fasta
awk 'BEGIN{OFS="\t"}{print $1, $NF}' Nci_HindIII.txt > Nci.chrom.sizes
./juicer/scripts/juicer.sh -g Nci -D ./juicer -z genome.fasta -y Nci_HindIII.txt -p Nci.chrom.sizes -s HindIII -t 20 > Nci_juicer.log

## run 3d-dna
./3d-dna-master/run-asm-pipeline.sh -r 2 genome.fasta aligned/merged_nodups.txt > Nci_3d-dna.log
./3d-dna-master/run-asm-pipeline-post-review.sh -r genome.final.review.assembly genome.fasta aligned/merged_nodups.txt > Nci_3d-dna_review.log

## map NGS data data to genome
bwa index Nephotettix_cincticcps.Hic.fasta
bwa mem -t 20 Nephotettix_cincticcps.Hic.fasta NGS_R1.fq.gz NGS_R2.fq.gz > Nci_NGS2genome.sam
samtools sort --threads 20 -o Nci_NGS2genome.bam Nci_NGS2genome.sam
samtools index Nci_NGS2genome.bam
samtools depth -aa Nci_NGS2genome.bam > Nci_NGS2genome.read.depth.txt

