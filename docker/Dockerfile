FROM --platform=$BUILDPLATFORM curlimages/curl:7.81.0 AS jar
ARG BUILDPLATFORM
ARG VERSION
WORKDIR /tmp
RUN curl -f -k -O https://colossus.kruemel.home/nexus/repository/towers/ch/guengel/towers/${VERSION}/towers-${VERSION}-jar-with-dependencies.jar

FROM --platform=$BUILDPLATFORM ghcr.io/graalvm/graalvm-ce:21.3 AS executable
ARG BUILDPLATFORM
ARG VERSION
WORKDIR /tmp
RUN gu install native-image
COPY --from=jar /tmp/towers-${VERSION}-jar-with-dependencies.jar towers.jar
RUN native-image --verbose -jar towers.jar

FROM --platform=$BUILDPLATFORM debian:11.2-slim AS runnable
ARG BUILDPLATFORM
ARG USERID=10000
RUN apt install libstdc++6 &&\
    useradd -U -m -u $USERID towers &&\
    rm -rf /var/lib/apt/*

COPY --from=executable /tmp/towers /home/towers

WORKDIR /home/towers
USER $USERID
ENTRYPOINT ["/home/towers/towers"]

