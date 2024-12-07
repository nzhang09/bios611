FROM --platform=linux/amd64 rocker/verse

#Make sure make is installed
RUN apt-get update && apt-get install -y make

#Install R packages
RUN R -e "install.packages(c('tidyverse','glmnet','cowplot','reshape2'))"

# Update package list and clean up
RUN apt-get update && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
