
library(tidyr)
library(dplyr)


table <- read.table('fig5A.tab', head=TRUE)

sample_names <- names(table)[2:3]

table_long <- table %>%
pivot_longer(
    cols = all_of(sample_names),
    names_to = "Sample",
    values_to = "Value"
  ) %>%
  mutate(
    id = factor(id , levels = unique(table$id ))    )
  

table_long$id  <- factor(table_long$id , levels=c("M_head","M_thorax","M_abdomen","M_gut","M_reproductive","F_head","F_thorax","F_abdomen","F_gut","F_reproductive"))


stats <- table_long %>%
  group_by(id) %>%
  summarise(
    n = sum(!is.na(Value)),
    Mean = mean(Value, na.rm = TRUE),
    SEM = sd(Value, na.rm = TRUE) / sqrt(n),
    .groups = "drop"
  )

pdf('Fig5A.pdf',h=4,w=6)
ggplot() +
  geom_col(
    data = stats,
    aes(x = id, y = Mean),
    position = position_dodge(width = 0.8),
    width = 0.7,fill='#961E23'
  ) +
  
  geom_errorbar(
    data = stats,
    aes(
      x = id,
      ymin = Mean- SEM,
      ymax = Mean+ SEM    ),
    position = position_dodge(width = 0.8),
    width = 0.35
  ) +
  
  geom_jitter(
    data = table_long,
    aes(
      x = id,
      y = Value
    ),width = 0.25,

    size = 2
  ) +

  theme_classic()
dev.off()
######################################################################################
