#Descriptive Statistics

#Import dataset----
covid_dat_all_modeling<-read_csv("derv_data/covid_data_all_modeling.csv")

#Observed death
summary(covid_dat_all_modeling$deaths_per_100k)

#MSE----
##Linear regression----
mean((covid_dat_all_modeling$res_lm)^2)
##LASSO----
mean((covid_dat_all_modeling$res_lasso)^2)
##Elastic net----
mean((covid_dat_all_modeling$res_net)^2)
