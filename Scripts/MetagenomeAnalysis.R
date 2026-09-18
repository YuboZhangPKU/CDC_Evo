library(vegan)
library(pheatmap)
library(ggplot2)
library(grid)
##################################################################
## absolute abundances of OTU
# alpha diversity
table <- read.table('OTU_GFP_9_foralpha.tab', head=TRUE, row.names=1)
dim(table)

alpha <- data.frame(
  Shannon = diversity(
    t(table),
    index = "shannon"
  )
)

alpha$Simpson <- diversity(
  t(table),
  index="simpson"
)

alpha$Chao1 <- estimateR(t(table))["S.chao1",]
alpha$ACE <- estimateR(t(table))["S.ACE",]

alpha$'group' <- factor(rep(c("dsGFP", "dsCDC9"), each = 4))

wilcox.test(
  Shannon ~ group,
  data = alpha
)
wilcox.test(
  Simpson ~ group,
  data = alpha
)
wilcox.test(
  Chao1 ~ group,
  data = alpha
)
wilcox.test(
  ACE ~ group,
  data = alpha
)

##################################################################
# beta diversity
table <- read.table('OTU_GFP_9.tab', head=TRUE, row.names=1)

bray_dist <- vegdist(t(table), method = "bray")
bray_matrix <- as.matrix(bray_dist)

group <- factor(rep(c("dsGFP", "dsCDC9"), each = 4))
pcoa_result <- cmdscale(bray_dist, k = 3, eig = TRUE) 

pcoa_points <- as.data.frame(pcoa_result$points)
colnames(pcoa_points) <- paste0("PCoA", 1:ncol(pcoa_points))
pcoa_points$Group <- group

eig <- pcoa_result$eig
variance_explained <- eig[1:3] / sum(eig[eig > 0]) * 100
cat("Variance explained by each axis:\n",
    "PCoA1:", round(variance_explained[1], 2), "%\n",
    "PCoA2:", round(variance_explained[2], 2), "%\n",
    "PCoA3:", round(variance_explained[3], 2), "%\n")

anosim_result <- anosim(bray_dist, group, permutations = 999)
print(anosim_result)

permanova_result <- adonis2(
  bray_dist ~ group,
  permutations = 999,
  method = "bray"
)
print(permanova_result)

#######################################################################################
library(mixOmics)
library(ggplot2)  
table <- read.table('OTU_GFP_9.tab', head=TRUE, row.names=1)

group <- factor(rep(c("dsGFP", "dsCDC9"), each = 4))
plsda.fit <- plsda(t(table), group, ncomp = 2)

table <- as.data.frame(plsda.fit$variates$X)
table$'group' <- factor(rep(c("dsGFP", "dsCDC9"), each = 4))
plsda.fit$explained_variance


######################################################################################
# differentially abundant taxa
table <- read.table('OTU_GFP_9.tab', head=TRUE, row.names=1)
group <- factor(rep(c("dsGFP", "dsCDC9"), each = 4))

results <- apply(table, 1, function(x) {
  test <- t.test(x ~ group)
  c(p.value = test$p.value, 
    statistic = test$statistic)
})

result_df <- as.data.frame(t(results))

result_df$adj.p.value <- p.adjust(result_df$p.value, method = "BH")

head(result_df[order(result_df$p.value), ])
write.csv(result_df[order(result_df$p.value), ],'OTU_GFP_9_ttest.csv')

######################################################################################
######################################################################################
## absolute abundances of virulence factors
# beta diversity

table <- read.table('VFCID.tab', head=TRUE, row.names=1)

bray_dist <- vegdist(t(table), method = "bray")
bray_matrix <- as.matrix(bray_dist)

group <- factor(rep(c("dsGFP", "dsCDC9"), each = 4))
pcoa_result <- cmdscale(bray_dist, k = 3, eig = TRUE) 

pcoa_points <- as.data.frame(pcoa_result$points)
colnames(pcoa_points) <- paste0("PCoA", 1:ncol(pcoa_points))
pcoa_points$Group <- group

eig <- pcoa_result$eig
variance_explained <- eig[1:3] / sum(eig[eig > 0]) * 100
cat("Variance explained by each axis:\n",
    "PCoA1:", round(variance_explained[1], 2), "%\n",
    "PCoA2:", round(variance_explained[2], 2), "%\n",
    "PCoA3:", round(variance_explained[3], 2), "%\n")


anosim_result <- anosim(bray_dist, group, permutations = 999)
print(anosim_result)

permanova_result <- adonis2(
  bray_dist ~ group,
  permutations = 999,
  method = "bray"
)

print(permanova_result)
######################################################################################
# differentially abundant factors
group <- factor(rep(c("dsGFP", "dsCDC9"), each = 4))

results <- apply(table, 1, function(x) {
  test <- wilcox.test(x ~ group)
  c(p.value = test$p.value, 
    statistic = test$statistic)
})

result_df <- as.data.frame(t(results))

result_df$adj.p.value <- p.adjust(result_df$p.value, method = "BH")

head(result_df[order(result_df$p.value), ])
write.csv(result_df,'VFCID_wilcox.csv')


######################################################################################
# differentially abundant genes
table <- read.table('VF_gene.tab', head=TRUE, row.names=1)

group <- factor(rep(c("dsGFP", "dsCDC9"), each = 4))

results <- apply(table, 1, function(x) {
  test <- wilcox.test(x ~ group)
  c(p.value = test$p.value, 
    statistic = test$statistic)
})

result_df <- as.data.frame(t(results))

result_df$adj.p.value <- p.adjust(result_df$p.value, method = "BH")

head(result_df[order(result_df$p.value), ])
write.csv(result_df,'VF_gene_rm_out_wilcox.csv')
