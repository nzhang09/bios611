#Data visualization
library(tidyverse)
library(cowplot)
library(ggplot2)
library(reshape2)

#Import dataset----
covid_dat_all_modeling<-read_csv("derv_data/covid_data_all_modeling.csv")

#Correlation matrix----
cor_mtx<-cor(covid_dat_all_modeling %>%
               dplyr::select(deaths_per_100k,
                 avg_age, white, black, asian, hispaniclatino,
                 marriedhh, medhhincomeE, thhE, pubassishh,
                 giniE, popdensity, crudemortality,
                 poverty, noinsurance, highschool))
cor_dat<-melt(cor_mtx)
cor_plot<-ggplot(cor_dat, aes(x=Var1, y=Var2, fill=value)) +
  geom_tile(color="white") + 
  scale_fill_gradient2(low="#13294B", high="#EF426F", mid="white", 
                       midpoint=0, limit = c(-1, 1), space="Lab", 
                       name="Correlation") +
  theme_minimal()+
  theme(axis.text.x=element_text(angle=45, vjust=1, hjust=1)) +
  labs(x=NULL, y=NULL, title="Figure 2. Correlation matrix")
ggsave("figures/correlation_matrix.png", plot=cor_plot, height=7, width=8)

#Observed death rate map----
obs_map<-usmap::plot_usmap(regions="counties", data=covid_dat_all_modeling, values="deaths_per_100k", color=NA)+
  ggtitle("Figure 1. Overall COVID-19 death rates between Jan 2020 and Mar 2023")+
  scale_fill_distiller(name="observed death rate/100k", palette="OrRd", breaks=c(500, 1000), limits=c(0, 1400), direction=1)+
  theme(legend.position="bottom", 
        legend.justification="center", 
        legend.title=element_text(size=13),
        legend.text=element_text(size=11), 
        plot.title=element_text(size=14))
ggsave("figures/observed_death.png", plot=obs_map, height=6, width=8)

#Linear regression prediction----
lm_pred_plot<-covid_dat_all_modeling %>%
  ggplot(aes(x=pred_lm, y=deaths_per_100k))+ 
  ggtitle("Figure 3A. Linear regression prediction")+
  geom_point(alpha=.2, colour="#00A5AD")+
  labs(x="Predicted death rate", y="Observed death rate")+
  theme_bw()+
  theme(axis.text=element_text(size=12), axis.title=element_text(size=13),
        plot.title=element_text(size=16), aspect.ratio=1)+
  theme(plot.margin = unit(c(1,1,1,1),"cm"))
#Linear regression residual----
lm_res_plot<-ggplot(covid_dat_all_modeling, aes(x=res_lm)) +
  geom_histogram(fill="#00A5AD", color="black", alpha=0.3) +
  labs(title = "Figure 3B. Linear regression residual",
       x="Residual",
       y="Frequency") +
  theme_bw()+
  theme(axis.text=element_text(size=12), axis.title=element_text(size=13),
        plot.title=element_text(size=16), aspect.ratio=1)+
  theme(plot.margin = unit(c(1,1,1,1),"cm"))

lm_plot<-cowplot::plot_grid(lm_pred_plot, lm_res_plot, ncol=2)
ggsave("figures/linear_reg.png", plot=lm_plot, height=6, width=12)

#LASSO prediction----
lasso_pred_plot<-covid_dat_all_modeling %>%
  ggplot(aes(x=pred_lasso, y=deaths_per_100k))+ 
  ggtitle("Figure 4A. LASSO prediction")+
  geom_point(alpha=.2, colour="#007FAE")+
  labs(x="Predicted death rate", y="Observed death rate")+
  theme_bw()+
  theme(axis.text=element_text(size=12), axis.title=element_text(size=13),
        plot.title=element_text(size=16), aspect.ratio=1)+
  theme(plot.margin = unit(c(1,1,1,1),"cm"))
#LASSO residual----
lasso_res_plot<-ggplot(covid_dat_all_modeling, aes(x=res_lasso)) +
  geom_histogram(fill="#007FAE", color="black", alpha=0.3) +
  labs(title = "Figure 4B. LASSO residual",
       x="Residual",
       y="Frequency") +
  theme_bw()+
  theme(axis.text=element_text(size=12), axis.title=element_text(size=13),
        plot.title=element_text(size=16), aspect.ratio=1)+
  theme(plot.margin = unit(c(1,1,1,1),"cm"))

lasso_plot<-cowplot::plot_grid(lasso_pred_plot, lasso_res_plot, ncol=2)
ggsave("figures/lasso.png", plot=lasso_plot, height=6, width=12)

#Elastic net prediction----
net_pred_plot<-covid_dat_all_modeling %>%
  ggplot(aes(x=pred_net, y=deaths_per_100k))+ 
  ggtitle("Figure 5A. Elastic net prediction")+
  geom_point(alpha=.2, colour="#C4D600")+
  labs(x="Predicted death rate", y="Observed death rate")+
  theme_bw()+
  theme(axis.text=element_text(size=12), axis.title=element_text(size=13),
        plot.title=element_text(size=16), aspect.ratio=1)+
  theme(plot.margin = unit(c(1,1,1,1),"cm"))
#Elastic net residual----
net_res_plot<-ggplot(covid_dat_all_modeling, aes(x=res_net)) +
  geom_histogram(fill="#C4D600", color="black", alpha=0.3) +
  labs(title = "Figure 5B. Elastic net residual",
       x="Residual",
       y="Frequency") +
  theme_bw()+
  theme(axis.text=element_text(size=12), axis.title=element_text(size=13),
        plot.title=element_text(size=16), aspect.ratio=1)+
  theme(plot.margin = unit(c(1,1,1,1),"cm"))

net_plot<-cowplot::plot_grid(net_pred_plot, net_res_plot, ncol=2)
ggsave("figures/net.png", plot=net_plot, height=6, width=12)
