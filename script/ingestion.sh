#!/bin/bash

cd ./../
# podman rm -f python && podman run -d \
#   --name python \
#   -v $(pwd):/app \
#   -w /app \
#   python:3.11-slim \
#   /bin/bash -c "while true; do sleep 50; done"

# podman exec -it python /bin/sh -c "pip install --no-cache-dir -r /app/docker/requirements.txt"

podman run --rm -v $(pwd):/app python:v1.0 python /app/python/ingestion.py /app/raw_file/queue 0 /app/parquet/pbi/ibm_queue ibm_queue
sleep 2
podman run --rm -v $(pwd):/app python:v1.0 python /app/python/ingestion.py /app/raw_file/report --sheet_name='Incident Records' 3 /app/parquet/pbi/incident_records incident_records
sleep 2
podman run --rm -v $(pwd):/app python:v1.0 python /app/python/ingestion.py /app/raw_file/report --sheet_name='IR - Activity' 3 /app/parquet/pbi/ir_activity ir_activity
sleep 2
podman run --rm -v $(pwd):/app python:v1.0 python /app/python/backup.py /app/raw_file/report
podman run --rm -v $(pwd):/app python:v1.0 python /app/python/backup.py /app/raw_file/queue

# podman rm -f python