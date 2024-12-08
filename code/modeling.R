#Modeling
library(tidyverse)

#Import dataset----
covid_dat_all<-read_csv("derv_data/covid_data_all.csv")
colnames(covid_dat_all)

#Data preprocessing----
covid_dat_all<-covid_dat_all %>%
  mutate(white=white*100,
         black=black*100,
         asian=asian*100,
         hispaniclatino=hispaniclatino*100,
         marriedhh=marriedhh*100,
         medhhincomeE=medhhincomeE/1000,
         giniE=giniE*100,
         popdensity=popdensity,
         crudemortality=crudemortality,
         poverty=poverty*100,
         noinsurance=noinsurance*100,
         highschool=highschool*100)

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

#Export modeling coefficients----
coef_lm<-summary(fit_lm)$coefficients
stars<-ifelse(coef_lm[, 4]<0.001, "***",
                ifelse(coef_lm[, 4]<0.01, "**",
                       ifelse(coef_lm[, 4]<0.05, "*",
                              ifelse(coef_lm[, 4]<0.1, ".", ""))))
coef_lm_combined<-paste0(round(coef_lm[, 1], 2), " ", stars)

coef_model<-cbind(round(coef(fit_lasso), 2), round(coef(fit_net), 2))
coef_df<-data.frame(
  covariate=dimnames(coef_model)[[1]],
  coef_lm_combined,
  as.data.frame(as.matrix(coef_model)),
  check.names=F)
colnames(coef_df)<-c("Demographics", "Linear", "LASSO", "Elastic Net")
coef_df[,1]<-c("Intercept", "Age", "% White", "% Black", "% Asian", "% Hispanic/Latino", "% Married household",
                     "Median household income (k)", "Total # household", "GINI index", "Population density",
                     "Pre-COVID death rate/100k", "% below poverty", "% no insurance", "% high school edu")
coef_df<-coef_df %>% slice(-1)
coef_df[coef_df==0]<-"-"
write.csv(coef_df, "derv_data/modeling_coef.csv", row.names=F)

#Export modeling dataset----
covid_dat_all_modeling<-cbind(covid_dat_all, pred_lm, res_lm, pred_lasso, res_lasso, pred_net, res_net) 
write.csv(covid_dat_all_modeling, "derv_data/covid_data_all_modeling.csv", row.names=F)
