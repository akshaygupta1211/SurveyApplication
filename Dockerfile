# syntax=docker/dockerfile:1

FROM mcr.microsoft.com/devcontainers/base:ubuntu

#Install dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    openjdk-21-jre \
    git \
    g++ \
    build-essential \
    python3

#Install nodejs v20.x
RUN curl -sL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y \ 
    nodejs \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

#Install sf cli
RUN mkdir -p ~/sf && curl https://developer.salesforce.com/media/salesforce-cli/sf/channels/stable/sf-linux-x64.tar.xz -o ~/sf-linux-x64.tar.xz && \
    tar xJf ~/sf-linux-x64.tar.xz -C ~/sf --strip-components 1 && \
    rm -rf ~/sf-linux-x64.tar.xz

ENV PATH=~/sf/bin:$PATH

COPY package.json ./

RUN npm install