library(tidyr)
library(dplyr)
library(ggplot2)
library(RColorBrewer)

table <- read.table('OTU_GFP_9_rm_out.tab', head=TRUE, row.names=1)

table<- table[c("unclassified_Alphaproteobacteria","unclassified_Pseudomonadota","Caulobacter_endophyticus","Sulfurimonas_sp_RIFOXYD2_FULL_34_21","Aurantimonas_manganoxydans","Geovibrio_sp_","Pantoea_sp_RSPAM1"),]

table$dsGFP_mean <- rowMeans(table[,1:4])
table$dscdc9_mean <- rowMeans(table[,5:8])

table$ID <- rownames(table)

table_long <- table[,c('ID','dsGFP_mean','dscdc9_mean')] %>%
  pivot_longer(cols = -ID, 
               names_to = "Group",
               values_to = "Value")

table_long$ID <- factor(table_long$ID, levels=c("unclassified_Alphaproteobacteria","unclassified_Pseudomonadota","Caulobacter_endophyticus","Sulfurimonas_sp_RIFOXYD2_FULL_34_21","Aurantimonas_manganoxydans","Geovibrio_sp_","Pantoea_sp_RSPAM1"))

pdf(file='Bacterial_taxa_stack.pdf',w=6,h=4)
ggplot(table_long,aes(x=Group, y=Value, fill =ID))+
geom_bar(position = "stack",stat = "identity", width = 0.6 )+
scale_fill_manual(values = c(brewer.pal(n = 7, name = "Dark2")))+
theme_classic()
dev.off()
