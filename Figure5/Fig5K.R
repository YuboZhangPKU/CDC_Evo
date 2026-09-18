library(tidyr)
library(dplyr)
library(ggplot2)
library(vegan)


table <- read.table('VFCID.tab', head=TRUE, row.names=1)
group <- factor(rep(c("dsGFP", "dsCDC9"), each = 4))

bray_dist <- vegdist(t(table), method = "bray")

pcoa_result <- cmdscale(bray_dist, k = 3, eig = TRUE) 

pcoa_points <- as.data.frame(pcoa_result$points)
colnames(pcoa_points) <- paste0("PCoA", 1:ncol(pcoa_points))
pcoa_points$Group <- group

pdf('VFCID_GFP_9_pcoa.pdf',8,8)
ggplot(pcoa_points, aes(x = PCoA1, y = PCoA2, color = Group)) +
  geom_point(size = 5) +
  stat_ellipse(level = 0.9) + 
  scale_color_manual(values = c("dsGFP" = "#808080", "dsCDC9" = "#961E23")) +
  labs(title = "PCoA Plot based on Bray-Curtis Distance",
       x = paste0("PCoA1 (", round(variance_explained[1], 2), "%)"),
       y = paste0("PCoA2 (", round(variance_explained[2], 2), "%)")) +
  theme_classic() +
  theme(plot.title = element_text(hjust = 0.5))
dev.off()
