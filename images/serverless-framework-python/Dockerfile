FROM debian:stable-slim as builder
WORKDIR /
ARG NODEJS_VERSION="v14.17.6"
RUN apt update && apt upgrade
RUN apt-get install -y wget xz-utils
RUN wget -O nodejs.tar.xz  https://nodejs.org/dist/${NODEJS_VERSION}/node-${NODEJS_VERSION}-linux-x64.tar.xz
RUN tar xf nodejs.tar.xz
RUN mv node-${NODEJS_VERSION}-linux-x64 node


FROM python:3.8-slim-buster
ENV PATH="/opt/node/bin:$PATH"
WORKDIR /
COPY --from=builder node /opt/node
RUN apt update && apt upgrade
RUN apt install -y git curl jq
RUN pip3 install awscli
RUN npm i -g serverless
CMD ["sls"]


