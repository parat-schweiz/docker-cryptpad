#!/bin/bash

docker stop cryptpad
docker rm cryptpad
docker run -d \
--name cryptpad \
--restart=always \
-p 8007:3000 \
-v /srv/cryptpad/files:/cryptpad/datastore \
-v /srv/cryptpad/customize:/cryptpad/customize \
-v /srv/cryptpad/blob:/cryptpad/blob \
-v /srv/cryptpad/blobstage:/cryptpad/blobstage \
-v /srv/cryptpad/pins:/cryptpad/pins \
-v /srv/cryptpad/tasks:/cryptpad/tasks \
-v /srv/cryptpad/block:/cryptpad/block \
-v /srv/cryptpad/cfg:/cryptpad/cfg \
exception/cryptpad

