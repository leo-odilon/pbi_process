#!/bin/bash

cd ./../
podman rm -f python && podman run -d \
  --name python \
  -v $(pwd):/app \
  -w /app \
  python:3.11-slim \
  /bin/bash -c "while true; do sleep 50; done"

# podman exec -it python /bin/sh -c "pip install --no-cache-dir -r /app/docker/requirements.txt"

podman exec -it python /bin/sh -c "python /app/python/backup.py /app/raw_file/queue"
podman exec -it python /bin/sh -c "python /app/python/backup.py /app/raw_file/report"

podman rm -f python