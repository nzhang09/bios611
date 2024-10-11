FROM rocker/verse

# Update package list, install man-db, and clean up
RUN apt-get update && \
    apt-get install -y man-db && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Set the default command
CMD ["/init"]
