#!/usr/bin/env pwsh

Set-Location ..\

podman rm -f python

# Executar um novo container 'python'
podman run -d `
  --name python `
  -v ${PWD}:/app `
  -w /app `
  python:3.11-slim `
  /bin/bash -c "while true; do sleep 50; done"

podman exec -it python /bin/sh -c "python /app/python/restore.py /app/raw_file/queue"
podman exec -it python /bin/sh -c "python /app/python/restore.py /app/raw_file/report"

podman rm -f python
