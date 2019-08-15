FROM alpine:3.4

MAINTAINER John <zhuangyinping@gmail.com>

ENV GLIBC_VERSION=2.23-r3 \
    LANG=C.UTF-8 \
    JDK_VERSION=jdk1.8.0_211 \
    JDK_ZIP=jdk-8u211-linux-x64.tar.gz

RUN apk upgrade --update && \    
    apk add --update tzdata libstdc++ curl ca-certificates wget

ENV TZ=Asia/Shanghai

RUN echo "install third party from bitbucket "

#RUN wget "https://bitbucket.org/john_zhuang_team/jdk_on_linux/raw/e2fd6ec565e93cc24ba30311ccfadcf53854fbb1/$JDK_ZIP" \
#    -O /$JDK_ZIP

RUN wget "https://bitbucket.org/john_zhuang_team/jdk_on_linux/raw/c302fc99fac77c85b86543d5d58a9884ba29bdf9/$JDK_ZIP" \
    -O /$JDK_ZIP

RUN for pkg in glibc-${GLIBC_VERSION} glibc-bin-${GLIBC_VERSION} glibc-i18n-${GLIBC_VERSION}; do curl -sSL https://github.com/andyshinn/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/${pkg}.apk -o /tmp/${pkg}.apk; done && \
    apk add --allow-untrusted /tmp/*.apk && \
    rm -v /tmp/*.apk && \
    ( /usr/glibc-compat/bin/localedef --force --inputfile POSIX --charmap UTF-8 C.UTF-8 || true ) && \
    echo "export LANG=C.UTF-8" > /etc/profile.d/locale.sh && \
    /usr/glibc-compat/sbin/ldconfig /lib /usr/glibc-compat/lib
RUN apk del curl

ADD . /

RUN mkdir -p /opt
RUN tar xvf /$JDK_ZIP  -C /opt  \
    && ln -s /opt/$JDK_VERSION/bin/java /usr/bin/java \
    && ln -s /opt/$JDK_VERSION/bin/javac /usr/bin/javac \
    && rm /$JDK_ZIP \
    && rm /opt/$JDK_VERSION/src.zip /opt/$JDK_VERSION/javafx-src.zip

ENV JAVA_HOME /opt/$JDK_VERSION/
RUN java -version









