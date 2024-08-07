#!/usr/bin/env pwsh

# Mudar para o diretório pai
Set-Location ..\

# Remover o container 'python' se estiver em execução e iniciar um novo container
podman rm -f python
podman run -d `
  --name python `
  -v ${PWD}:/app `
  -w /app `
  python:3.11-slim `
  /bin/bash -c "while true; do sleep 50; done"

# Executar os scripts de backup
podman exec -it python /bin/sh -c "python /app/python/backup.py /app/raw_file/queue"
podman exec -it python /bin/sh -c "python /app/python/backup.py /app/raw_file/report"

# Remover o container 'python'
podman rm -f python
