FROM python:3.9.7-alpine3.14
RUN apk update && apk upgrade
RUN apk update && apk add --no-cache docker-cli gcc musl-dev
RUN pip3 install localstack flask