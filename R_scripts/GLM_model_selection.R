### Generalised linear mixed models for the model-based model-free paper 
# Claire Smid, July 2021

# this logistic regression approach is based on supplementary material provided by Kool et al. 2016,
# 'When does model-based control pay-off?' 

# other sources used:
# https://ourcodingclub.github.io/tutorials/mixed-models/
# https://bbolker.github.io/mixedmodels-misc/glmmFAQ.html
# https://www.rdocumentation.org/packages/AICcmodavg/versions/2.3-1/topics/AICcmodavg-package

# load in files

Stay_kids_P7 <- read.csv('/stay_probabilities/Stay_Prob_Kids_P7.csv')
Stay_adlt_P7 <- read.csv('/stay_probabilities/Stay_Prob_Adults_P7.csv')

# check initial values:
range(Stay_kids_P7$prevpoints) # goes from 0 to 9
range(Stay_kids_P7$stay) # from 0 to 1
range(Stay_kids_P7$same) # from -1 to 1
range(Stay_kids_P7$prevrewdiff) # from 0 to 9

# make adult IDs
Stay_adlt_P7[1] <- Stay_adlt_P7[1]+200

names(Stay_kids_P7)
names(Stay_adlt_P7)

library(dplyr)

# MERGE IN AGE FOR KIDS to use as predictor (based on the Data_P dataframes from other R script)
Age_kids <- Data_P_Kids %>%
  select(ID,Age_frac,Median_Age_Split,Group)

names(Age_kids)[1] <- "subnr"

# combining this info
Stay_kids_P7_age <- merge(Stay_kids_P7,Age_kids)

# this will create z scored variable
Stay_kids_P7_age$Age_z <- scale(Stay_kids_P7_age$Age_frac, center = TRUE, scale = TRUE)

# this will create a centered variable
Stay_kids_P7_age$Age_c <- scale(Stay_kids_P7_age$Age_frac, center = TRUE, scale = FALSE)

# Split into younger and older children
Stay_P7_Yng_Kids <- Stay_kids_P7_age[which (Stay_kids_P7_age$Median_Age_Split==0),]
Stay_P7_Old_Kids <- Stay_kids_P7_age[which (Stay_kids_P7_age$Median_Age_Split==1),]

#install.packages('boot')
library(boot)
library(lme4)

#install.packages('stargazer')
library(stargazer)
library(ggeffects)
library(AICcmodavg)


### ----  for children

# z-score the variables (age already z-scored)
Stay_kids_P7_age$prevpoints <- scale(Stay_kids_P7_age$prevpoints, center = TRUE, scale = TRUE)
Stay_kids_P7_age$prevrewdiff <- scale(Stay_kids_P7_age$prevrewdiff, center = TRUE, scale = TRUE)

range(Stay_kids_P7_age$prevpoints)
range(Stay_kids_P7_age$prevrewdiff)
range(Stay_kids_P7_age$Age_z)

# nested model comparison with AICcmodavg
Cand.mod1 <- list()

# full model with age: interactions for all terms (global model)
Cand.mod1[[1]] <- glmer(stay ~ prevpoints * same * prevrewdiff * stake * Age_z + (1| subnr), data = Stay_kids_P7_age, 
                        family = binomial(link="logit"), control = glmerControl(optimizer = "bobyqa"))

# full model but age only added as fixed
Cand.mod1[[2]] <- glmer(stay ~ prevpoints * same * prevrewdiff * stake + Age_z + (1| subnr), data = Stay_kids_P7_age, 
                        family = binomial(link="logit"), control = glmerControl(optimizer = "bobyqa"))

# full model but stake only added as fixed
Cand.mod1[[3]] <- glmer(stay ~ prevpoints * same * prevrewdiff * Age_z + stake  + (1| subnr), data = Stay_kids_P7_age, 
                        family = binomial(link="logit"), control = glmerControl(optimizer = "bobyqa"))

# full model but age and stake only added as fixed
Cand.mod1[[4]] <- glmer(stay ~ prevpoints * same * prevrewdiff + Age_z + stake  + (1| subnr), data = Stay_kids_P7_age, 
                        family = binomial(link="logit"), control = glmerControl(optimizer = "bobyqa"))

# full model but age, stake and previous reward difference only added as fixed
Cand.mod1[[5]] <- glmer(stay ~ prevpoints * same + prevrewdiff + Age_z + stake  + (1| subnr), data = Stay_kids_P7_age, 
                        family = binomial(link="logit"), control = glmerControl(optimizer = "bobyqa"))

# all terms but no interactions
Cand.mod1[[6]] <- glmer(stay ~ prevpoints + same + prevrewdiff + Age_z + stake  + (1| subnr), data = Stay_kids_P7_age, 
                        family = binomial(link="logit"), control = glmerControl(optimizer = "bobyqa"))

# no previous reward difference, no interactions
Cand.mod1[[7]] <- glmer(stay ~ prevpoints + same + Age_z + stake  + (1| subnr), data = Stay_kids_P7_age, 
                        family = binomial(link="logit"), control = glmerControl(optimizer = "bobyqa"))

# no previous reward difference, full interactions
Cand.mod1[[8]] <- glmer(stay ~ prevpoints * same * Age_z * stake  + (1| subnr), data = Stay_kids_P7_age, 
                        family = binomial(link="logit"), control = glmerControl(optimizer = "bobyqa"))

# 3 interactions, previous points only fixed
Cand.mod1[[9]] <- glmer(stay ~ prevpoints + same * Age_z * stake  + (1| subnr), data = Stay_kids_P7_age, 
                        family = binomial(link="logit"), control = glmerControl(optimizer = "bobyqa"))

# age * stake interaction, previous points and same fixed
Cand.mod1[[10]] <- glmer(stay ~ prevpoints + same + Age_z * stake  + (1| subnr), data = Stay_kids_P7_age, 
                         family = binomial(link="logit"), control = glmerControl(optimizer = "bobyqa"))

# prevpoints * age interaction, stake fixed effect
Cand.mod1[[11]] <- glmer(stay ~ prevpoints * Age_z + stake  + (1| subnr), data = Stay_kids_P7_age, 
                         family = binomial(link="logit"), control = glmerControl(optimizer = "bobyqa"))

# 3-way interaction (stake)
Cand.mod1[[12]] <- glmer(stay ~ prevpoints * Age_z * stake  + (1| subnr), data = Stay_kids_P7_age, 
                         family = binomial(link="logit"), control = glmerControl(optimizer = "bobyqa"))

# 3-way interaction (same) (model-free decision-making interacts with age)
Cand.mod1[[13]] <- glmer(stay ~ prevpoints * Age_z * same  + (1| subnr), data = Stay_kids_P7_age, 
                         family = binomial(link="logit"), control = glmerControl(optimizer = "bobyqa"))

# previous points + same
Cand.mod1[[14]] <- glmer(stay ~ prevpoints + same  + (1| subnr), data = Stay_kids_P7_age, 
                         family = binomial(link="logit"), control = glmerControl(optimizer = "bobyqa"))

# previous points * same (pure model-free model)
Cand.mod1[[15]] <- glmer(stay ~ prevpoints * same  + (1| subnr), data = Stay_kids_P7_age, 
                         family = binomial(link="logit"), control = glmerControl(optimizer = "bobyqa"))

# previous points + age
Cand.mod1[[16]] <- glmer(stay ~ prevpoints + Age_z  + (1| subnr), data = Stay_kids_P7_age, 
                         family = binomial(link="logit"), control = glmerControl(optimizer = "bobyqa"))

# previous points * age (model-based decision-making interacts with age)
Cand.mod1[[17]] <- glmer(stay ~ prevpoints * Age_z  + (1| subnr), data = Stay_kids_P7_age, 
                         family = binomial(link="logit"), control = glmerControl(optimizer = "bobyqa"))

# previous points (pure model-based model)
Cand.mod1[[18]] <- glmer(stay ~ prevpoints  + (1| subnr), data = Stay_kids_P7_age, 
                         family = binomial(link="logit"), control = glmerControl(optimizer = "bobyqa"))

# age (pure developmental effect)
Cand.mod1[[19]] <- glmer(stay ~ Age_z  + (1| subnr), data = Stay_kids_P7_age, 
                         family = binomial(link="logit"), control = glmerControl(optimizer = "bobyqa"))

# null model
Cand.mod1[[20]] <- glmer(stay ~ 1 + (1| subnr), data = Stay_kids_P7_age, 
                         family = binomial(link="logit"), control = glmerControl(optimizer = "bobyqa"))


# assign names to each model
Modnames <- c("1prevp*same*prevd*stake*age","2prevp*same*prevd*stake+age","3prevp*same*prevd*age+stake",
              "4prevp*same*prevd+age+stake","5prevp*same+prevd+stake+age","6prevp+same+prevd+stake+age",
              "7prevp+same+age+stake","8prevp*same*age*stake","9prevp+same*age*stake","10prevp+same+age*stake",
              "11prevp*age+stake","12prevp*age*stake","13prevp*age*same","14prevp+same","15prevp*same",
              "16prevp+age","17prevp*age","18prevp","19age","20null")

# model selection table based on AICc
aictab(cand.set = Cand.mod1,modnames=Modnames)

# compute evidence ratio
confset(cand.set = Cand.mod1, modnames = Modnames, second.ord = TRUE,
        method = "ordinal")

# in summary, model 17 (previous points * age) is the best fitting model (AIC weight 0.37)
# previous points on its own is a significant positive predictor (model-based effect), and the interaction between previous
# points and age is significant and positive
# which supports the idea that model-based decision-making is present and increases with age for the children
summary(Cand.mod1[[17]])

# however the model with previous points, age and same and their interactions is close behind (AIC weight 0.28) 
# (no significant interactions with same though)
summary(Cand.mod1[[13]])

# in addition, the model with previous points * age + stake also has some evidence (AIC weight 0.14)


################## ----- ADULTS

### z-score variables
range(Stay_Adlts_P7_age$prevpoints)
range(Stay_Adlts_P7_age$same)
range(Stay_Adlts_P7_age$prevrewdiff)
range(Stay_Adlts_P7_age$stay)
range(Stay_Adlts_P7_age$stake)

Stay_Adlts_P7_age$prevpoints <- scale(Stay_Adlts_P7_age$prevpoints, center = TRUE, scale = TRUE)
Stay_Adlts_P7_age$prevrewdiff <- scale(Stay_Adlts_P7_age$prevrewdiff, center = TRUE, scale = TRUE)

range(Stay_Adlts_P7_age$prevpoints)
range(Stay_Adlts_P7_age$prevrewdiff)
range(Stay_Adlts_P7_age$Age_z)

# model comparison with AICcmodavg
# run for adults but without age interaction # based on discussion with Niko 18/06/21

Cand.mod2 <- list()

# full model: interactions for all terms (global model)
Cand.mod2[[1]] <- glmer(stay ~ prevpoints * same * prevrewdiff * stake  + (1| subnr), data = Stay_Adlts_P7_age, 
                        family = binomial(link="logit"), control = glmerControl(optimizer = "bobyqa"))

# full model but stake only added as fixed
Cand.mod2[[2]] <- glmer(stay ~ prevpoints * same * prevrewdiff  + stake  + (1| subnr), data = Stay_Adlts_P7_age, 
                        family = binomial(link="logit"), control = glmerControl(optimizer = "bobyqa"))

# full model but stake and previous reward difference only added as fixed
Cand.mod2[[3]] <- glmer(stay ~ prevpoints * same + prevrewdiff  + stake  + (1| subnr), data = Stay_Adlts_P7_age, 
                        family = binomial(link="logit"), control = glmerControl(optimizer = "bobyqa"))

# full model but no interactions
Cand.mod2[[4]] <- glmer(stay ~ prevpoints + same + prevrewdiff  + stake  + (1| subnr), data = Stay_Adlts_P7_age, 
                        family = binomial(link="logit"), control = glmerControl(optimizer = "bobyqa"))

# previous points, same and stake, no interactions
Cand.mod2[[5]] <- glmer(stay ~ prevpoints + same + stake  + (1| subnr), data = Stay_Adlts_P7_age, 
                        family = binomial(link="logit"), control = glmerControl(optimizer = "bobyqa"))

# previous points * same * stake (3 way interaction)
Cand.mod2[[6]] <- glmer(stay ~ prevpoints * same  * stake  + (1| subnr), data = Stay_Adlts_P7_age, 
                        family = binomial(link="logit"), control = glmerControl(optimizer = "bobyqa"))

# previous points + same * stake
Cand.mod2[[7]] <- glmer(stay ~ prevpoints + same  * stake  + (1| subnr), data = Stay_Adlts_P7_age, 
                        family = binomial(link="logit"), control = glmerControl(optimizer = "bobyqa"))

# previous points + stake
Cand.mod2[[8]] <- glmer(stay ~ prevpoints + stake  + (1| subnr), data = Stay_Adlts_P7_age, 
                        family = binomial(link="logit"), control = glmerControl(optimizer = "bobyqa"))

# previous points * stake (model-based decision-making differs per stake)
Cand.mod2[[9]] <- glmer(stay ~ prevpoints * stake  + (1| subnr), data = Stay_Adlts_P7_age, 
                        family = binomial(link="logit"), control = glmerControl(optimizer = "bobyqa"))

# previous points * same (pure model-free model)
Cand.mod2[[10]] <- glmer(stay ~ prevpoints * same  + (1| subnr), data = Stay_Adlts_P7_age, 
                         family = binomial(link="logit"), control = glmerControl(optimizer = "bobyqa"))

# previous points + same
Cand.mod2[[11]] <- glmer(stay ~ prevpoints + same  + (1| subnr), data = Stay_Adlts_P7_age, 
                         family = binomial(link="logit"), control = glmerControl(optimizer = "bobyqa"))

# previous points only (pure model-based)
Cand.mod2[[12]] <- glmer(stay ~ prevpoints   + (1| subnr), data = Stay_Adlts_P7_age, 
                         family = binomial(link="logit"), control = glmerControl(optimizer = "bobyqa"))

# same
Cand.mod2[[13]] <- glmer(stay ~ same   + (1| subnr), data = Stay_Adlts_P7_age, 
                         family = binomial(link="logit"), control = glmerControl(optimizer = "bobyqa"))

# stake
Cand.mod2[[14]] <- glmer(stay ~ stake   + (1| subnr), data = Stay_Adlts_P7_age, 
                         family = binomial(link="logit"), control = glmerControl(optimizer = "bobyqa"))

# null model
Cand.mod2[[15]] <- glmer(stay ~ 1 + (1| subnr), data = Stay_Adlts_P7_age, 
                         family = binomial(link="logit"), control = glmerControl(optimizer = "bobyqa"))

# assign names to each model
Modnames <- c("1prevp*same*prevd*stake","2prevp*same*prevd+stake","3prevp*same+prevd+stake",
              "4prevp+same+prevd+stake","5prevp+same+stake","6prevp*same*stake",
              "7prevp+same*stake","8prevp+stake","9prevp*stake","10prevp*same",
              "11prevp+same","12prevp","13same","14stake","15null")

# model selection table based on AICc
aictab(cand.set = Cand.mod2,modnames=Modnames)

# compute evidence ratio
confset(cand.set = Cand.mod2, modnames = Modnames, second.ord = TRUE,
        method = "ordinal")

# for the adults, the model with previous points, same and stake and their interactions was the best fit
summary(Cand.mod2[[6]])


############ ############ ############ ############ ############ ############ 
############ Plots
############ ############ ############ ############ ############ ############ 

#install.packages("ggiraphExtra")
#install.packages("ggiraph")
require(ggiraph)
require(ggiraphExtra)
require(plyr)
library(ggeffects)
library(ggplot2)


my_theme <-   theme(
  #legend.position = "none",
  plot.title = element_text(family="Arial",color="black", size=22 ,hjust = 0.5,margin=margin(0,0,10,0)),
  text = element_text(family="Arial", size=16),
  legend.title = element_text(size = 20),
  legend.text = element_text(size = 16),
  axis.title.y = element_text(color="black", size=18),
  axis.title.x = element_text(color="black", size=18, margin=margin(5,0,0,0)),
  axis.text.x = element_text(size = 16, margin=margin(5,0,0,0)),
  axis.text.y = element_text(size = 16, margin=margin(0,5,0,10))
)


### -------------------- Children

ggpredict(Cand.mod1[[17]], terms = "prevpoints")
ggpredict(Cand.mod1[[17]], terms = c("prevpoints","Age_z"))

mydf <- ggpredict(Cand.mod1[[17]], se = TRUE, terms = c("prevpoints","Age_z"))

ggplot(mydf, aes(x,predicted,colour = group)) + 
  geom_line(lwd=1) + 
  scale_y_continuous(name = "Predicted stay probability",breaks=seq(0.45,0.65,0.05),lim = c(0.43,0.65)) +
  scale_x_continuous(name = "Previous reward", breaks=seq(-2,2,1), lim = c(-2,2)) +
  scale_color_discrete(name = "Age (z-scored)",labels = c("-1","0","1"),
                       guide = guide_legend(reverse=TRUE)) +
  ggtitle("Generalised Linear Model of Stay Probability with\nprevious reward and age for children") +
  theme_light() +
  my_theme

# Saving plots with fixed dimensions, quality etc.
ggsave("Children_GLM_prevreward_age_lines.png", plot = last_plot(), path = '/R_Scripts/',
       scale = 1, width = 20, height = 16, units = "cm",
       dpi = 300)

# change axis to match adults
ggplot(mydf, aes(x,predicted,colour = group)) + 
  geom_line(lwd=1) + 
  scale_y_continuous(name = "Predicted stay probability",breaks=seq(0.25,1,0.25),lim = c(0.25,1)) +
  scale_x_continuous(name = "Previous reward", breaks=seq(-2,2,1), lim = c(-2,2)) +
  scale_color_discrete(name = "Age (z-scored)",labels = c("-1","0","1"),
                       guide = guide_legend(reverse=TRUE)) +
  ggtitle("Generalised Linear Model of Stay Probability with\nprevious reward and age for children") +
  theme_light() +
  my_theme

# Saving plots with fixed dimensions, quality etc.
ggsave("Children_GLM_prevreward_age_lines_sameAxisAsAdults.png", plot = last_plot(), path = '/R_Scripts/',
       scale = 1, width = 20, height = 16, units = "cm",
       dpi = 300)


### -------------------- Adults


mydf <- ggpredict(Cand.mod2[[6]], terms = c("prevpoints","same", "stake"))
levels(mydf$facet) <- c("Low Stakes","High Stakes")

ggplot(mydf, aes(x, predicted, colour = group)) + 
  geom_line() +
  facet_wrap(~facet) +
  scale_y_continuous(name = "Predicted stay probability",breaks=seq(0.25,1,0.25),lim = c(0.13,1)) +
  scale_x_continuous(name = "Previous reward", breaks=seq(-2,2,1), lim = c(-2,2)) +
  #scale_color_discrete(name = "Age (z-scored)",labels = c("-1","0","1"),
  #                     guide = guide_legend(reverse=TRUE)) +
  scale_color_discrete(name = "State\nSimilarity",labels = c("Different","Same"),
                       guide = guide_legend(reverse=TRUE)) +
  ggtitle("Generalised Linear Model of Stay Probability with\nprevious reward, age and stake for adults") +
  theme_light() +
  my_theme

# Saving plots with fixed dimensions, quality etc.
ggsave("Adults_GLM_prevreward_lines.png", plot = last_plot(), path = '/R_Scripts/',
       scale = 1, width = 26, height = 16, units = "cm",
       dpi = 300)

