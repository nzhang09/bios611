.PHONY: clean
.PHONY: init

init:
	mkdir -p derv_data
	mkdir -p figures
	mkdir -p logs

clean:
	rm -rf derv_data
	rm -rf figures
	mkdir -p derv_data
	mkdir -p figures
	mkdir -p logs

#Create a complete dataset by combining COVID-19 mortality data, age distribution, and county-level covariates.
derv_data/covid_data_all.csv: orgdata/usa_population_age_county.csv orgdata/county_dat.csv orgdata/nyt_reported_covid19_june23.parquet covid_data.R
	Rscript covid_data.R

#Modeling R script, which adds model predictions and residuals
derv_data/covid_data_all_modeling.csv: derv_data/covid_data_all.csv modeling.R
	Rscript modeling.R

#Data visualization, which creates all figures
figures/correlation_matrix.png: derv_data/covid_data_all_modeling.csv visualization.R
	Rscript visualization.R
figures/observed_death.png: derv_data/covid_data_all_modeling.csv visualization.R
	Rscript visualization.R
figures/linear_reg.png: derv_data/covid_data_all_modeling.csv visualization.R
	Rscript visualization.R
figures/lasso.png: derv_data/covid_data_all_modeling.csv visualization.R
	Rscript visualization.R
figures/net.png: derv_data/covid_data_all_modeling.csv visualization.R
	Rscript visualization.R

#Summary report
report.html: report.Rmd figures/correlation_matrix.png figures/observed_death.png figures/linear_reg.png figures/lasso.png figures/net.png
	Rscript -e "rmarkdown::render('report.Rmd')"