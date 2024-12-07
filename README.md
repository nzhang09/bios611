# BIOS 611 Project -- Predictors of COVID-19 Mortality Rate in the U.S.

Ning Zhang

ning.zhang@unc.edu

GitHub: https://github.com/nzhang09/bios611


### Dockerfile:
The Dockerfile contains the instructions to build a Docker image for this project, including the base image used (i.e., rocker/verse), and instructions for installing additional R packages. After navigating to your working directory, please replace "/your/working/directory" with your local working directory, and build the docker container by running the following commands.
```
docker build . -t nz611
docker run --rm -ti --platform linux/amd64 -e PASSWORD=yourpassword -p 8787:8787 -v "/your/working/directory":/home/rstudio/ rocker/verse
```

Open web browser http://localhost:8787/, please log in with username "rstudio" and password "yourpassword". Then you should be able to see a list of project files in the right bottom panel "Files" tab.

### Makefile: 
The Makefile creates the datasets used in the analysis and builds the report from R Markdown html. It simplifies the workflow by defining targets and dependencies. 

### report.Rmd:
The report.Rmd is an R Markdown file that generates the html report. Please use the Terminal in the docker container and run
```
make report.html
```











