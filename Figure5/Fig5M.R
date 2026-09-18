library(tidyr)
library(dplyr)
library(ggplot2)
library(RColorBrewer)

table <- read.table('VFCID86_contribution.tab', head=TRUE, row.names=1)

table$dsGFP_mean <- rowMeans(table[,1:4])
table$dscdc9_mean <- rowMeans(table[,5:8])

table$mean <- rowMeans(table)
table <- table[table$mean >0, ]

table <- table[order(table$mean), ]
table$ID <- rownames(table)

table_long <- table[,c('ID','dsGFP_mean','dscdc9_mean')] %>%
  pivot_longer(cols = -ID, 
               names_to = "Group",
               values_to = "Value")

table_long$ID <- factor(table_long$ID, levels=c("Pantoea_sp_RSPAM1","unclassified_Pantoea","Acinetobacter_sp_ACZLY_512","unclassified_Enterobacter","Klebsiella_pasteurii","Enterobacter_sp_HMSC055A11","Pantoea_sp_V108_6"))

pdf(file='VFCID86_contribution.pdf',w=6,h=4)
ggplot(table_long,aes(x=Group, y=Value, fill =ID))+
geom_bar(position = "stack",stat = "identity", width = 0.6 )+
scale_fill_manual(values = c(brewer.pal(n = 7, name = "Dark2")))+
theme_classic()
dev.off()
