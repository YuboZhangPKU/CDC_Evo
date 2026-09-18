library(ape)
table <- read.table('TCDB_1.C.12_blastp_e10.Distance', head =T, row.names = 1, sep='\t')

aa <- as.dist(table)
complete <- hclust(aa, method = "complete", members = NULL)
average <- hclust(aa, method = "average", members = NULL)
single <- hclust(aa, method = "single", members = NULL)
ward.D <- hclust(aa, method = "ward.D", members = NULL)

write.tree(as.phylo(average), file = "TCDB_1.C.12_average.nwk")
