# 6-stretch is the ONLY node 6 release supported by arm32v7, arm64v8 and x86-64 docker hub labels
FROM node:6-stretch

# You want USE_SSL=true if not putting cryptpad behind a proxy
ENV USE_SSL=false
ENV STORAGE=\'./storage/file\'
ENV LOG_TO_STDOUT=true

# Required packages
#   jq is a build only dependency, removed in cleanup stage
RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y --no-install-recommends \
         git jq python

RUN git clone https://github.com/xwiki-labs/cryptpad

# Persistent storage needs
VOLUME /cryptpad/cfg
VOLUME /cryptpad/datastore
VOLUME /cryptpad/customize
VOLUME /cryptpad/blobstage
VOLUME /cryptpad/pins
VOLUME /cryptpad/tasks
VOLUME /cryptpad/block
VOLUME /cryptpad/blob
VOLUME /cryptpad/blobstage

# Install tini for faux init
#   sleep 1 is to ensure overlay2 can catch up with the copy prior to running chmod
RUN cp /cryptpad/docker-install-tini.sh / \
    && chmod a+x /docker-install-tini.sh \
    && sleep 1 \
    && /docker-install-tini.sh \
    && rm /docker-install-tini.sh

# Cleanup apt
RUN apt-get remove -y --purge jq python \
    && apt-get auto-remove -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install cryptpad
WORKDIR /cryptpad
RUN npm install --production \
    && npm install -g bower \
    && bower install --allow-root

# Unsafe / Safe ports
EXPOSE 3000 3001

# Run cryptpad on startup
CMD ["/sbin/tini", "--", "/cryptpad/container-start.sh"]

