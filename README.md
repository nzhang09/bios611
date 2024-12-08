# BIOS 611 Project -- Predictors of COVID-19 Mortality Rate in the U.S.

Ning Zhang

ning.zhang@unc.edu

GitHub: https://github.com/nzhang09/bios611


### Dockerfile:
Note: `linux/amd64` in the dockerfile is needed for Mac M3 users. Windows users probably don't need this command.

The Dockerfile contains the instructions to build a Docker image for this project, including the base image (i.e., rocker/verse), and instructions for installing additional R packages. After navigating to your working directory, you can build the docker container by running the line below.
```
docker build . -t nz611
```

To start the docker container, please replace "/your/working/directory" with your local working directory, and run the line below.
```
docker run --rm -ti --platform linux/amd64 -e PASSWORD=yourpassword -p 8787:8787 -v "/your/working/directory":/home/rstudio/ rocker/verse
```

Then please open web browser http://localhost:8787/ and log in with username "rstudio" and password "yourpassword". Then you can see a list of project files in the right bottom panel "Files" tab.

### Makefile: 
The Makefile creates all the datasets and figures, and builds the report from R Markdown. It simplifies the workflow by defining targets and dependencies. 

### report.Rmd:
The report.Rmd is an R Markdown file that generates the html report. Please use the Terminal in the docker container and run
```
make report.html
```











