library(ggplot2)
library(grid)

table <- read.table("Nni_100k.depth",header=TRUE)

pdf(file="Nni_Depth.pdf",12,6)
ggplot(data = table)+
geom_violin(aes(x=table$Chr,y=table$Depth),colour = "#d46363")+
geom_boxplot(aes(x=table$Chr,y=table$Depth),colour = "#d46363", outlier.shape = NA, width=0.2)+
xlab("Chr")+
ylab("Depth")+
scale_y_continuous(limits = c(0,150))+
#scale_x_continuous(expand = c(0,0))+
theme_classic()
dev.off()

table <- read.table("Rdo_100k.depth",header=TRUE)

pdf(file="Rdo_Depth.pdf",12,6)
ggplot(data = table)+
geom_violin(aes(x=table$Chr,y=table$Depth),colour = "#2a7ebd")+
geom_boxplot(aes(x=table$Chr,y=table$Depth),colour = "#2a7ebd", outlier.shape = NA, width=0.2)+
xlab("Chr")+
ylab("Depth")+
scale_y_continuous(limits = c(0,150))+
#scale_x_continuous(expand = c(0,0))+
theme_classic()
dev.off()
