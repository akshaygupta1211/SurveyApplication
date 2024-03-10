# syntax=docker/dockerfile:1

FROM mcr.microsoft.com/devcontainers/base:ubuntu

RUN apt-get update && \
    apt-get install -y openjdk-21-jre git

RUN curl -fsSL https://deb.nodesource.com/setup_20.11.1 | sudo -E bash - && \
    apt-get install -y nodejs

COPY package.json ./

RUN npm install