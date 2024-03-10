# syntax=docker/dockerfile:1

FROM mcr.microsoft.com/devcontainers/base:ubuntu

RUN apt-get update && apt-get install -y --no-install-recommends \
    openjdk-21-jre \
    git \
    g++ \
    build-essential \
    python3

RUN curl -sL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y --no-install-recommends \ 
    nodejs \
    npm \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

ADD https://developer.salesforce.com/media/salesforce-cli/sf/channels/stable/sf-linux-x64.tar.xz /tmp/

RUN mkdir -p ~/sf && \
    tar xJf /tmp/sf-linux-x64.tar.xz -C ~/sf --strip-components 1 && \
    rm -rf /tmp/sf-linux-x64.tar.xz

ENV PATH=~/sf/bin:$PATH

COPY package.json ./

RUN npm install