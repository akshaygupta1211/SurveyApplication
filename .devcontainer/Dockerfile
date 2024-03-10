# syntax=docker/dockerfile:1

FROM mcr.microsoft.com/devcontainers/base:ubuntu

RUN apt-get update && \
    apt-get install -y openjdk-21-jre nodejs npm git

COPY . .

RUN npm install