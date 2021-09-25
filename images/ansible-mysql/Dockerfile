FROM python:3.9.7-slim-buster
ARG ANSIBLE_VERSION=4

RUN apt update && apt upgrade
RUN apt-get install -y jq
RUN pip install awscli ansible PyMySQL boto3