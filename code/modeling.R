#Modeling
library(tidyverse)

#Import dataset----
covid_dat_all<-read_csv("derv_data/covid_data_all.csv")
colnames(covid_dat_all)

#Correlation matrix----
cor(covid_dat_all %>%
      dplyr::select(
        avg_age, white, black, asian, hispaniclatino,
        marriedhh, medhhincomeE, thhE, pubassishh,
        giniE, popdensity, crudemortality,
        poverty, noinsurance, highschool))

#Linear regression----
fit_lm<-lm(deaths_per_100k~avg_age+white+black+asian+hispaniclatino+
           marriedhh+medhhincomeE+thhE+giniE+popdensity+crudemortality+
             poverty+noinsurance+highschool, data=covid_dat_all)
summary(fit_lm)
pred_lm<-predict(fit_lm, data=covid_dat_all)
res_lm<-covid_dat_all$deaths_per_100k-pred_lm

#LASSO regression----
df<-covid_dat_all %>%
  dplyr::select(
    avg_age, white, black, asian, hispaniclatino,
    marriedhh, medhhincomeE, thhE,
    giniE, popdensity, crudemortality,
    poverty, noinsurance, highschool)

fit_lasso<-glmnet::cv.glmnet(y=covid_dat_all$deaths_per_100k,
                         x=glmnet::makeX(df), alpha=1)
coef(fit_lasso)
pred_lasso<-as.vector(predict(fit_lasso, newx=glmnet::makeX(df), s="lambda.min"))
res_lasso<-covid_dat_all$deaths_per_100k-pred_lasso

#Elastic net----
fit_net<-glmnet::cv.glmnet(y=covid_dat_all$deaths_per_100k,
                             x=glmnet::makeX(df), alpha=0.5)
coef(fit_net)
pred_net<-as.vector(predict(fit_net, newx=glmnet::makeX(df), s="lambda.min"))
res_net<-covid_dat_all$deaths_per_100k-pred_net

#Export modeling dataset----
covid_dat_all_modeling<-cbind(covid_dat_all, pred_lm, res_lm, pred_lasso, res_lasso, pred_net, res_net) 

write.csv(covid_dat_all_modeling, "derv_data/covid_data_all_modeling.csv", row.names=F)
