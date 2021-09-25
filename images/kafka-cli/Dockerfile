FROM openjdk:18-jdk-alpine3.13
WORKDIR /
ENV PATH="/kafka-cli/bin:$PATH"
ENV SCALA_VERSION=2.13.0 \
    SCALA_HOME=/usr/share/scala \
    SBT_VERSION=1.5.5
ENV BOOTSTRAP_SERVER=""
ENV KFK_USERNAME=""
ENV KFK_PASSWORD=""
COPY generate-creds.sh .
RUN apk update and apk upgrade
RUN  apk add wget bash
RUN wget -O kafka https://dlcdn.apache.org/kafka/2.8.0/kafka_2.13-2.8.0.tgz
RUN tar -xzf kafka
RUN mkdir /kafka-cli
RUN mv kafka_2.13-2.8.0/* /kafka-cli/
RUN rm -rf kafka kafka_2.13-2.8.0
RUN \
  echo "$SCALA_VERSION $SBT_VERSION" && \
  mkdir -p /usr/lib/jvm/java-1.8-openjdk/jre && \
  touch /usr/lib/jvm/java-1.8-openjdk/jre/release && \
  apk add -U --no-cache bash curl && \
  curl -fsL http://downloads.typesafe.com/scala/$SCALA_VERSION/scala-$SCALA_VERSION.tgz | tar xfz - -C /usr/local && \
  ln -s /usr/local/scala-$SCALA_VERSION/bin/* /usr/local/bin/ && \
  scala -version && \
  scalac -version
