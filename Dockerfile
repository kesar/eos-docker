FROM ubuntu:18.04

ARG release=latest
ARG eosbranch=v2.0.7
ARG eoscdtbranch=v1.7.0
ENV OPENSSL_ROOT_DIR /usr/include/openssl
ENV BOOST_ROOT=/root/eosio/2.0/src/boost_1_71_0

RUN apt-get update -y \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y cmake build-essential sudo git libcurl4-openssl-dev libusb-1.0-0-dev openssl ca-certificates curl wget \
    && git clone --recursive https://github.com/eosio/eos --branch $eosbranch --single-branch \
    && cd eos && echo 1 | ./scripts/eosio_build.sh -y && ./scripts/eosio_install.sh \
    && cd .. && rm -rf eos/* \
    && git clone --recursive https://github.com/eosio/eosio.cdt --branch $eoscdtbranch --single-branch \
    && cd eosio.cdt && mkdir build && cd build && cmake .. && make -j8 && make install \
    && cd .. && rm -rf eosio.cdt/*

ENTRYPOINT ["/bin/bash"]
