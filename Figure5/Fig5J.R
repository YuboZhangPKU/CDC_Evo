library(tidyr)
library(dplyr)
library(ggplot2)
library(RColorBrewer)


table <- read.table('VFCID.tab', head=TRUE)

table$dsGFP_mean <- rowMeans(table[,1:4])
table$dscdc9_mean <- rowMeans(table[,5:8])

table_long <- table[,c('ID','dsGFP_mean','dscdc9_mean')] %>%
  pivot_longer(cols = -ID, 
               names_to = "Group",
               values_to = "Value")

table_long$ID <- factor(table_long$ID, levels=c("VFC0086","VFC0204","VFC0272","VFC0258","VFC0001","VFC0301","VFC0083","VFC0325","VFC0251","VFC0271","VFC0346"
))

pdf(file='VFCID_stack.pdf',w=6,h=4)
ggplot(table_long,aes(x=Group, y=Value, fill =ID))+
geom_bar(position = "stack",stat = "identity", width = 0.6 )+
scale_fill_manual(values = c(brewer.pal(n = 11, name = "Set3")))+
theme_classic()
dev.off()
