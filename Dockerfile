FROM alpine:3.4

MAINTAINER John <yinzhuan@cisco.com>

ENV GLIBC_VERSION=2.23-r3 \
    LANG=C.UTF-8

RUN apk upgrade --update && \
    apk add --update libstdc++ curl ca-certificates wget


RUN echo "install third party from bitbucket "

RUN wget "https://bitbucket.org/john_zhuang_team/jdk_on_linux/raw/e2fd6ec565e93cc24ba30311ccfadcf53854fbb1/jdk-8u91-linux-x64.tar.gz" \
    -O /jdk-8u91-linux-x64.tar.gz

RUN for pkg in glibc-${GLIBC_VERSION} glibc-bin-${GLIBC_VERSION} glibc-i18n-${GLIBC_VERSION}; do curl -sSL https://github.com/andyshinn/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/${pkg}.apk -o /tmp/${pkg}.apk; done && \
    apk add --allow-untrusted /tmp/*.apk && \
    rm -v /tmp/*.apk && \
    ( /usr/glibc-compat/bin/localedef --force --inputfile POSIX --charmap UTF-8 C.UTF-8 || true ) && \
    echo "export LANG=C.UTF-8" > /etc/profile.d/locale.sh && \
    /usr/glibc-compat/sbin/ldconfig /lib /usr/glibc-compat/lib
RUN apk del curl

ADD . /

RUN mkdir -p /opt
RUN tar xvf /jdk-8u91-linux-x64.tar.gz  -C /opt  \
    && ln -s /opt/jdk1.8.0_91/bin/java /usr/bin/java \
    && ln -s /opt/jdk1.8.0_91/bin/javac /usr/bin/javac \
    && rm /jdk-8u91-linux-x64.tar.gz \
    && rm /opt/jdk1.8.0_91/src.zip /opt/jdk1.8.0_91/javafx-src.zip

ENV JAVA_HOME /opt/jdk1.8.0_91/
RUN java -version









