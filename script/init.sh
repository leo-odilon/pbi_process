#!/bin/bash

container_name="hive4"

show_loading() {
    local duration=$1
    local interval=0.5
    local chars=("|" "/" "-" "\\")
    local start_time=$(date +%s)

    while [ $(($(date +%s) - start_time)) -lt $duration ]; do
        for char in "${chars[@]}"; do
            echo -ne "\rLoading $char"
            sleep $interval
        done
    done
    echo -ne "\r"
}

cd ..
echo $(pwd)
podman rm -f $container_name && podman run -d \
  --name $container_name \
  -p 10000:10000 -p 10002:10002 \
  --env SERVICE_NAME=hiveserver2 \
  -v $(pwd)/parquet:/data/parquet \
  -v $(pwd)/query/tables:/data/tables \
  apache/hive:4.0.0 

echo "Inicializando configurações"
show_loading 10
echo "Criando estrutura do banco de dados"
podman exec -it $container_name /bin/sh -c "beeline -u jdbc:hive2://localhost:10000 -f /data/tables/hive.sql"
echo "Apache Hive pronto"
echo "Verificando arquivos para processamento"
show_loading 2

cd script
source ./ingestion.sh

echo "Tudo pronto"