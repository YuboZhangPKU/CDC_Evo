library(pheatmap)
data<- read.table("AllSingleCopy_cytolysin.CDS.RSCU", head =T,row.names=1)
pdf("AllSingleCopy_cytolysin.CDS.RSCU_average.pdf",h=30,w=20)
head(data)
bk <- c(seq(0,0.99,by=0.01),seq(1,3,by=0.02))

pheatmap(data, cluster_rows = T,cluster_cols=T,show_rownames = T, cellwidth = 30, cellheight =30, border_color = NA, fontsize = 12, display_numbers = FALSE, color = c(colorRampPalette(colors = c("navy","white"))(length(bk)/2),colorRampPalette(colors = c("white","firebrick3"))(length(bk)/2)), legend_breaks=seq(0,3,0.5), breaks=bk, clustering_method='average')
dev.off()

