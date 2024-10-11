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

#This creates a complete dataset by combining COVID-19 mortality data, age distribution, and county-level covariates.
#Incomplete cases are removed.
derv_data/covid_data_all.csv: orgdata/usa_population_age_county.csv orgdata/county_dat.csv orgdata/nyt_reported_covid19_june23.parquet covid_data.R
	Rscript covid_data.R

report.pdf: report.Rmd
	Rscript -e "rmarkdown::render('report.Rmd')"