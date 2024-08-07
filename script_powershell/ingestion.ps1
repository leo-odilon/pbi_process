#!/usr/bin/env pwsh

# Mudar para o diretório pai
Set-Location ..\

# Remover o container 'python' se estiver em execução e iniciar um novo container
podman rm -f python
podman run -d `
  --name python `
  --network host `
  -v ${PWD}:/app `
  -w /app `
  python:3.11-slim `
  /bin/bash -c "while true; do sleep 50; done"
# ls
# Instalar as dependências
podman exec -it python /bin/sh -c "pip install --no-cache-dir -r /app/docker/requirements.txt"

# Executar os scripts de ingestão
podman exec -it python /bin/sh -c "python /app/python/ingestion.py /app/raw_file/queue 0 /app/parquet/pbi/ibm_queue ibm_queue"
Start-Sleep -Seconds 2
podman exec -it python /bin/sh -c "python /app/python/ingestion.py /app/raw_file/report --sheet_name='Incident Records' 3 /app/parquet/pbi/incident_records incident_records"
Start-Sleep -Seconds 2
podman exec -it python /bin/sh -c "python /app/python/ingestion.py /app/raw_file/report --sheet_name='IR - Activity' 3 /app/parquet/pbi/ir_activity ir_activity"
Start-Sleep -Seconds 2

# Executar os scripts de backup
podman exec -it python /bin/sh -c "python /app/python/backup.py /app/raw_file/report"
podman exec -it python /bin/sh -c "python /app/python/backup.py /app/raw_file/queue"

# Remover o container 'python'
podman rm -f python
