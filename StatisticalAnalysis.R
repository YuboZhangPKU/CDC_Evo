library(tidyr)
library(dplyr)
library(lme4)
library(lmerTest)
library(emmeans)


## figure 4h 

input_file <- "data_4h_CDC3.csv"

dat <- read.csv(input_file)

dat$ID = factor(dat$ID)
dat$Condition = factor(dat$Condition, levels = c("GST", "CDC3"))
dat$Position = factor(dat$Position, levels = c("Top", "Bottom"))
dat$Batch = factor(dat$Batch)

# ML fits are used for likelihood-ratio comparisons of fixed effects.
m_full <- lmer(FeedingTime ~ Condition * Position  + (1 |ID ), data = dat)

summary(m_full)

isSingular(m_full)

VarCorr(m_full)

anova(m_full)

#################################
input_file <- "data_4h_CDC9.csv"

dat <- read.csv(input_file)

dat$ID = factor(dat$ID)
dat$Condition = factor(dat$Condition, levels = c("GST", "CDC9"))
dat$Position = factor(dat$Position, levels = c("Top", "Bottom"))
dat$Batch = factor(dat$Batch)

# ML fits are used for likelihood-ratio comparisons of fixed effects.
m_full <- lmer(FeedingTime ~ Condition * Position  + (1 |ID ), data = dat)

summary(m_full)

isSingular(m_full)

VarCorr(m_full)

anova(m_full)

#########################################################
## figure 4i 
input_file <- "data_4i.csv"

wide <- read.csv(input_file)

dat <- wide %>%
  pivot_longer(
    cols = c(day1, day2, day3),
    names_to = "day",
    values_to = "value"
  ) %>%
  mutate(
    sample_id = factor(sample_id),
    group = factor(group, levels = c("G1", "G2", "G3")),
    day = factor(day, levels = c("day1", "day2", "day3"))
  )

# ML fits are used for likelihood-ratio comparisons of fixed effects.
m_full <- lmer(value ~ group * day + (1 | sample_id), data = dat)

summary(m_full)

isSingular(m_full)

VarCorr(m_full)

anova(m_full)

# Estimated marginal means and pairwise comparisons
emm_group_day <- emmeans(m_full, ~ group | day)
pairs(emm_group_day, adjust = "tukey")

#########################################################
input_file <- "data_4k.csv"

wide <- read.csv(input_file)

dat <- wide %>%
  pivot_longer(
    cols = c(day1,day3,day5,day7,day9,day11),
    names_to = "day",
    values_to = "value"
  ) %>%
  mutate(
    sample_id = factor(sample_id),
    group = factor(group, levels = c("dsGFP", "dsCDC3")),
    gender = factor(gender, levels = c("female", "male")),
    day = factor(day, levels = c("day1", "day3", "day5", "day7", "day9", "day11"))
  )

# ML fits are used for likelihood-ratio comparisons of fixed effects.
m_full <- lmer(value ~ group * day * gender + (1 | sample_id), data = dat)

summary(m_full)

isSingular(m_full)

VarCorr(m_full)

anova(m_full)

emm_group_day <- emmeans(m_full, ~ group | day| gender)
pairs(emm_group_day, adjust = "tukey")

#########################################################
# figure 5c 

fit <- glm(
  cbind(survived, total - survived) ~ group,
  family = binomial,
  data = data_5c
)

summary(fit)

anova(fit, test = "Chisq")

deviance(fit) / df.residual(fit)
#################################
fit_q <- glm(
  cbind(survived, total - survived) ~ group,
  family = quasibinomial,
  data = data_5c
)

summary(fit_q)

anova(fit_q)

#########################################################
# figure 5d

fit <- glm(
  offspring ~ treatment,
  family = poisson(link = "log"),
  data = data_5d
)

summary(fit)

anova(fit, test = "Chisq")
