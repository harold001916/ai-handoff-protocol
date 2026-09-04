<#
.SYNOPSIS
Instala/actualiza las reglas de AI Handoff Protocol para los agentes de IA
detectados en esta máquina, sin pisar contenido que el usuario ya tenga en
sus archivos de configuración.

.DESCRIPTION
Cada regla se inserta entre marcadores delimitados
(AI-HANDOFF-PROTOCOL:BEGIN/END). Si el archivo destino no existe, se crea.
Si existe pero no tiene los marcadores, se hace un backup
(<archivo>.bak-<timestamp>) y se agrega el bloque al final, sin tocar el
resto del contenido. Si ya tiene los marcadores de una instalación previa,
solo se reemplaza el contenido entre marcadores (para poder actualizar el
protocolo más adelante sin duplicar bloques ni perder nada).

.PARAMETER ProjectPath
Carpeta del proyecto donde instalar la regla de GitHub Copilot
(.github/copilot-instructions.md), que es por-repo, no global. Por
defecto, el directorio actual. No aplica a Claude ni Gemini (esas reglas
son globales a la máquina).
#>

param(
    [string]$ProjectPath = (Get-Location).Path
)

$ErrorActionPreference = "Stop"
$repoPath = $PSScriptRoot
$MarkerBegin = "<!-- AI-HANDOFF-PROTOCOL:BEGIN -->"
$MarkerEnd = "<!-- AI-HANDOFF-PROTOCOL:END -->"

function Install-HandoffBlock {
    param(
        [Parameter(Mandatory)] [string]$TargetFile,
        [Parameter(Mandatory)] [string]$BlockContent,
        [Parameter(Mandatory)] [string]$Label
    )

    $targetDir = Split-Path -Parent $TargetFile
    if (-not (Test-Path $targetDir)) {
        New-Item -ItemType Directory -Path $targetDir -Force | Out-Null
    }

    $block = "$MarkerBegin`n$BlockContent`n$MarkerEnd"

    if (-not (Test-Path $TargetFile)) {
        Set-Content -Path $TargetFile -Value $block -Encoding utf8
        Write-Host "  + Creado $TargetFile" -ForegroundColor Green
        return
    }

    $existing = Get-Content -Path $TargetFile -Raw
    $pattern = [regex]::Escape($MarkerBegin) + "(?s).*?" + [regex]::Escape($MarkerEnd)

    if ($existing -match $pattern) {
        $evaluator = [System.Text.RegularExpressions.MatchEvaluator] { param($m) $block }
        $updated = [regex]::Replace($existing, $pattern, $evaluator, [System.Text.RegularExpressions.RegexOptions]::Singleline)
        Set-Content -Path $TargetFile -Value $updated -Encoding utf8
        Write-Host "  ~ Actualizado el bloque de $Label en $TargetFile (resto del archivo intacto)" -ForegroundColor Green
    } else {
        $backup = "$TargetFile.bak-$(Get-Date -Format 'yyyyMMdd-HHmmss')"
        Copy-Item -Path $TargetFile -Destination $backup -Force
        Add-Content -Path $TargetFile -Value "`n$block" -Encoding utf8
        Write-Host "  + Agregado el bloque de $Label a $TargetFile (backup en $backup)" -ForegroundColor Green
    }
}

Write-Host "Iniciando instalacion del protocolo de Handoff..." -ForegroundColor Cyan

# 1. Gemini (CLI / Antigravity) - regla global
$geminiConfigDir = "$env:USERPROFILE\.gemini\config"
if (Test-Path "$env:USERPROFILE\.gemini") {
    Write-Host "`n[Gemini] Detectado entorno de Gemini."
    $geminiBlock = Get-Content -Path "$repoPath\gemini\GEMINI.md" -Raw
    Install-HandoffBlock -TargetFile "$geminiConfigDir\GEMINI.md" -BlockContent $geminiBlock -Label "Gemini"
} else {
    Write-Host "`n[Gemini] No se detecto carpeta local de Gemini (~/.gemini), omitiendo..." -ForegroundColor DarkGray
}

# 2. Claude Code - regla global (CLAUDE.md)
if (Get-Command "claude" -ErrorAction SilentlyContinue) {
    Write-Host "`n[Claude] CLI detectado."
    $claudeConfigDir = "$env:USERPROFILE\.claude"
    $claudeBlock = Get-Content -Path "$repoPath\claude\claude-rules.md" -Raw
    Install-HandoffBlock -TargetFile "$claudeConfigDir\CLAUDE.md" -BlockContent $claudeBlock -Label "Claude"
} else {
    Write-Host "`n[Claude] CLI no instalado. Si usas la version Web o Cursor, agrega claude\claude-rules.md manualmente (ver README.md)." -ForegroundColor DarkGray
}

# 3. GitHub Copilot Chat - regla por-proyecto (.github/copilot-instructions.md)
$copilotTarget = Join-Path $ProjectPath ".github\copilot-instructions.md"
if (Test-Path $ProjectPath) {
    Write-Host "`n[Copilot] Instalando regla de proyecto en $copilotTarget"
    $copilotBlock = Get-Content -Path "$repoPath\copilot\copilot-instructions.md" -Raw
    Install-HandoffBlock -TargetFile $copilotTarget -BlockContent $copilotBlock -Label "Copilot"
} else {
    Write-Host "`n[Copilot] ProjectPath '$ProjectPath' no existe, omitiendo. Pasa -ProjectPath <ruta-del-repo> para instalarlo ahi." -ForegroundColor DarkGray
}

if (Get-Command "gh" -ErrorAction SilentlyContinue) {
    $ghExtensions = & gh extension list 2>$null
    if ($ghExtensions -match "copilot") {
        Write-Host "`n[Copilot CLI] Extension 'gh copilot' detectada." -ForegroundColor Yellow
        Write-Host "  Nota: Copilot CLI (gh copilot) no soporta reglas globales como Cursor o Gemini. El 'Relevo' solo funciona via la extension de Copilot Chat en VS Code, con el archivo .github/copilot-instructions.md instalado arriba." -ForegroundColor Yellow
    }
}

Write-Host "`nInstalacion completada. Cada agente lee/escribe HANDOFF.md (y STATE.md si el proyecto lo tiene) en la raiz del proyecto activo -- eso no lo instala este script, se crea solo cuando un agente lo necesita." -ForegroundColor Cyan
