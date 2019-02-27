FROM node:10-alpine

RUN apk --update add \
  # package dependencies \
    autoconf \
    automake \
    file \
    g++ \
    gcc \
    make \
    nasm \
    zlib-dev \
  # clean \
    && rm -rf /var/cache/apk/*
