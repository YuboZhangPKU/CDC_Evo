library(tidyr)
library(dplyr)
library(ggplot2)

table <- read.table('OTU_GFP_9.tab', head=TRUE)
sample_names <- names(table)[2:9]

table <-subset(table, table$species == "Acinetobacter_sp_1396970" | table$species == "Janthinobacterium_sp_Marseille") 

table_long <- table %>%
pivot_longer(
    cols = all_of(sample_names),
    names_to = "Sample",
    values_to = "Value"
  ) %>%
  mutate(
    species = factor(species, levels = unique(table$species)),
    Group = factor(
      if_else(Sample %in% sample_names[1:4], "dsGFP", "dsCDC9"),
      levels = c("dsGFP", "dsCDC9")
    )
  )

table_long$species <- factor(table_long$species, levels=c("Acinetobacter_sp_1396970","Janthinobacterium_sp_Marseille"))

stats <- table_long %>%
  group_by(species, Group) %>%
  summarise(
    n = sum(!is.na(Value)),
    Mean = mean(Value, na.rm = TRUE),
    SEM = sd(Value, na.rm = TRUE) / sqrt(n),
    .groups = "drop"
  )

pdf('OTU_GFP_9_Bacteria_sem_1.pdf')
ggplot() +
  geom_col(
    data = stats,
    aes(x = species, y = Mean, fill = Group),
    position = position_dodge(width = 0.8),
    width = 0.7
  ) +
  
  geom_errorbar(
    data = stats,
    aes(
      x = species,
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
      x = species,
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
######################################################################################
table <- read.table('OTU_GFP_9.tab', head=TRUE)
sample_names <- names(table)[2:9]

table <-subset(table, table$species == "Sphingomonas_sp_LT1P40" |table$species ==  "Mitsuaria_sp_BK041"| table$species ==  "Wolbachia_endosymbiont_of_Frankliniella_intonsa" | table$species ==  "Wolbachia_endosymbiont_of_Melophagus_ovinus") 

table_long <- table %>%
pivot_longer(
    cols = all_of(sample_names),
    names_to = "Sample",
    values_to = "Value"
  ) %>%
  mutate(
    species = factor(species, levels = unique(table$species)),
    Group = factor(
      if_else(Sample %in% sample_names[1:4], "dsGFP", "dsCDC9"),
      levels = c("dsGFP", "dsCDC9")
    )
  )

table_long$species <- factor(table_long$species, levels=c("Sphingomonas_sp_LT1P40","Mitsuaria_sp_BK041","Wolbachia_endosymbiont_of_Melophagus_ovinus","Wolbachia_endosymbiont_of_Frankliniella_intonsa"))

stats <- table_long %>%
  group_by(species, Group) %>%
  summarise(
    n = sum(!is.na(Value)),
    Mean = mean(Value, na.rm = TRUE),
    SEM = sd(Value, na.rm = TRUE) / sqrt(n),
    .groups = "drop"
  )

pdf('OTU_GFP_9_Bacteria_sem_2.pdf')
ggplot() +
  geom_col(
    data = stats,
    aes(x = species, y = Mean, fill = Group),
    position = position_dodge(width = 0.8),
    width = 0.7
  ) +
  
  geom_errorbar(
    data = stats,
    aes(
      x = species,
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
      x = species,
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



