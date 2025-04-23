# Use official Jenkins image as base
FROM jenkins/jenkins:lts-jdk17

# Switch to root to install packages
USER root

# Install prerequisites
RUN apt-get update && \
    apt-get install -y \
    curl \
    unzip \
    software-properties-common \
    gnupg2

# Install Podman
RUN echo "deb https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/Debian_11/ /" > /etc/apt/sources.list.d/devel:kubic:libcontainers:stable.list && \
    curl -L "https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/Debian_11/Release.key" | apt-key add - && \
    apt-get update && \
    apt-get install -y podman

# Install AWS CLI v2
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install && \
    rm -rf awscliv2.zip aws

# Configure Podman to work with Jenkins user
RUN mkdir -p /home/jenkins/.local/share/containers && \
    chown -R jenkins:jenkins /home/jenkins/.local && \
    echo "jenkins:100000:65536" >> /etc/subuid && \
    echo "jenkins:100000:65536" >> /etc/subgid

# Switch back to jenkins user
USER jenkins

# Verify installations
RUN podman --version && \
    aws --version
