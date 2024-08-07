#!/usr/bin/env pwsh

# Mudar para o diretório pai
Set-Location ..\

# Remover diretórios
Remove-Item -Path (Join-Path (Get-Location) "data/hive") -Recurse -Force
Remove-Item -Path (Join-Path (Get-Location) "parquet/pbi") -Recurse -Force
