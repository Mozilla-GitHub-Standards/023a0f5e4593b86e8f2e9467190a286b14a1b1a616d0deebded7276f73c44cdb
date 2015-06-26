# heka_base image
FROM golang:1.4

MAINTAINER Chance Zibolski <chance.zibolski@gmail.com> (@chance)

RUN     apt-get update && \
        apt-get install -yq --no-install-recommends \
        build-essential \
        ca-certificates \
        cmake \
        debhelper \
        fakeroot \
        libgeoip-dev \
        libgeoip1 \
        golang-goprotobuf-dev \
        patch \
        ruby-dev \
        protobuf-compiler \
        python-sphinx \
        wget \
        git

ENV CTEST_OUTPUT_ON_FAILURE 1
ENV BUILD_DIR   /heka/build
ENV GOPATH      $BUILD_DIR/heka
ENV GOBIN       $GOPATH/bin
ENV PATH        $PATH:$GOBIN

EXPOSE 4352

WORKDIR /
RUN git clone git@github.com:mozilla-services/heka.git
RUN cd heka && ./build.sh
RUN cd build && make install
RUN mkdir -p /usr/share/heka && cp -r /heka/build/heka/share/heka/* /usr/share/heka
COPY heka.conf /etc/hekad.toml

RUN mkdir -p /srv/logs

VOLUME /var/log/nginx/
VOLUME /var/log/solitude/

EXPOSE 4352
ENTRYPOINT ["hekad"]