# syntax=docker/dockerfile:1

FROM mcr.microsoft.com/devcontainers/base:ubuntu

RUN apt-get update && apt-get install -y --no-install-recommends \
    openjdk-21-jre \
    git \
    g++ \
    build-essential \
    python=3.12 \
    nodejs=20.x \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN wget https://developer.salesforce.com/media/salesforce-cli/sf/channels/stable/sf-linux-x64.tar.xz

RUN mkdir -p ~/sf && tar xJf sf-linux-x64.tar.xz -C ~/sf --strip-components 1 && rm -rf sf-linux-x64.tar.xz
    
ENV PATH=~/sf/bin:$PATH

COPY package.json ./

RUN npm install