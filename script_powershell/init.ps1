#!/usr/bin/env pwsh

$containerName = "hive4"

Set-Location -Path ".."
Write-Host (Get-Location)

podman rm -f $containerName
podman run -d `
  --name $containerName `
  -p 10000:10000 -p 10002:10002 `
  --env SERVICE_NAME=hiveserver2 `
  -v ${PWD}/parquet:/data/parquet `
  -v ${PWD}/query/tables:/data/tables `
  apache/hive:4.0.0

Write-Host "Inicializando configurações"
Sleep 10
Write-Host "Criando estrutura do banco de dados"
podman exec -it $containerName /bin/sh -c "beeline -u jdbc:hive2://localhost:10000 -f /data/tables/hive.sql"
Sleep 2
podman exec -it $containerName /bin/sh -c "beeline -u jdbc:hive2://localhost:10000 -f /data/tables/views.sql"
Write-Host "Apache Hive pronto"
Write-Host "Verificando arquivos para processamento"
Sleep 2

Set-Location -Path "script_powershell"

. ./ingestion.ps1

Write-Host "Tudo pronto"
