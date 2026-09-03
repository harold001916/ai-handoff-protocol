<#
.SYNOPSIS
Instala las reglas globales de AI Handoff Protocol evaluando qué herramientas están instaladas.
#>

$repoPath = $PSScriptRoot
Write-Host "Iniciando instalación del protocolo de Handoff..." -ForegroundColor Cyan

# 1. Validación y Configuración para Gemini (Antigravity)
$geminiConfigDir = "$env:USERPROFILE\.gemini\config"
if (Test-Path "$env:USERPROFILE\.gemini") {
    Write-Host "
[Gemini] Detectado entorno de Gemini Antigravity."
    if (-not (Test-Path $geminiConfigDir)) { New-Item -ItemType Directory -Path $geminiConfigDir -Force | Out-Null }
    Copy-Item -Path "$repoPath\gemini\GEMINI.md" -Destination "$geminiConfigDir\GEMINI.md" -Force
    Write-Host "✓ Regla de Gemini instalada globalmente." -ForegroundColor Green
} else {
    Write-Host "
[Gemini] No se detectó carpeta local de Gemini, omitiendo..." -ForegroundColor DarkGray
}

# 2. Validación para Claude CLI
if (Get-Command "claude" -ErrorAction SilentlyContinue) {
    Write-Host "
[Claude] CLI detectado."
    Write-Host "✓ La regla para Claude está en claude\claude-rules.md. Claude CLI la leerá cuando se lo indiques." -ForegroundColor Green
} else {
    Write-Host "
[Claude] CLI no instalado. Si usas la versión Web o Cursor, lee README.md." -ForegroundColor DarkGray
}

# 3. Validación para GitHub Copilot CLI (gh copilot)
if (Get-Command "gh" -ErrorAction SilentlyContinue) {
    $ghPlugins = (gh extension list 2>)
    if ($ghPlugins -match "copilot") {
        Write-Host "
[Copilot CLI] Extensión 'gh copilot' detectada."
        Write-Host "⚠️ Nota: Copilot CLI (gh copilot) está diseñado para comandos cortos en consola y no soporta inyección automática de system prompts globales como Cursor o Gemini. Para usar el 'Relevo', debes pasarlo como alias o usar la extensión de Copilot en VS Code (ver copilot\copilot-instructions.md)." -ForegroundColor Yellow
    }
}

Write-Host "
¡Instalación completada!" -ForegroundColor Cyan

