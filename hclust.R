library(ape)

table <- read.table('TCDB_1.C.12_blastp_e10.Distance', head =T, row.names = 1, sep='\t')

aa <- as.dist(table)
complete <- hclust(aa, method = "complete", members = NULL)
average <- hclust(aa, method = "average", members = NULL)
single <- hclust(aa, method = "single", members = NULL)
ward.D <- hclust(aa, method = "ward.D", members = NULL)

pdf("TCDB_1.C.12.pdf",50, 50)
par(mfrow=c(2,2))
plot(complete)
plot(average )
plot(single )
plot(ward.D)
dev.off()

write.tree(as.phylo(average), file = "TCDB_1.C.12_average.nwk")
############################################################
table <- read.table('TCDB_1.C.12_97.1_39.S_blastp_e10.Distance', head =T, row.names = 1, sep='\t')

aa <- as.dist(table)
complete <- hclust(aa, method = "complete", members = NULL)
average <- hclust(aa, method = "average", members = NULL)
single <- hclust(aa, method = "single", members = NULL)
ward.D <- hclust(aa, method = "ward.D", members = NULL)

pdf("TCDB_1.C.12_97.1_39.pdf",50, 50)
par(mfrow=c(2,2))
plot(complete)
plot(average )
plot(single )
plot(ward.D)
dev.off()

write.tree(as.phylo(average), file = "TCDB_1.C.12_97.1_39_average.nwk")
