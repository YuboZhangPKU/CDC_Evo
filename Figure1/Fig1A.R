library(ggplot2)
library(grid)
library(raster)
library("sf")

# data source: A cultivated planet in 2010 – Part 2: The global gridded agricultural-production maps
# https://doi.org/10.7910/DVN/PRFF8V

df <- raster("spam2010v2r0_global_a_rice_a.asc")
df2 <-data.frame(rasterToPoints(df))
summary(df2$layer)
df2$layer2 <- cut(df2$layer, breaks = c(-Inf,0,500,1000,2000,4000,Inf), labels=c('0','a','b','c','d','e'))
df2 = df2[which(df2$layer2 != '0'),]

pdf('Rice_map.pdf')
ggplot() +
    geom_tile(aes(x=df2$x, y=df2$y, fill=df2$layer2), alpha= 0.7)+
    scale_fill_manual(values=c("#B3DA61","#CDE460","#6ECD8E","#539D73","#2B7337"))+
    scale_x_continuous(limits=c(50,160))+
    scale_y_continuous(limits=c(-25,65))+
    theme(legend.position='none')+
    xlab(NULL)+
    ylab(NULL)
dev.off()
