#!/bin/bash

container_name="trino"

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
  -p 8080:8080 \
  -v $(pwd)/etc:/etc/trino \
  -v $(pwd)/data:/data \
  -v $(pwd)/parquet:/parquet \
  -v $(pwd)/querys/tables:/querys \
  trinodb/trino 

check_container_status() {
    podman inspect --format '{{.State.Status}}' $container_name 2>/dev/null
}

while true; do
    status=$(check_container_status)
    if [[ "$status" == "running" ]]; then
        echo "O contêiner $container_name está em execução."
        break
    else
        echo "Aguardando o contêiner $container_name iniciar..."
    fi
done
echo "Inicializando configurações"
show_loading 15
echo "Criando estrutura do banco de dados"
podman exec -it $container_name /bin/sh -c "trino --server http://localhost:8080 -f /querys/pbi.sql"
echo "Ambiente pronto"