library(mixOmics)
library(ggplot2)
library(dplyr)

table <- read.table('OTU_GFP_9.tab', head=TRUE, row.names=1)

group <- factor(rep(c("dsGFP", "dsCDC9"), each = 4))
plsda.fit <- plsda(t(table), group, ncomp = 2)

table <- as.data.frame(plsda.fit$variates$X)
table$'group' <- factor(rep(c("dsGFP", "dsCDC9"), each = 4))


centers <- table %>%
  group_by(group) %>%
  summarise(
    cx = mean(`comp 1`),
    cy = mean(`comp 2`)
  )

pdf('OTU_GFP_9_plsda.pdf',8,8)
ggplot(table,aes(x = table$`comp 1`, y = table$`comp 2`,color = table$group))+
   geom_point(size = 5) +
   stat_ellipse(level = 0.5) +
   scale_color_manual(values = c("dsGFP" = "#808080", "dsCDC9" = "#961E23")) +

 geom_segment(
    data = merge(table, centers, by = "group"),
    aes(
      x = `comp 1`,
      y = `comp 2`,
      xend = cx,
      yend = cy
    ),
    alpha = 0.3
  ) +

   theme_classic() +
   theme(plot.title = element_text(hjust = 0.5))+ theme(legend.position = "none")
dev.off()
