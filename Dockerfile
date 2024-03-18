# syntax=docker/dockerfile:1

FROM salesforce/cli:latest-full

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

COPY package.json ./

RUN npm install