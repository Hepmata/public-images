FROM python:3.9.7-slim-buster
WORKDIR /
COPY msk.sh .
ENV AWS_DEFAULT_REGION=ap-southeast-1
RUN apt update && apt upgrade -y
RUN apt-get install -y kafkacat jq
RUN pip3 install awscli
RUN chmod +x msk.sh
ENTRYPOINT ["bash", "msk.sh"]
