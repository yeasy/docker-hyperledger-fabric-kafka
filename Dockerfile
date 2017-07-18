# Dockerfile for Hyperledger fabric kafka image. 
# This actually follows the official image.
# github.com/yeasy/docker-hyperledger-fabric-kafka

FROM yeasy/hyperledger-fabric-base:v1.0.0-beta
LABEL maintainer "Baohua Yang <yeasy.github.com>"

EXPOSE 9092
EXPOSE 9093

ENV SCALA_VERSION=2.11 \
    KAFKA_VERSION=0.9.0.1 \
    KAFKA_DOWNLOAD_SHA1=FC9ED9B663DD608486A1E56197D318C41813D326

RUN curl -fSL "http://www-us.apache.org/dist/kafka/${KAFKA_VERSION}/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz" -o kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz \
    && echo "${KAFKA_DOWNLOAD_SHA1}  kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz" | sha1sum -c - \
    && tar xfz kafka_"$SCALA_VERSION"-"$KAFKA_VERSION".tgz -C /opt \
    && mv /opt/kafka_"$SCALA_VERSION"-"$KAFKA_VERSION" /opt/kafka \
    && rm kafka_"$SCALA_VERSION"-"$KAFKA_VERSION".tgz

ADD payload/kafka-run-class.sh /opt/kafka/bin/kafka-run-class.sh

ADD payload/docker-entrypoint.sh /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/opt/kafka/bin/kafka-server-start.sh"]
