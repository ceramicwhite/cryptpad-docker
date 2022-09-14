# Multistage build to reduce image size and increase security
FROM node:16-buster-slim AS build

# Install requirements to clone repository and install deps
RUN apt-get update \
    && apt-get upgrade -y \
    && DEBIAN_FRONTEND=noninteractive apt-get install -yq git wget \
    && npm install -g bower

# Create folder for cryptpad
RUN mkdir /cryptpad && wget https://github.com/xwiki-labs/cryptpad/archive/refs/tags/5.0.0.tar.gz -O - | tar -xz -C cryptpad --strip-components 1
WORKDIR /cryptpad

# Install dependencies
RUN npm install --omit=dev \
    && npm install -g bower \
    && bower install \
    && bower update --production \
    && bower prune \
    && bower cache clean \
    && npm cache clean --force

# Create actual cryptpad image
FROM node:16-buster-slim

RUN apt-get update && apt-get install nano -y

USER 1000

# Copy cryptpad with installed modules
COPY --from=build --chown=1000 /cryptpad /cryptpad

# Copy docker-entrypoint.sh script
COPY docker-entrypoint.sh /docker-entrypoint.sh

# Set workdir to cryptpad
WORKDIR /cryptpad

# Create directories
RUN mkdir blob block customize data datastore && chown 1000:1000 blob block customize data datastore

# Volumes for data persistence
VOLUME /cryptpad/blob \
    /cryptpad/block \
    /cryptpad/customize \
    /cryptpad/data \
    /cryptpad/datastore

# Ports
EXPOSE 3000 3001

ENTRYPOINT ["/bin/sh", "/docker-entrypoint.sh"]

# Run cryptpad on startup
CMD ["npm", "start"]
