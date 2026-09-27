FROM debian:trixie-slim

# Liberica JDK Full: JavaFX + jmods (java.base.jmod, javafx.*.jmod), required by ProGuard.
# Releases: https://github.com/bell-sw/Liberica/releases
ARG LIBERICA_VERSION=25.0.4.1+1
ARG LIBERICA_SHA1=06b9069ceea8f3569546030b4663930193ffcfa6

ENV JAVA_HOME=/opt/java \
    PATH=/opt/java/bin:$PATH

USER root

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        lsof \
        curl \
        ca-certificates \
        openssl \
        git \
        tar \
        sqlite3 \
        fontconfig \
        libfreetype6 \
        tzdata \
        iproute2 \
        libstdc++6 \
        osslsigncode \
        nano \
        vim \
        rsync \
        socat \
        unzip \
        wget \
    && rm -rf /var/lib/apt/lists/*

RUN curl -fsSL -o /tmp/liberica.tar.gz \
        "https://github.com/bell-sw/Liberica/releases/download/${LIBERICA_VERSION}/bellsoft-jdk${LIBERICA_VERSION}-linux-amd64-full.tar.gz" \
    && echo "${LIBERICA_SHA1}  /tmp/liberica.tar.gz" | sha1sum -c - \
    && mkdir -p "${JAVA_HOME}" \
    && tar -xzf /tmp/liberica.tar.gz -C "${JAVA_HOME}" --strip-components=1 \
    && rm /tmp/liberica.tar.gz \
    && test -f "${JAVA_HOME}/jmods/java.base.jmod" \
    && test -f "${JAVA_HOME}/jmods/javafx.base.jmod" \
    && java -version

COPY entrypoint.sh /entrypoint.sh

RUN useradd -d /home/container -m container \
    && chmod +x /entrypoint.sh

USER container

ENV USER=container \
    HOME=/home/container

WORKDIR /home/container

CMD ["/bin/bash", "/entrypoint.sh"]
