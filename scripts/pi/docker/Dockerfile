FROM node:26-slim

# to avoid debconf warnings
ENV DEBIAN_FRONTEND=noninteractive 

RUN apt-get update \
  && apt-get install -y --no-install-recommends bash ca-certificates git ripgrep curl \
  && rm -rf /var/lib/apt/lists/*
RUN npm install -g --ignore-scripts @earendil-works/pi-coding-agent

WORKDIR /workspace
ENTRYPOINT ["pi"]