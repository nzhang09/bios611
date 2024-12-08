FROM --platform=linux/amd64 rocker/verse

#Install R packages
RUN R -e "install.packages(c('tidyverse','glmnet','cowplot','reshape2'))"

# Update package list, install make, and clean up
RUN apt-get update && \
    apt-get install -y man-db && \
    apt-get install -y make \
    && apt-get clean && \
    rm -rf /var/lib/apt/lists/*
    CMD ["/init"]