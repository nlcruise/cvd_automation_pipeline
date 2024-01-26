# Start from the official Airflow image
FROM apache/airflow:2.8.1

# User root is required to install packages
USER root

# Install prerequisites for uncover and nuclei, whois, and then install them
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    wget \
    unzip \
    # Install python for pip
    python3-pip \
    # Install whois
    whois \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    # Download and install nuclei
    && wget https://github.com/projectdiscovery/nuclei/releases/download/v3.1.7/nuclei_3.1.7_linux_amd64.zip \
    && unzip -o nuclei_3.1.7_linux_amd64.zip \
    && mv nuclei /usr/local/bin/ \
    && rm nuclei_3.1.7_linux_amd64.zip \
    # Download and install uncover
    && wget https://github.com/projectdiscovery/uncover/releases/download/v1.0.7/uncover_1.0.7_linux_amd64.zip \
    && unzip -o uncover_1.0.7_linux_amd64.zip \
    && mv uncover /usr/local/bin/ \
    && rm uncover_1.0.7_linux_amd64.zip

# Create the directory for uncover if it doesn't exist
# RUN mkdir -p /usr/local/bin/uncover

# Copy the provider-config.yaml file to the uncover directory
# COPY provider-config.yaml /usr/local/bin/uncover/

# Switch back to the airflow user
USER airflow

# Install shodan using pip as the airflow user
RUN pip install shodan