#!/usr/bin/env pwsh

# Executar o script de limpeza
. .\clear.ps1

# Remover os containers
podman rm -f python
podman rm -f trino
