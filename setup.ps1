<#
.SYNOPSIS
Instala las reglas globales de AI Handoff Protocol.

.DESCRIPTION
Este script copia las reglas de Gemini a la ruta de configuración global del usuario.
Si usas Cursor, el script te dará instrucciones de cómo agregar la regla global.
#>

$geminiConfigDir = "$env:USERPROFILE\.gemini\config"
$repoPath = $PSScriptRoot

Write-Host "Iniciando instalación del protocolo de Handoff..." -ForegroundColor Cyan

# Instalar para Gemini
if (-not (Test-Path $geminiConfigDir)) {
    Write-Host "Creando directorio global de Gemini..."
    New-Item -ItemType Directory -Path $geminiConfigDir -Force | Out-Null
}

$geminiRuleSource = "$repoPath\gemini\GEMINI.md"
$geminiRuleDest = "$geminiConfigDir\GEMINI.md"

if (Test-Path $geminiRuleSource) {
    Copy-Item -Path $geminiRuleSource -Destination $geminiRuleDest -Force
    Write-Host "✓ Regla de Gemini instalada exitosamente en $geminiRuleDest" -ForegroundColor Green
} else {
    Write-Host "✗ No se encontró el archivo $geminiRuleSource" -ForegroundColor Red
}

# Instrucciones para Claude/Cursor
Write-Host "`nPara Claude / Cursor IDE:" -ForegroundColor Yellow
Write-Host "El archivo claude\claude-rules.md contiene las instrucciones para Claude."
Write-Host "Para aplicarlo globalmente en Cursor:"
Write-Host "1. Abre Cursor > Settings > General > Rules for AI"
Write-Host "2. Pega el contenido de $repoPath\claude\claude-rules.md"

Write-Host "`n¡Instalación completada!" -ForegroundColor Cyan
