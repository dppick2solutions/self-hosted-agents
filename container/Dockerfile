FROM ubuntu:22.04

ENV TARGETARCH="linux-x64" \
    TERRAFORM_VERSION="1.10.5" \
    AGENT_HOME="/home/agent"

# Set non-interactive mode to avoid prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive 

RUN apt update && \
    apt upgrade -y && \
    apt install -y --no-install-recommends \
      curl \
      git \
      jq \
      libicu70 \
      unzip && \
    rm -rf /var/lib/apt/lists/*

# Install Azure CLI
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash

# Install Node.js and npm
RUN curl -fsSL https://deb.nodesource.com/setup_21.x | bash - && \
    apt install -y --no-install-recommends nodejs && \
    rm -rf /var/lib/apt/lists/*

# Install terraform-visual
RUN npm install -g @terraform-visual/cli

# Install Terraform
RUN curl -fsSL "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip" -o terraform.zip && \
    unzip terraform.zip && \
    mv terraform /usr/local/bin/ && \
    rm -f terraform.zip

WORKDIR /azp/

COPY ./container/start.sh ./
RUN chmod +x ./start.sh

# Create agent user and set up home directory
RUN useradd -m -d "$AGENT_HOME" agent && \
    chown -R agent:agent /azp "$AGENT_HOME"

USER agent

# Another option is to run the agent as root.
# ENV AGENT_ALLOW_RUNASROOT="true"

ENTRYPOINT [ "./start.sh" ]
