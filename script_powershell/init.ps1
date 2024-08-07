#!/usr/bin/env pwsh

# Definir o nome do container
$containerName = "trino"

function Show-Loading {
    param (
        [int]$duration
    )
    
    $interval = 0.5
    $chars = @("|", "/", "-", "\")
    $startTime = Get-Date

    while ((Get-Date).Subtract($startTime).TotalSeconds -lt $duration) {
        foreach ($char in $chars) {
            Write-Host -NoNewline "`rLoading $char"
            Start-Sleep -Seconds $interval
        }
    }
    Write-Host -NoNewline "`r"
}

# Mudar para o diretório pai
Set-Location ..\

# Obter o caminho atual
$pwd = Get-Location
Write-Host $pwd

# Remover o container existente e executar um novo container
podman rm -f $containerName
podman run -d `
  --name $containerName `
  -p 8080:8080 `
  -v "$pwd\etc:/etc/trino" `
  -v "$pwd\data:/data" `
  -v "$pwd\parquet:/parquet" `
  -v "$pwd\querys\tables:/querys" `
  trinodb/trino

Write-Host "Inicializando configurações"
Show-Loading -duration 15

Write-Host "Criando estrutura do banco de dados"
podman exec -it $containerName /bin/sh -c "trino --server http://localhost:8080 -f /querys/pbi.sql"
Write-Host "Ambiente pronto"
