library(tidyr)
library(dplyr)
library(ggplot2)

table <- read.table('VFCID.tab', head=TRUE)

sample_names <- names(table)[2:9]

table <-subset(table, table$id == "VFC0001" | table$id == "VFC0086"|table$id == "VFC0301"|table$id == "VFC0258") 

table_long <- table %>%
pivot_longer(
    cols = all_of(sample_names),
    names_to = "Sample",
    values_to = "Value"
  ) %>%
  mutate(
    id = factor(id , levels = unique(table$id )),
    Group = factor(
      if_else(Sample %in% sample_names[1:4], "dsGFP", "dsCDC9"),
      levels = c("dsGFP", "dsCDC9")
    )
  )

table_long$id  <- factor(table_long$id , levels=c("VFC0086","VFC0258","VFC0001","VFC0301"))

stats <- table_long %>%
  group_by(id, Group) %>%
  summarise(
    n = sum(!is.na(Value)),
    Mean = mean(Value, na.rm = TRUE),
    SEM = sd(Value, na.rm = TRUE) / sqrt(n),
    .groups = "drop"
  )

pdf('VFCID_sem.pdf')
ggplot() +
  geom_col(
    data = stats,
    aes(x = id, y = Mean, fill = Group),
    position = position_dodge(width = 0.8),
    width = 0.7
  ) +
  
  geom_errorbar(
    data = stats,
    aes(
      x = id,
      ymin = Mean- SEM,
      ymax = Mean+ SEM,
      group = Group
    ),
    position = position_dodge(width = 0.8),
    width = 0.15
  ) +
  
  geom_point(
    data = table_long,
    aes(
      x = id,
      y = Value,
      fill = Group
    ),
	position = position_jitterdodge(
      jitter.width = 0.08,
      dodge.width = 0.8
    ),
    size = 2
  ) +
  scale_fill_manual(values = c('#808080','#961E23'))+
  theme_classic()
dev.off()
