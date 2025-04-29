# Base image
FROM ubuntu:latest

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive

# Update and install dependencies
RUN apt-get update && apt-get install -y \
    curl \
    unzip \
    jq \
    gnupg \
    software-properties-common \
    python3 \
    python3-pip \
    pipx \
    ansible \
    make \
    && rm -rf /var/lib/apt/lists/*

# Install AWS CLI
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install && \
    rm -rf awscliv2.zip aws

# Install Azure CLI
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash

# Install Terraform
RUN curl -fsSL https://apt.releases.hashicorp.com/gpg | gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/hashicorp.list && \
    apt-get update && apt-get install -y terraform

# Install Terragrunt
RUN curl -fsSL -o /usr/local/bin/terragrunt https://github.com/gruntwork-io/terragrunt/releases/latest/download/terragrunt_linux_amd64 && \
    chmod +x /usr/local/bin/terragrunt

# Install TFSwitch
RUN curl -L https://raw.githubusercontent.com/warrensbox/terraform-switcher/release/install.sh | bash

# Install TFLint
RUN curl -s https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh | bash

# Install checkov
# system has PEP 668 (Externally Managed Environment) enabled, which prevents direct pip install in the system Python environment.
# Use pipx (For System-wide Install)
# pipx installs tools in isolated environments (usually under /root/.local/share/pipx/venvs/<tool>), not just ~/.local/bin.
# Instead of moving binaries around and potentially breaking dependencies, it's better to symlink the actual binary into /usr/local/bin.

RUN pipx install checkov && ln -s /root/.local/share/pipx/venvs/checkov/bin/checkov /usr/local/bin/checkov

# Install Python Boto3 package
# Couldn't get this right!
# RUN pipx install boto3 --include-deps && ln -s /root/.local/share/pipx/venvs/boto3 /usr/local/bin/boto3


# Set working directory
WORKDIR /app

# Default command
CMD ["/bin/bash"]
