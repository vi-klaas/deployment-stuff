# Start from the R Shiny server image
FROM rocker/shiny:latest

# Create a new user 'apprunner' and group 'apprunner'
RUN groupadd -g 1111 apprunner && useradd -r -u 1111 -g apprunner apprunner

# Install system dependencies (if any)
RUN apt-get update && apt-get install -y \
    libxml2-dev \
    libssl-dev \
    libcurl4-openssl-dev \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*

# Install R packages
RUN R -e "install.packages(c('shinydashboard', 'renv', 'tidyverse'), repos='https://cran.rstudio.com/')"


# Expose the port Shiny is running on
EXPOSE 3838

# Switch to the 'apprunner' user
USER apprunner

# Run the Shiny server
CMD ["/usr/bin/shiny-server"]
