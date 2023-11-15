FROM rocker/shiny-verse:4.3.2

# Create a new user 'apprunner' and group 'apprunner'
RUN groupadd -g 111 apprunner && useradd -r -u 111 -g apprunner apprunner

# Install system dependencies (if any)
RUN apt-get update && apt-get install -y \
    libxml2-dev \
    libssl-dev \
    libcurl4-openssl-dev \
    libpq-dev \
#    lynx \
    && rm -rf /var/lib/apt/lists/*

# Install R packages
RUN R -e "install.packages(c('renv','shinydashboard', 'httr', 'REDCapR', 'thematic', 'bslib', 'readxl', 'writexl'), repos='https://cran.rstudio.com/')"

# Change ownership and permissions of necessary directories
RUN mkdir -p /var/lib/shiny-server/bookmarks && \
    chown -R apprunner:apprunner /var/lib/shiny-server && \
    chown -R apprunner:apprunner /opt/shiny-server && \
    chmod -R 550 /opt/shiny-server/ && \
    chown -R apprunner:apprunner /etc/shiny-server && \
    chmod -R 550 /etc/shiny-server

# Expose the port Shiny is running on
EXPOSE 3838

# Switch to the 'apprunner' user
USER apprunner

# Run the Shiny server
CMD ["/usr/bin/shiny-server"]
