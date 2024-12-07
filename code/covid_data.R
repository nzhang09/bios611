library(tidyverse)
# setwd("/Users/ningzhang/Desktop/UNC/course/2024fall/bios611/project")

#Data sources----
##Age distribution----
age_dat<-read_csv("orgdata/usa_population_age_county.csv")%>%
  mutate(age_prop=age_prop*100)%>%
  dplyr::select(fips, age_groups, age_prop)%>%
  pivot_wider(names_from=age_groups, values_from = age_prop)
age_groups<-colnames(age_dat)[-1]
mid_age<-sapply(age_groups, function(x) {
  bounds<-as.numeric(unlist(strsplit(x, "_")))
  mean(bounds)
})
#calculate weighted avg of age
avg_age<-age_dat %>%
  rowwise() %>%
  mutate(avg_age=sum(c_across(-fips)*mid_age)/sum(c_across(-fips))) %>%
  select(fips, avg_age)
##County level demographics----
cnty_cov_dat<-read_csv("orgdata/county_dat.csv")
##COVID death----
covid_dat<-arrow::read_parquet("orgdata/nyt_reported_covid19_june23.parquet")%>%
  filter(target=="deaths_cum", level=="county")%>%
  mutate(deaths_per_100k=value/population*100000)%>%
  group_by(fips, county, state, population, abbreviation)%>%
  summarize(deaths_per_100k=max(deaths_per_100k))%>%
  ungroup()%>%
  filter(deaths_per_100k>0)

#Merge datasets----
covid_dat_all<-covid_dat %>% 
  inner_join(cnty_cov_dat) %>%
  inner_join(avg_age)
covid_dat_all<-covid_dat_all[complete.cases(covid_dat_all),]

#Export COVID-19 dataset----
write.csv(covid_dat_all, "derv_data/covid_data_all.csv", row.names=F)



