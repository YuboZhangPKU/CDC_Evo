library(ggplot2)
library(RColorBrewer)

pdf(file='Orthogroups.GeneCount2.pdf',w=10,h=5)

col <- brewer.pal(8,'Set2')

table <- read.table('Orthogroups.GeneCount.tabV2',sep = '\t',head = F)
table$V1 <- factor(table$V1, levels = c('Unassigned', 'Other', 'Specific', 'Cicadellidae', 'Hemiptera', 'AllPresent', 'SingleCopy'))
table$V2 <- factor(table$V2, levels = c('Nap', 'Nci','Ido', 'Hvi', 'Ofa','Lst', 'Nlu','Dme'))
			

ggplot(table, aes(x=V2, y=V3, fill=V1))+
geom_bar(stat = 'identity', position = 'stack')+
scale_fill_manual(values=col)+
geom_text(aes(label = V3), position = position_stack(), vjust = 0.5, hjust=1)+
coord_flip()+

theme_classic()

					

dev.off()
