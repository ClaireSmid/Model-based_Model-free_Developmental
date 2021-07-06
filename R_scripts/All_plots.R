# this script makes the main outcome plots for the paper
# Claire Smid, July 2021

# get necessary packages
library(ggplot2)
library(lattice)
library(reshape2)
library(ggrepel)
library(Rmisc)
library(dplyr)
library(tidyr)
library(ggnewscale)
library(rlang)
library(gridExtra)
library(cowplot)

#install.packages("extrafont")
library(extrafont)
font_import()
loadfonts(device="win")       #Register fonts for Windows bitmap output
#loadfonts(device="pdf")       #if on mac
fonts()    

# data from 7 parameter model for both children and adults
Data_P <- read.csv('/RL_7params/*.csv')

# long data per stake
Data_P_L <- read.csv('/RL_7params/*long*.csv')

# data from 6 parameter model for both children and adults
Data_6 <- read.csv('/RL_6params/*.csv')
names(Data_6)

# make data frames out of both
Data_P <- data.frame(Data_P)
Data_P_L <- data.frame(Data_P_L)
Data_6 <- data.frame(Data_6)

#### SUBSETS
# Subset kids and adults
Data_P_Kids <- Data_P[which (Data_P$Group==1),]
Data_P_Adults <- Data_P[which (Data_P$Group==2),]

# Also for long data
Data_P_L_Kids <- Data_P_L[which (Data_P_L$Group==1),]
Data_P_L_Adlt <- Data_P_L[which (Data_P_L$Group==2),]

# Also for P6 data
Data_6_Kids <- Data_6[which (Data_6$Group==1),]
Data_6_Adlts <- Data_6[which (Data_6$Group==2),]

#### SUBSETS
# younger and older children
Data_P_Yng_Kids <- Data_P_Kids[which (Data_P_Kids$Median_Age_Split==0),]
Data_P_Old_Kids <- Data_P_Kids[which (Data_P_Kids$Median_Age_Split==1),]

# younger and older children for 6 parameters
Data_6_Yng_Kids <- Data_6_Kids[which (Data_6_Kids$Median_Age_Split==0),]
Data_6_Old_Kids <- Data_6_Kids[which (Data_6_Kids$Median_Age_Split==1),]

# make factors
Data_6 <- within(Data_6,{
  Age <- factor(Age)
  Gender <- factor(Gender)
  Group <- factor(Group)
  Age_Kids_Only <- factor(Age_Kids_Only)
  Median_Age_Split <- factor(Median_Age_Split)
})

Data_P <- within(Data_P,{
  Age <- factor(Age)
  Gender <- factor(Gender)
  Group <- factor(Group)
  Age_Kids_Only <- factor(Age_Kids_Only)
  Median_Age_Split <- factor(Median_Age_Split)
})

Data_P_Kids <- within(Data_P_Kids,{
  Gender <- factor(Gender)
  Group <- factor(Group)
  Age_Kids_Only <- factor(Age_Kids_Only)
  Median_Age_Split <- factor(Median_Age_Split)
})

Data_P_Adults <- within(Data_P_Adults,{
  Gender <- factor(Gender)
  Group <- factor(Group)
  Age_Kids_Only <- factor(Age_Kids_Only)
  Median_Age_Split <- factor(Median_Age_Split)
})


# ------------------- importing random simulation data
library(reshape2)
### random sims
Ransims <- read.csv('random_sims/*.csv')

Ransims <- within(Ransims,{
  id <- factor(id)
  #Sims <- factor(Sims)
})

RanSimsL<- melt(Ransims, id.vars=c("id"), measure.vars=c("actual_Avg_Pts", "Random_Kool_Pts"), variable.name="Sims",value.name="Corr_Points")

levels(RanSimsL$Sims)[levels(RanSimsL$Sims)=="actual_Avg_Pts"] <- "0"
levels(RanSimsL$Sims)[levels(RanSimsL$Sims)=="Random_Kool_Pts"] <- "1"


# ------------------- importing Model Free simulation data
library(dplyr)
MF_Sims <- read.csv('/model_free_simulations/*.csv')
MF_Sims$Sims <- 1

Real_Kids <- Data_6_Kids %>%
  select(ID,w)

Real_Kids$Sims <- 0

names(MF_Sims)[1] <- "ID"
names(MF_Sims)[2] <- "w"

MF_Sims_Kids <- rbind(Real_Kids,MF_Sims)

MF_Sims_Kids <- within(MF_Sims_Kids,{
  Sims <- factor(Sims)
})


#-------------------------------------------------------------------------------------------------------
##########################################################################################################
# --- Plot themes
##########################################################################################################
#-------------------------------------------------------------------------------------------------------

# changed font from Georgia to Arial

my_theme <-   theme(
  #legend.position = "none",
  plot.title = element_text(family="Arial",color="black", size=28 ,hjust = 0.5,margin=margin(0,0,10,0)),
  text = element_text(family="Arial", size=20),
  legend.title = element_text(size = 26),
  legend.text = element_text(size = 22),
  axis.title.y = element_text(color="black", size=24),
  axis.title.x = element_text(color="black", size=24, margin=margin(5,0,0,0)),
  axis.text.x = element_text(size = 22, margin=margin(5,0,0,0)),
  axis.text.y = element_text(size = 22, margin=margin(0,5,0,10))
)

fig3_theme <- theme(
  text = element_text(family="Arial", size=16),
  plot.title = element_text(color="black", size=20 ,hjust = 0.5,margin=margin(0,0,10,0)),
  panel.border = element_blank(),
  axis.line = element_line(colour = "black"),
  #legend.title = element_blank(),
  axis.title.x = element_text(color="black", size=18, margin=margin(20,0,0,0)),
  axis.title.y = element_text(color="black", size=18),
  axis.text.x = element_text(size = 16, margin=margin(5,0,0,0)),
  axis.text.y = element_text(size = 16, margin=margin(0,5,0,10))
  # legend.text = element_text(size = 16),
  # axis.title.y = element_text(color="black", size=18),
  # axis.title.x = element_text(color="black", size=18, margin=margin(5,0,0,0)),
  
)

fig3_adlt_theme <- theme(
  axis.title.y = element_blank(),
  axis.text.y = element_blank(),
  axis.ticks.y=element_blank(),
  
  #axis.title.x = element_blank(),
  axis.text.x = element_text(size = 16, margin=margin(5,0,0,0)),
  axis.title.x = element_text(color="black", size=18, margin=margin(20,0,0,0)),
  axis.ticks.x = element_blank(),
  
  panel.border = element_blank(),
  panel.grid.major = element_blank(),
  panel.grid.minor = element_blank(),
  panel.background = element_blank(),
  axis.line.y = element_blank(),
  #axis.line = element_blank(),
)

adult_shape = 23
kid_shape = 21
point_size = 4
plots_folder = '/Users/claire.smid/Dropbox/MBMF_Recoverability_May2021/R_Scripts/'

### ---------------- Figure 1. stakes effect for adults

# w over stakes
Data_P_L_Adlt <- data.frame(Data_P_L_Adlt)

adlt <- summarySE(data = Data_P_L_Adlt, measurevar = "w", groupvars = "Stake")
adlts <- adlt[which (adlt$Group==2),] 

plot.adult <- ggplot(Data_P_L_Adlt, aes(x = Stake, y = w, fill = Stake)) +
  geom_bar(stat = "summary", aes(x = Stake, y = w, fill = Stake), 
           position= "dodge",width=0.5, color = "black", alpha = 1) +
  geom_jitter(aes(fill = Stake), shape = adult_shape, size = point_size, 
              position = position_jitter(0.3), alpha = 1) +
  geom_errorbar(data = adlt, aes(x = Stake, ymin=w-ci, ymax=w+ci), position=position_dodge(.6),
                width = 0.2, size = 1, color = "black") +
  geom_hline(yintercept = mean(MF_Sims$w), size = 1, color="black", linetype = "dashed") +
  scale_fill_manual(name = "Stakes", values = c("#c5c5c5","#fc8d39"),label=c("Low","High")) +
  scale_x_discrete(name = "Adults", labels = c("Low","High")) +
  scale_y_continuous(breaks=seq(0,1,0.25), lim = c(0,1)) +
  guides(color=FALSE) +
  ggtitle('Model-based DM over stakes for adults') +
  #guides(color=guide_legend(override.aes=list(shape = 22))) +
  theme_light() +
  fig3_theme 


plot.adult

# Saving plots with fixed dimensions, quality etc.
ggsave("Stakes_adults.png", plot = last_plot(), path = plots_folder,
       scale = 1, width = 14, height = 16, units = "cm",
       dpi = 300)



### ---------------- Figure 2. relationship between w and average points

### plot the graph
wPts <- ggplot(data = Data_6, aes(color = Age_Kids_Only, fill = Age_Kids_Only, shape = Group)) +
  # individual points
  geom_point(data = Data_6, aes(x = Avg_Pts, y = w, shape=Group, color = Age_Kids_Only),
             stroke = 1, size = point_size, alpha = 0.8, colour = "black") +
  scale_shape_manual(values=c(kid_shape, adult_shape),labels = c("children", "adults")) +
  # regression line
  stat_smooth(data = Data_6, inherit.aes = F, aes(
    x = Avg_Pts, y = w), color = "black", size = 1.5,
    linetype = "solid", method = "lm", formula = y ~ x, se = T) +
  scale_color_brewer(palette = "Blues", guide=FALSE) +
  scale_fill_brewer(palette = "Blues", guide=FALSE) +
  guides(color = FALSE, fill = FALSE, shape = FALSE) +
  coord_cartesian(ylim = c(0,1)) +
  #scale_y_continuous(lim = c(-2,3)) +
  #scale_x_continuous(breaks=seq(5,12,1), lim = c(5,12)) +
  #scale_x_log10(breaks=c(5, 6, 7, 8, 9, 10, 11, 30)) + # log scale for age
  ggtitle('Model-based Decision-Making and Performance') +
  xlab('Corrected Reward Rate (Performance)') +
  ylab('Model-Based DM (w)') +
  theme_light() +
  fig3_theme 

wPts

ggsave("Corr_w_Avg_Pts.png", plot = last_plot(), path = plots_folder,
       scale = 1, width = 24, height = 16, units = "cm",
       dpi = 300)


### ---------------- Figure 3. w age boxplots for children

# get means for the two groups of children (younger and older children)
MB_Group <- summarySE(data = Data_6_Kids, measurevar = "w", groupvars = c("Age_Bins"))

Data_6_Kids$Age_Bins <- factor(Data_6_Kids$Age_Bins,levels=c("5","6","7","8","9","10","11"))

### this one leaves out the barplots and the mean lines, it just gets too messy else. maybe can plot this just for the kids after all.
# (this graphs is mainly important to show the relationship between the stakes and MB DM for the kids anyways)
agebinx <- ggplot(data = Data_6_Kids, aes(x = Age_Bins, y = w, color = Age_Bins, fill = Age_Bins)) +
  geom_jitter(data = Data_6_Kids, aes(x = Age_Bins, y = w), shape = kid_shape, stroke = 1, size = point_size, color = "black", alpha = 0.8) +
  geom_boxplot(data = Data_6_Kids, alpha = 0.2) +
  
  geom_hline(yintercept = mean(MF_Sims$w), size = 1, color="black", linetype = "dashed") +
  scale_y_continuous(breaks=seq(0,1,0.25), lim = c(0,1)) +
  #scale_x_discrete(breaks=seq(5,11,1), lim = c(5,11.5)) +
  ggtitle('Model-based decision making for children over years') +
  #ggtitle('Model-based decision-making for both low and\nhigh stakes for children') +
  xlab('Age (in years)') +
  ylab('Model-based DM' ~italic(w)) +
  #guides(color = FALSE, fill = FALSE, shape = FALSE) +
  theme_light() +
  #my_theme +
  fig3_theme

agebinx

# Saving plots with fixed dimensions, quality etc.
ggsave("Age_Bins_w_kids.png", plot = last_plot(), path = plots_folder,
       scale = 1, width = 24, height = 16, units = "cm",
       dpi = 300)


### ---------------- Figure 4. w age boxplots for adults

### for ADULTS
### this one leaves out the barplots and the mean lines, it just gets too messy else. maybe can plot this just for the kids after all.
# (this graphs is mainly important to show the relationship between the stakes and MB DM for the kids anyways)

Data_6_Adlts$Age_Bins <- factor(Data_6_Adlts$Age_Bins,levels=c("18-21","22-25","26-29","30+"))

agebinx <- ggplot(data = Data_6_Adlts, aes(x = Age_Bins, y = w, color = Age_Bins, fill = Age_Bins)) +
  geom_jitter(data = Data_6_Adlts, aes(x = Age_Bins, y = w), shape = adult_shape, stroke = 1, 
              size = point_size, color = "black", alpha = 0.8) +
  geom_boxplot(data = Data_6_Adlts, alpha = 0.2) +
  geom_hline(yintercept = mean(MF_Sims$w), size = 1, color="black", linetype = "dashed") +
  scale_y_continuous(breaks=seq(0,1,0.25), lim = c(0,1)) +
  #scale_x_discrete(breaks=seq(5,11,1), lim = c(5,11.5)) +
  ggtitle('Corrected reward rate (Performance) for adults over years') +
  #ggtitle('Model-based decision-making for both low and\nhigh stakes for children') +
  xlab('Age (in years)') +
  ylab('Corrected Reward Rate') +
  #guides(color = FALSE, fill = FALSE, shape = FALSE) +
  theme_light() +
  #my_theme +
  fig3_theme

agebinx

# Saving plots with fixed dimensions, quality etc.
ggsave("Age_Bins_w_adults.png", plot = last_plot(), path = plots_folder,
       scale = 1, width = 24, height = 16, units = "cm",
       dpi = 300)



### ---------------- Figure 5. w over age for children with adults plotted separately

library(RColorBrewer)

MBplot <- ggplot(data = Data_6_Kids,fill = Age_Kids_Only) +
  geom_point(data=Data_6_Kids,aes(x = Age_frac, y = w, fill = Age_Kids_Only),shape = kid_shape,stroke = 1, size = point_size) +
  stat_smooth(data = Data_6_Kids, inherit.aes = F, aes(x = Age_frac, y = w), color = "#c5c5c5", fill ="#c5c5c5", 
              alpha = 0.7, size = 1, linetype = "solid", method = "lm", formula = y ~ x, se = T) +
  stat_smooth(data = Data_6_Kids, inherit.aes = F, aes(x = Age_frac, y = w), color = "black", size = 1.25,  
              linetype = "solid", method = "lm", formula = y ~ x, se = F) +
  geom_hline(yintercept = mean(MF_Sims$w), size = 1, color="black", linetype = "dashed") +
  scale_x_continuous(breaks=seq(5,11,1), lim = c(5,11.5)) +
  scale_y_continuous(breaks=seq(0,1,0.25), lim = c(0,1)) +
  guides(color = FALSE, fill = FALSE, shape = FALSE) +
  scale_color_brewer(palette = "Blues") +
  scale_fill_brewer(palette = "Blues") +
  #ggtitle('Model-based decision making for children') +
  xlab('Age (in years)') +
  ylab('Model-based DM' ~italic(w)) +
  theme_light() +
  fig3_theme 

MBplot

# Saving plots with fixed dimensions, quality etc.
ggsave("Children_age_single_w.png", plot = last_plot(), path = plots_folder,
       scale = 1, width = 24, height = 16, units = "cm",
       dpi = 300)


### adult plot
Data_6_Adlts <- data.frame(Data_6_Adlts)
adlt <- summarySE(data = Data_6_Adlts, measurevar = "w", groupvars = "Group")
adlts <- adlt[which (adlt$Group==2),] 

plot.adult <- ggplot(Data_6_Adlts, aes(x = Group, y = w), color = Age_Kids_Only, 
                     fill = Age_Kids_Only, shape = Group) + 
  geom_jitter(data = Data_6_Adlts, aes(x = Group, y = w, fill = Age_Kids_Only), shape = adult_shape, 
              size = point_size, color = "black", fill ="#08306b", stroke = 1, position = position_jitter(0.3),  alpha = 0.8) +
  #geom_bar(data = adlts, stat = "identity", aes(x = Group, y = eg),  width = 0.4, 
  #         alpha = 0.01, size = 0.8, color = "black", fill = "white") +
  geom_errorbar(data = adlts, aes(x = Group, ymin=w-ci, ymax=w+ci), position=position_dodge(.6),
                width = 0.2, size = 1, color = "black") +
  geom_point(data=adlts,aes(x=Group,y=mean(adlt$w)),color='red',size=point_size+1) +
  geom_hline(yintercept = mean(MF_Sims$w), size = 1, color="black", linetype = "dashed") +
  scale_y_continuous(breaks=seq(0,1,0.25), lim = c(0,1)) +
  #ggtitle('eligibility trace') +
  scale_x_discrete(name = "Adults", labels = "") +
  theme_light() +
  fig3_theme +
  fig3_adlt_theme

plot.adult


###
title <- ggdraw() + 
  draw_label(
    "Model-based decision-making for children increases over age\n(adults plotted separately)",
    #"Model-based decision-making for children over\nage and adults plotted separately",
    fontfamily = "Arial",
    fontface = "plain",
    size = 20,
    hjust = 0.5
  )


# combine plots & align
gg <- plot_grid(MBplot, plot.adult, align = "h", rel_widths = c(6, 1))

gg

g_title1 <- plot_grid(title,gg, nrow=2, rel_heights = c(1,9))

g_title1


# # Saving plots with fixed dimensions, quality etc.
ggsave("w_regression_kids_adults.png", plot = last_plot(), path = plots_folder,
       scale = 1, width = 24, height = 16, units = "cm",
       dpi = 300)


### ---------------- Figure 6. performance over age for the children

### plot the graph
Age_perf <- ggplot(data = Data_P_Kids, aes(color = Age_Kids_Only, fill = Age_Kids_Only)) +
  # individual points
  geom_point(data = Data_P_Kids, aes(x = Age_frac, y = Avg_Pts, color = Age_Kids_Only),
             shape = kid_shape, stroke = 1, size = point_size, alpha = 0.8, colour = "black") +
  # mean lines
  geom_hline(yintercept = 0, size = 1, color="black", linetype = "dashed") +
  # regression line
  stat_smooth(data = Data_P_Kids, inherit.aes = F, aes(
    x = Age_frac, y = Avg_Pts), color = "black", size = 1.5,
    linetype = "solid", method = "lm", formula = y ~ x, se = T) +
  scale_color_brewer(palette = "Blues", guide=FALSE) +
  scale_fill_brewer(palette = "Blues", guide=FALSE) +
  guides(color = FALSE, fill = FALSE, shape = FALSE) +
  #coord_cartesian(ylim = c(0,1)) +
  scale_x_continuous(breaks=seq(5,12,1), lim = c(5,12)) +
  #scale_x_log10(breaks=c(5, 6, 7, 8, 9, 10, 11, 30)) + # log scale for age
  ggtitle('Performance') +
  xlab('Age (in years)') +
  ylab('Corrected Reward Rate') +
  theme_light() +
  fig3_theme 

Age_perf



### ---------------- Figure 7. boxplot of w over 3 age groups

Data_UNI_L <- within(Data_P_L,{
  Stake <- factor(Stake)
  Age <- factor(Age_Kids_Only)
  Median_Age_Split <- factor(Median_Age_Split)
})

# get means for the three groups (younger children, older children and adults)
MB_3Group <- summarySE(data = Data_P_L, measurevar = "w", groupvars = c("Median_Age_Split","Stake"))

MB_3G <- ggplot(data = MB_3Group, aes(x = Median_Age_Split, color = Stake, fill = Stake)) +
  geom_bar(stat = "identity", aes(x = Median_Age_Split, y = w), 
           position= "dodge", color = "black", alpha = 1) +
  geom_errorbar(aes(x = Median_Age_Split, ymin=w-ci, ymax=w+ci), position=position_dodge(.9),
                width = 0.2, size = 1, color = "black") +
  geom_point(data = Data_P_L, aes(x = Median_Age_Split, y = w, color = Stake, fill = Stake), 
             position = position_jitterdodge(jitter.width = 0.4, dodge.width = 0.8), 
             color = "black", shape = 23, size = point_size, stroke = 1, 
             #position = position_dodge(0.6), size = 1.5, color = "black", 
             alpha = 0.4, show.legend = F) +
  scale_x_discrete(name = "Median Age Split", labels = c("young children", "older children", "adults")) +
  scale_fill_manual(name = "Stakes", values = c("#c5c5c5","#fc8d39"),labels=c("Low","High"), guide = guide_legend(reverse = TRUE) ) +
  scale_y_continuous(lim = c(0,1)) +
  ggtitle('Model-based decision making for both low and high stakes') +
  ylab('Model-based DM' ~italic(w)) +
  #xlab('Ages') +
  theme_light() +
  my_theme 

MB_3G

# Saving plots with fixed dimensions, quality etc.
ggsave("MB_Lo+Hi_3AgeGroups.png", plot = last_plot(), path = plots_folder,
       scale = 1, width = 26, height = 16, units = "cm",
       dpi = 300)



### ---------------- Figure 3.1 learning rate over age for children with adults separate 

### adult and kids version
Data_P_Kids <- within(Data_P_Kids,{
  Age_Kids_Only <- factor(round(Age_frac))
  Group <- factor(Group)
})

### adult and kids version
Data_P_Adults <- within(Data_P_Adults,{
  Age_Kids_Only <- 25
  Group <- factor(Group)
})

### plot the graph
kids_LR <- ggplot(data = Data_P_Kids, aes(color = Age_Kids_Only, fill = Age_Kids_Only, shape = Group)) +
  # individual points
  geom_point(data = Data_P_Kids, aes(x = Age_frac, y = lr, color = Age_Kids_Only),
             stroke = 1, size = point_size, shape = kid_shape, alpha = 0.8, colour = "black") +
  scale_shape_manual(values=c(21, 23),labels = c("children", "adults")) +
  # mean lines
  geom_hline(yintercept = mean(Data_P_Kids$lr), size = 1, color="#6baed6", linetype = "dashed") +
  # regression line
  stat_smooth(data = Data_P_Kids, inherit.aes = F, aes(
    x = Age_frac, y = lr), color = "black", size = 1.5,
    linetype = "solid", method = "lm", formula = y ~ x, se = T) +
  scale_color_brewer(palette = "Blues", guide=FALSE) +
  scale_fill_brewer(palette = "Blues", guide=FALSE) +
  guides(color = FALSE, fill = FALSE, shape = FALSE) +
  coord_cartesian(ylim = c(0,1)) +
  scale_x_continuous(breaks=seq(5,12,1), lim = c(5,12)) +
  #scale_x_log10(breaks=c(5, 6, 7, 8, 9, 10, 11, 30)) + # log scale for age
  ggtitle('Learning rate') +
  xlab('Age (in years)') +
  ylab('Learning rate \U03B1') +
  theme_light() +
  fig3_theme 

kids_LR


### adult plot
Data_P_Adults <- data.frame(Data_P_Adults)
adlt <- summarySE(data = Data_P, measurevar = "lr", groupvars = "Group")
adlts <- adlt[which (adlt$Group==2),] 

plot.adult <- ggplot(Data_P_Adults, aes(x = Group, y = lr), color = Age_Kids_Only, 
                     fill = Age_Kids_Only) + 
  geom_violin() +
  geom_jitter(data = Data_P_Adults, aes(x = Group, y = lr, fill = Age_Kids_Only), shape = adult_shape, 
              size = point_size, color = "grey", fill ="#08306b", stroke = 1, position = position_jitter(0.3),  alpha = 0.6) +
  
  #geom_bar(data = adlts, stat = "identity", aes(x = Group, y = lr),  width = 0.4, 
  #         alpha = 0.01, size = 0.8, color = "black", fill = "white") +
  geom_errorbar(data = adlts, aes(x = Group, ymin=lr-ci, ymax=lr+ci), position=position_dodge(.6),
                width = 0.2, size = 1, color = "black") +
  geom_hline(yintercept = mean(Data_P_Kids$lr), size = 1, color="#6baed6", linetype = "dashed") +
  #coord_cartesian(ylim = c(0,1)) +
  scale_y_continuous(lim=c(0,1)) +
  #ggtitle('eligibility trace') +
  scale_x_discrete(name = "Adults", labels = "") +
  theme_light() +
  fig3_theme +
  fig3_adlt_theme

plot.adult

# combine plots & align
plot_grid(kids_LR, plot.adult, align = "h", rel_widths = c(6, 1))

# # Saving plots with fixed dimensions, quality etc.
ggsave("LR_kids_adults.png", plot = last_plot(), path = plots_folder,
       scale = 1, width = 24, height = 16, units = "cm",
       dpi = 300)


### ---------------- Figure 3.2 inverse temperature over age for children with adults separate 

### plot the graph
kids <- ggplot(data = Data_P_Kids, aes(color = Age_Kids_Only, fill = Age_Kids_Only, shape = Group)) +
  # individual points
  geom_point(data = Data_P_Kids, aes(x = Age_frac, y = it, color = Age_Kids_Only),
             stroke = 1, size = point_size, shape = kid_shape, alpha = 0.8, colour = "black") +
  geom_hline(yintercept = mean(Data_P_Kids$it), size = 1, color="#6baed6", linetype = "dashed") +
  # regression line
  stat_smooth(data = Data_P_Kids, inherit.aes = F, aes(
    x = Age_frac, y = it), color = "black", size = 1.5,
    linetype = "solid", method = "lm", formula = y ~ x, se = T) +
  scale_color_brewer(palette = "Blues", guide=FALSE) +
  scale_fill_brewer(palette = "Blues", guide=FALSE) +
  guides(color = FALSE, fill = FALSE, shape = FALSE) +
  #coord_cartesian(ylim = c(0,1)) +
  scale_y_continuous(lim = c(0,4)) +
  scale_x_continuous(breaks=seq(5,12,1), lim = c(5,12)) +
  #scale_x_log10(breaks=c(5, 6, 7, 8, 9, 10, 11, 30)) + # log scale for age
  ggtitle('Inverse temperature') +
  xlab('Age (in years)') +
  ylab('Inverse temperature \U03B2') +
  theme_light() +
  fig3_theme 

kids

### adult plot
Data_P_Adults <- data.frame(Data_P_Adults)
adlt <- summarySE(data = Data_P, measurevar = "it", groupvars = "Group")
adlts <- adlt[which (adlt$Group==2),] 

plot.adult <- ggplot(Data_P_Adults, aes(x = Group, y = it), color = Age_Kids_Only, 
                     fill = Age_Kids_Only) + 
  geom_violin() +
  geom_jitter(data = Data_P_Adults, aes(x = Group, y = it, fill = Age_Kids_Only), shape = adult_shape, 
              size = point_size, color = "grey", fill ="#08306b", stroke = 1, position = position_jitter(0.3),  alpha = 0.6) +
  #geom_bar(data = adlts, stat = "identity", aes(x = Group, y = it),  width = 0.4, 
  #         alpha = 0.01, size = 0.8, color = "black", fill = "white") +
  geom_errorbar(data = adlts, aes(x = Group, ymin=it-ci, ymax=it+ci), position=position_dodge(.6),
                width = 0.2, size = 1, color = "black") +
  geom_hline(yintercept = mean(Data_P_Kids$it), size = 1, color="#6baed6", linetype = "dashed") +
  #coord_cartesian(ylim = c(0,1)) +
  
  scale_y_continuous(lim=c(0,4)) +
  #ggtitle('eligibility trace') +
  scale_x_discrete(name = "Adults", labels = "") +
  theme_light() +
  fig3_theme +
  fig3_adlt_theme

plot.adult


# combine plots & align
plot_grid(kids, plot.adult, align = "h", rel_widths = c(6, 1))

# # Saving plots with fixed dimensions, quality etc.
ggsave("IT_kids_adults.png", plot = last_plot(), path = plots_folder,
       scale = 1, width = 24, height = 16, units = "cm",
       dpi = 300)


### ---------------- Figure 3.3 eligibility trace over age for children with adults separate 

### plot the graph
kids <- ggplot(data = Data_P_Kids, aes(color = Age_Kids_Only, fill = Age_Kids_Only)) +
  # individual points
  geom_point(data = Data_P_Kids, aes(x = Age_frac, y = eg, color = Age_Kids_Only),
             stroke = 1, size = point_size, shape = kid_shape, alpha = 0.8, colour = "black") +
  # mean lines
  geom_hline(yintercept = mean(Data_P_Kids$eg), size = 1, color="#6baed6", linetype = "dashed") +
  # regression line
  stat_smooth(data = Data_P_Kids, inherit.aes = F, aes(
    x = Age_frac, y = eg), color = "black", size = 1.5,
    linetype = "solid", method = "lm", formula = y ~ x, se = T) +
  scale_color_brewer(palette = "Blues", guide=FALSE) +
  scale_fill_brewer(palette = "Blues", guide=FALSE) +
  guides(color = FALSE, fill = FALSE, shape = FALSE) +
  coord_cartesian(ylim = c(0,1)) +
  #scale_y_continuous(lim = c(0,5)) +
  scale_x_continuous(breaks=seq(5,12,1), lim = c(5,12)) +
  #scale_x_log10(breaks=c(5, 6, 7, 8, 9, 10, 11, 30)) + # log scale for age
  ggtitle('Eligibility trace') +
  xlab('Age (in years)') +
  ylab('Eligibility trace' ~italic(e)) +
  theme_light() +
  fig3_theme 

kids


### adult plot
Data_P_Adults <- data.frame(Data_P_Adults)
adlt <- summarySE(data = Data_P, measurevar = "eg", groupvars = "Group")
adlts <- adlt[which (adlt$Group==2),] 

plot.adult <- ggplot(Data_P_Adults, aes(x = Group, y = eg), color = Age_Kids_Only, 
                     fill = Age_Kids_Only, shape = Group) + 
  geom_violin()+
  geom_jitter(data = Data_P_Adults, aes(x = Group, y = eg, fill = Age_Kids_Only), shape = adult_shape, 
              size = point_size, color = "grey", fill ="#08306b", stroke = 1, position = position_jitter(0.3),  alpha = 0.6) +
  #geom_bar(data = adlts, stat = "identity", aes(x = Group, y = eg),  width = 0.4, 
  #         alpha = 0.01, size = 0.8, color = "black", fill = "white") +
  geom_errorbar(data = adlts, aes(x = Group, ymin=eg-ci, ymax=eg+ci), position=position_dodge(.6),
                width = 0.2, size = 1, color = "black") +
  #coord_cartesian(ylim = c(0,1)) +
  geom_hline(yintercept = mean(Data_P_Kids$eg), size = 1, color="#6baed6", linetype = "dashed") +
  
  scale_y_continuous(lim=c(0,1)) +
  #ggtitle('eligibility trace') +
  scale_x_discrete(name = "Adults", labels = "") +
  theme_light() +
  fig3_theme +
  fig3_adlt_theme

plot.adult



# combine plots & align
plot_grid(kids, plot.adult, align = "h", rel_widths = c(6, 1))

# # Saving plots with fixed dimensions, quality etc.
ggsave("eg_kids_adults.png", plot = last_plot(), path = plots_folder,
       scale = 1, width = 24, height = 16, units = "cm",
       dpi = 300)


### ---------------- Figure 3.3 sticky 1 over age for children with adults separate

### plot the graph
kids <- ggplot(data = Data_P_Kids, aes(color = Age_Kids_Only, fill = Age_Kids_Only)) +
  # individual points
  geom_point(data = Data_P_Kids, aes(x = Age_frac, y = st, color = Age_Kids_Only),
             stroke = 1, size = point_size, shape = kid_shape, alpha = 0.8, colour = "black") +
  # mean lines
  geom_hline(yintercept = mean(Data_P_Kids$st), size = 1, color="#6baed6", linetype = "dashed") +
  # regression line
  stat_smooth(data = Data_P_Kids, inherit.aes = F, aes(
    x = Age_frac, y = st), color = "black", size = 1.5,
    linetype = "solid", method = "lm", formula = y ~ x, se = T) +
  scale_color_brewer(palette = "Blues", guide=FALSE) +
  scale_fill_brewer(palette = "Blues", guide=FALSE) +
  guides(color = FALSE, fill = FALSE, shape = FALSE) +
  #coord_cartesian(ylim = c(0,1)) +
  scale_y_continuous(lim = c(-2,3)) +
  scale_x_continuous(breaks=seq(5,12,1), lim = c(5,12)) +
  #scale_x_log10(breaks=c(5, 6, 7, 8, 9, 10, 11, 30)) + # log scale for age
  ggtitle('Choice stickiness') +
  xlab('Age (in years)') +
  ylab('Stickiness parameter \U03C0') +
  theme_light() +
  fig3_theme 

kids


### adult plot
Data_P_Adults <- data.frame(Data_P_Adults)
adlt <- summarySE(data = Data_P, measurevar = "st", groupvars = "Group")
adlts <- adlt[which (adlt$Group==2),] 

plot.adult <- ggplot(Data_P_Adults, aes(x = Group, y = st), color = Age_Kids_Only, 
                     fill = Age_Kids_Only) + 
  geom_violin()+
  geom_jitter(data = Data_P_Adults, aes(x = Group, y = st, fill = Age_Kids_Only), shape = adult_shape, 
              size = point_size, color = "grey", fill ="#08306b", stroke = 1, position = position_jitter(0.3),  alpha = 0.6) +
  #geom_bar(data = adlts, stat = "identity", aes(x = Group, y = st),  width = 0.4, 
  #         alpha = 0.01, size = 0.8, color = "black", fill = "white") +
  geom_errorbar(data = adlts, aes(x = Group, ymin=st-ci, ymax=st+ci), position=position_dodge(.6),
                width = 0.2, size = 1, color = "black") +
  #coord_cartesian(ylim = c(0,1)) +
  geom_hline(yintercept = mean(Data_P_Kids$st), size = 1, color="#6baed6", linetype = "dashed") +
  
  scale_y_continuous(lim=c(-2,3)) +
  #ggtitle('eligibility trace') +
  scale_x_discrete(name = "Adults", labels = "") +
  theme_light() +
  fig3_theme +
  fig3_adlt_theme

plot.adult



# combine plots & align
plot_grid(kids, plot.adult, align = "h", rel_widths = c(6, 1))

# # Saving plots with fixed dimensions, quality etc.
ggsave("st_kids_adults.png", plot = last_plot(), path = plots_folder,
       scale = 1, width = 24, height = 16, units = "cm",
       dpi = 300)


### ---------------- Figure 3.3 sticky 2 over age for children with adults separate

### plot the graph
kids <- ggplot(data = Data_P_Kids, aes(color = Age_Kids_Only, fill = Age_Kids_Only, shape = Group)) +
  # individual points
  geom_point(data = Data_P_Kids, aes(x = Age_frac, y = repst, color = Age_Kids_Only),
             stroke = 1, size = point_size, shape = kid_shape, alpha = 0.8, colour = "black") +
  # mean lines
  geom_hline(yintercept = mean(Data_P_Kids$repst), size = 1, color="#6baed6", linetype = "dashed") +
  # regression line
  stat_smooth(data = Data_P_Kids, inherit.aes = F, aes(
    x = Age_frac, y = repst), color = "black", size = 1.5,
    linetype = "solid", method = "lm", formula = y ~ x, se = T) +
  scale_color_brewer(palette = "Blues", guide=FALSE) +
  scale_fill_brewer(palette = "Blues", guide=FALSE) +
  guides(color = FALSE, fill = FALSE, shape = FALSE) +
  #coord_cartesian(ylim = c(0,1)) +
  scale_y_continuous(lim = c(-2,3)) +
  scale_x_continuous(breaks=seq(5,12,1), lim = c(5,12)) +
  #scale_x_log10(breaks=c(5, 6, 7, 8, 9, 10, 11, 30)) + # log scale for age
  ggtitle('Key stickiness') +
  xlab('Age (in years)') +
  ylab('Stickiness parameter \U03C1') +
  theme_light() +
  fig3_theme 

kids


### adult plot
Data_P_Adults <- data.frame(Data_P_Adults)
adlt <- summarySE(data = Data_P, measurevar = "repst", groupvars = "Group")
adlts <- adlt[which (adlt$Group==2),] 

plot.adult <- ggplot(Data_P_Adults, aes(x = Group, y = repst), color = Age_Kids_Only, 
                     fill = Age_Kids_Only) + 
  geom_violin() +
  geom_jitter(data = Data_P_Adults, aes(x = Group, y = repst, fill = Age_Kids_Only), shape = adult_shape, 
              size = point_size, color = "grey", fill ="#08306b", stroke = 1, position = position_jitter(0.3),  alpha = 0.6) +
  geom_errorbar(data = adlts, aes(x = Group, ymin=repst-ci, ymax=repst+ci), position=position_dodge(.6),
                width = 0.2, size = 1, color = "black") +
  geom_hline(yintercept = mean(Data_P_Kids$repst), size = 1, color="#6baed6", linetype = "dashed") +
  #coord_cartesian(ylim = c(0,1)) +
  
  scale_y_continuous(lim=c(-2,3)) +
  #ggtitle('eligibility trace') +
  scale_x_discrete(name = "Adults", labels = "") +
  theme_light() +
  fig3_theme +
  fig3_adlt_theme

plot.adult



# combine plots & align
plot_grid(kids, plot.adult, align = "h", rel_widths = c(6, 1))

# # Saving plots with fixed dimensions, quality etc.
ggsave("repst_kids_adults.png", plot = last_plot(), path = plots_folder,
       scale = 1, width = 24, height = 16, units = "cm",
       dpi = 300)




#-------------------------------------------------------------------------------------------------------
##########################################################################################################
# --- parameter recovery plots
##########################################################################################################
#-------------------------------------------------------------------------------------------------------

PR_theme <-   theme(
  #legend.position = "none",
  plot.title = element_text(family="Georgia",color="black", size=12 ,hjust = 0.5,margin=margin(0,0,10,0)),
  text = element_text(family="Georgia", size=10),
  legend.title = element_text(size = 10),
  legend.text = element_text(size = 8),
  axis.title.y = element_text(color="black", size=10),
  axis.title.x = element_text(color="black", size=10, margin=margin(5,0,0,0)),
  axis.text.x = element_text(size = 8, margin=margin(5,0,0,0)),
  aspect.ratio=1/2,
  axis.text.y = element_text(size = 8, margin=margin(0,5,0,10)),
  plot.margin = margin(6, 15, 6, 15)
)

PR_theme <-   theme(
  #legend.position = "none",
  plot.title = element_text(family="Georgia",color="black", size=12 ,hjust = 0.5,margin=margin(0,0,5,0)),
  text = element_text(family="Georgia", size=10),
  legend.title = element_text(size = 10),
  legend.text = element_text(size = 8),
  axis.title.y = element_text(color="black", size=10),
  axis.title.x = element_text(color="black", size=10, margin=margin(2.5,0,0,0)),
  axis.text.x = element_text(size = 8, margin=margin(2.5,0,0,0)),
  aspect.ratio=1/2,
  axis.text.y = element_text(size = 8, margin=margin(0,2.5,0,10)),
  plot.margin = margin(3, 7.5, 3, 7.5)
)

# UPDATE: PRIORS AND UNSCALED REWARDS
# 100 trials
Recov <- read.csv('/Users/claire.smid/Dropbox/MBMF_Recoverability_May2021/parameter_recovery/output/parameter_recovery_P7_NOScaledRewards_Qvals4.5_100Trials_May2021.csv')

# 140 trials
Recov <- read.csv('/Users/claire.smid/Dropbox/MBMF_Recoverability_May2021/parameter_recovery/output/parameter_recovery_P7_NOScaled_Rewards_Qvals_4.5_140Trials_May2021.csv')

# 200 trials
Recov <- read.csv('/Users/claire.smid/Dropbox/MBMF_Recoverability_May2021/parameter_recovery/output/parameter_recovery_P7_NOScaled_Rewards_Qvals_4.5_200Trials_May2021.csv')


Pstroke = 0.5
Psize = 1.5
Palpha = 0.8
P_shape = 21

IT_corr <- ggplot(data = Recov, aes(x = P7_init_it, y = P7_res_it)) +
  geom_point(data = Recov, aes(x = P7_init_it, y = P7_res_it), shape = P_shape, stroke = Pstroke, size = Psize, color = "black", alpha = Palpha) +
  stat_smooth(data = Recov, inherit.aes = F, aes(x = P7_init_it, y = P7_res_it), color = "#c5c5c5", alpha = 0.3, size = 1, linetype = "dashed", method = "lm", formula = y ~ x, se = T) +
  stat_smooth(data = Recov, inherit.aes = F, aes(x = P7_init_it, y = P7_res_it), color = "red", alpha = 1, size = 1, linetype = "dashed", method = "lm", formula = y ~ x, se = F) +
  #coord_cartesian(ylim = c(0,1)) +
  #scale_y_continuous(lim = c(0,2)) +
  #scale_x_continuous(breaks=seq(5,11,1), lim = c(5,11.5)) +
  #ggtitle('Model-based decision making for children') +
  #ggtitle('Model-based decision-making for both low and\nhigh stakes for children') +
  xlab('simulated \U03B2') +
  ylab('fit \U03B2') +
  #scale_fill_manual(name = "Stakes", values = c("#c5c5c5","#fc8d39"),labels=c("low","high"), guide = guide_legend(reverse = TRUE) ) +
  #guides(fill = guide_legend(override.aes=list(shape=21,size = 5, alpha=1), order = 1, reverse = T)) +
  #guides(color = FALSE, fill = FALSE, shape = FALSE) +
  #coord_fixed(ratio = 1/2) +
  theme_light() +
  PR_theme 

IT_corr

LR_corr <- ggplot(data = Recov, aes(x = P7_init_lr, y = P7_res_lr)) +
  geom_point(data = Recov, aes(x = P7_init_lr, y = P7_res_lr), shape = P_shape, stroke = Pstroke, size = Psize, color = "black", alpha = Palpha) +
  stat_smooth(data = Recov, inherit.aes = F, aes(x = P7_init_lr, y = P7_res_lr), color = "#c5c5c5", alpha = 0.3, size = 1, linetype = "dashed", method = "lm", formula = y ~ x, se = T) +
  stat_smooth(data = Recov, inherit.aes = F, aes(x = P7_init_lr, y = P7_res_lr), color = "red", alpha = 1, size = 1, linetype = "dashed", method = "lm", formula = y ~ x, se = F) +
  coord_cartesian(ylim = c(0,1)) +
  #scale_x_continuous(breaks=seq(5,11,1), lim = c(5,11.5)) +
  #ggtitle('Model-based decision making for children') +
  #ggtitle('Model-based decision-making for both low and\nhigh stakes for children') +
  xlab('simulated \U03B1') +
  ylab('fit \U03B1') +
  #scale_fill_manual(name = "Stakes", values = c("#c5c5c5","#fc8d39"),labels=c("low","high"), guide = guide_legend(reverse = TRUE) ) +
  #guides(fill = guide_legend(override.aes=list(shape=21,size = 5, alpha=1), order = 1, reverse = T)) +
  #guides(color = FALSE, fill = FALSE, shape = FALSE) +
  #coord_fixed(ratio = 1/2) +
  theme_light() +
  PR_theme 

LR_corr


EG_corr <- ggplot(data = Recov, aes(x = P7_init_et, y = P7_res_et)) +
  geom_point(data = Recov, aes(x = P7_init_et, y = P7_res_et), shape = P_shape, stroke = Pstroke, size = Psize, color = "black", alpha = Palpha) +
  stat_smooth(data = Recov, inherit.aes = F, aes(x = P7_init_et, y = P7_res_et), color = "#c5c5c5", alpha = 0.3, size = 1, linetype = "dashed", method = "lm", formula = y ~ x, se = T) +
  stat_smooth(data = Recov, inherit.aes = F, aes(x = P7_init_et, y = P7_res_et), color = "red", alpha = 1, size = 1, linetype = "dashed", method = "lm", formula = y ~ x, se = F) +
  coord_cartesian(ylim = c(0,1)) +
  #scale_x_continuous(breaks=seq(5,11,1), lim = c(5,11.5)) +
  #ggtitle('Model-based decision making for children') +
  #ggtitle('Model-based decision-making for both low and\nhigh stakes for children') +
  xlab('simulated \U03BB') +
  ylab('fit \U03BB') +
  #scale_fill_manual(name = "Stakes", values = c("#c5c5c5","#fc8d39"),labels=c("low","high"), guide = guide_legend(reverse = TRUE) ) +
  #guides(fill = guide_legend(override.aes=list(shape=21,size = 5, alpha=1), order = 1, reverse = T)) +
  #guides(color = FALSE, fill = FALSE, shape = FALSE) +
  #coord_fixed(ratio = 1/2) +
  theme_light() +
  PR_theme 

EG_corr


WLO_corr <- ggplot(data = Recov, aes(x = P7_init_w_lo, y = P7_res_w_lo)) +
  geom_point(data = Recov, aes(x = P7_init_w_lo, y = P7_res_w_lo), shape = P_shape, stroke = Pstroke, size = Psize, color = "black", alpha = Palpha) +
  stat_smooth(data = Recov, inherit.aes = F, aes(x = P7_init_w_lo, y = P7_res_w_lo), color = "#c5c5c5", alpha = 0.3, size = 1, linetype = "dashed", method = "lm", formula = y ~ x, se = T) +
  stat_smooth(data = Recov, inherit.aes = F, aes(x = P7_init_w_lo, y = P7_res_w_lo), color = "red", alpha = 1, size = 1, linetype = "dashed", method = "lm", formula = y ~ x, se = F) +
  coord_cartesian(ylim = c(0,1)) +
  #scale_x_continuous(breaks=seq(5,11,1), lim = c(5,11.5)) +
  #ggtitle('Model-based decision making for children') +
  #ggtitle('Model-based decision-making for both low and\nhigh stakes for children') +
  xlab(expression(paste("simulated ", italic("w")," low stakes"))) +
  ylab(expression(paste("fit ", italic("w")," low stakes"))) +
  #scale_fill_manual(name = "Stakes", values = c("#c5c5c5","#fc8d39"),labels=c("low","high"), guide = guide_legend(reverse = TRUE) ) +
  #guides(fill = guide_legend(override.aes=list(shape=21,size = 5, alpha=1), order = 1, reverse = T)) +
  #guides(color = FALSE, fill = FALSE, shape = FALSE) +
  #coord_fixed(ratio = 1/2) +
  theme_light() +
  PR_theme 

WLO_corr

WHI_corr <- ggplot(data = Recov, aes(x = P7_init_w_hi, y = P7_res_w_hi)) +
  geom_point(data = Recov, aes(x = P7_init_w_hi, y = P7_res_w_hi), shape = P_shape, stroke = Pstroke, size = Psize, color = "black", alpha = Palpha) +
  stat_smooth(data = Recov, inherit.aes = F, aes(x = P7_init_w_hi, y = P7_res_w_hi), color = "#c5c5c5", alpha = 0.3, size = 1, linetype = "dashed", method = "lm", formula = y ~ x, se = T) +
  stat_smooth(data = Recov, inherit.aes = F, aes(x = P7_init_w_hi, y = P7_res_w_hi), color = "red", alpha = 1, size = 1, linetype = "dashed", method = "lm", formula = y ~ x, se = F) +
  coord_cartesian(ylim = c(0,1)) +
  #scale_x_continuous(breaks=seq(5,11,1), lim = c(5,11.5)) +
  #ggtitle('Model-based decision making for children') +
  #ggtitle('Model-based decision-making for both low and\nhigh stakes for children') +
  xlab(expression(paste("simulated ", italic("w")," high stakes"))) +
  ylab(expression(paste("fit ", italic("w")," high stakes"))) +
  #scale_fill_manual(name = "Stakes", values = c("#c5c5c5","#fc8d39"),labels=c("low","high"), guide = guide_legend(reverse = TRUE) ) +
  #guides(fill = guide_legend(override.aes=list(shape=21,size = 5, alpha=1), order = 1, reverse = T)) +
  #guides(color = FALSE, fill = FALSE, shape = FALSE) +
  #coord_fixed(ratio = 1/2) +
  theme_light() +
  PR_theme 

WHI_corr


ST_corr <- ggplot(data = Recov, aes(x = P7_init_st, y = P7_res_st)) +
  geom_point(data = Recov, aes(x = P7_init_st, y = P7_res_st), shape = P_shape, stroke = Pstroke, size = Psize, color = "black", alpha = Palpha) +
  stat_smooth(data = Recov, inherit.aes = F, aes(x = P7_init_st, y = P7_res_st), color = "#c5c5c5", alpha = 0.3, size = 1, linetype = "dashed", method = "lm", formula = y ~ x, se = T) +
  stat_smooth(data = Recov, inherit.aes = F, aes(x = P7_init_st, y = P7_res_st), color = "red", alpha = 1, size = 1, linetype = "dashed", method = "lm", formula = y ~ x, se = F) +
  #coord_cartesian(ylim = c(0,1)) +
  scale_y_continuous(lim = c(-2,2)) +
  #scale_x_continuous(breaks=seq(5,11,1), lim = c(5,11.5)) +
  #ggtitle('Model-based decision making for children') +
  #ggtitle('Model-based decision-making for both low and\nhigh stakes for children') +
  xlab('simulated rocket stickiness') +
  ylab('fit rocket stickiness') +
  #scale_fill_manual(name = "Stakes", values = c("#c5c5c5","#fc8d39"),labels=c("low","high"), guide = guide_legend(reverse = TRUE) ) +
  #guides(fill = guide_legend(override.aes=list(shape=21,size = 5, alpha=1), order = 1, reverse = T)) +
  #guides(color = FALSE, fill = FALSE, shape = FALSE) +
  #coord_fixed(ratio = 1/2) +
  theme_light() +
  PR_theme 

ST_corr

RESP_corr <- ggplot(data = Recov, aes(x = P7_init_repst, y = P7_res_repst)) +
  geom_point(data = Recov, aes(x = P7_init_repst, y = P7_res_repst), shape = P_shape, stroke = Pstroke, size = Psize, color = "black", alpha = Palpha) +
  stat_smooth(data = Recov, inherit.aes = F, aes(x = P7_init_repst, y = P7_res_repst), color = "#c5c5c5", alpha = 0.3, size = 1, linetype = "dashed", method = "lm", formula = y ~ x, se = T) +
  stat_smooth(data = Recov, inherit.aes = F, aes(x = P7_init_repst, y = P7_res_repst), color = "red", alpha = 1, size = 1, linetype = "dashed", method = "lm", formula = y ~ x, se = F) +
  #coord_cartesian(ylim = c(0,1)) +
  scale_y_continuous(lim = c(-2,2)) +
  #scale_x_continuous(breaks=seq(5,11,1), lim = c(5,11.5)) +
  #ggtitle('Model-based decision making for children') +
  #ggtitle('Model-based decision-making for both low and\nhigh stakes for children') +
  xlab('simulated key stickiness') +
  ylab('fit key stickiness') +
  #scale_fill_manual(name = "Stakes", values = c("#c5c5c5","#fc8d39"),labels=c("low","high"), guide = guide_legend(reverse = TRUE) ) +
  #guides(fill = guide_legend(override.aes=list(shape=21,size = 5, alpha=1), order = 1, reverse = T)) +
  #guides(color = FALSE, fill = FALSE, shape = FALSE) +
  #coord_fixed(ratio = 1/2) +
  theme_light() +
  PR_theme 

RESP_corr

##### combine graphs

title <- ggdraw() + 
  draw_label(
    "Parameter recovery results",
    fontfamily = "Helvetica",
    fontface = "plain",
    size = 18,
    hjust = 0.5
  )


PCOMB <- plot_grid(IT_corr, LR_corr, EG_corr, WLO_corr, WHI_corr, ST_corr, RESP_corr, 
                   align = "h", rel_widths = c(6, 6), ncol =2, labels = "auto")

PCOMB

# # Saving plots with fixed dimensions, quality etc.
ggsave("ParamRecov_Graphs_Priors_Xtrials.png", plot = last_plot(), path = plots_folder,
       scale = 1, width = 24, height = 20, units = "cm",
       dpi = 300)


