FROM python:3.9.7-slim-buster
ARG TERRAFORM_VERSION="1.0.6"
ARG CHECKOV_VERSION="2.0.405"
ARG AWSCLI_VERSION="1.20.41"

# Update and Install APT packages
RUN apt update && apt upgrade
RUN apt-get install -y curl wget unzip git 

# Install Checkov 
RUN pip3 install checkov==$CHECKOV_VERSION
RUN pip3 install awscli==$AWSCLI_VERSION
# Install Terraform
RUN curl -o terraform.zip https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip
RUN unzip terraform.zip
RUN mv terraform /usr/local/bin

RUN rm -f terraform.zip

# Verify
RUN terraform version
RUN checkov --version
CMD ["terraform"]
