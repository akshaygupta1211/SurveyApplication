# syntax=docker/dockerfile:1

FROM mcr.microsoft.com/devcontainers/base:ubuntu

RUN apt-get update && \
    apt-get install -y openjdk-21-jre git sudo

RUN curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash - && \
    apt-get install -y nodejs

RUN wget https://developer.salesforce.com/media/salesforce-cli/sf/channels/stable/sf-linux-x64.tar.xz && \
    mkdir -p ~/sf && \ 
    tar xJf sf-linux-x64.tar.xz -C ~/sf --strip-components 1 && \
    sudo echo PATH=~/sf/bin:$PATH >> ~/.bash_profile


COPY package.json ./

RUN npm install