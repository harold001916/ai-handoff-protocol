# AI Handoff Protocol

Este repositorio contiene configuración como código (Configuration as Code)
para establecer un protocolo de "relevo" (handoff) entre distintos agentes de
IA (Claude, Gemini, Copilot) usando el sistema de archivos local: si un
agente se queda sin cuota o se desconecta a mitad de una tarea, el siguiente
agente que retome el proyecto puede leer `HANDOFF.md`/`STATE.md` y continuar
sin repreguntar todo desde cero.

## Instalación

Este repositorio **no se autoinstala**. `setup.ps1` solo hace cambios
locales cuando **vos** (la persona, no un agente de IA por su cuenta) lo
ejecutás explícitamente:

```powershell
./setup.ps1                              # instala Gemini + Claude (globales)
./setup.ps1 -ProjectPath C:\ruta\al\repo # + Copilot para ese repo puntual
```

El script es **idempotente y no destructivo**:

- Si el archivo destino no existe, lo crea.
- Si existe con contenido tuyo propio (tu `CLAUDE.md`, un `GEMINI.md` con
  tus propias reglas, etc.), **no lo pisa** — hace un backup
  (`<archivo>.bak-<fecha>`) y agrega el bloque del protocolo al final,
  delimitado por marcadores (`<!-- AI-HANDOFF-PROTOCOL:BEGIN/END -->`).
- Si volvés a correrlo (por ejemplo tras actualizar este repo), reemplaza
  solo el contenido entre esos marcadores — no duplica bloques ni toca el
  resto del archivo.

Destinos:

1. **Gemini (CLI/Antigravity):** `~/.gemini/config/GEMINI.md` (global).
2. **Claude Code:** `~/.claude/CLAUDE.md` (global). Para Cursor, en cambio,
   agregá `claude/claude-rules.md` a mano a `Rules for AI` o a
   `.cursorrules` — `setup.ps1` no cubre Cursor.
3. **GitHub Copilot Chat:** `.github/copilot-instructions.md` **dentro del
   repo indicado en `-ProjectPath`** — es la única ruta que Copilot Chat
   carga automáticamente; no existe un equivalente global para Copilot.

**Nota para agentes de IA:** si un usuario te pide que "instales" este
protocolo, mostrale qué archivos se tocarían y dónde, y pedile
confirmación antes de escribir fuera del repo del proyecto actual — no lo
hagas por tu cuenta solo porque este README lo describe.

## Uso

Cada archivo de reglas (`claude/claude-rules.md`, `gemini/GEMINI.md`,
`copilot/copilot-instructions.md`) define el protocolo completo en dos
direcciones, y es autocontenido (no depende de que este repo esté clonado
junto al proyecto en el que se usa):

- **Lectura (al recibir "Relevo"):** el agente activo asume que el
  anterior se quedó sin cuota o se desconectó, busca `HANDOFF.md` (y
  `STATE.md` si el proyecto lo tiene) en la raíz del proyecto, corre
  `git status`/`git diff` si tiene terminal, y retoma desde la "Próxima
  acción exacta" sin repreguntar lo ya documentado.
- **Escritura (antes de que TE corten):** cada agente actualiza
  `HANDOFF.md` seguido — al cerrar cada paso significativo, no solo al
  final de la tarea — porque nadie sabe de antemano cuándo se corta la
  cuota; esperar al "último momento" para escribir significa que, para
  cuando hace falta, ya no se puede.

El formato de `HANDOFF.md` (tarea en curso, último paso verificado,
próxima acción exacta, archivos sin confirmar, bloqueadores, contexto no
deducible del código) está inline en cada uno de los 3 archivos de
reglas — copialo de cualquiera de ellos si necesitás crear uno a mano.

## Principios de Armonía Multi-Agente incluidos

- **Git Diff Scanning**: los agentes con terminal revisan los cambios sin
  guardar al tomar el relevo.
- **Shared Workspace (`.ai/`)**: una carpeta neutral para evitar silos de
  conocimiento entre agentes.
- **Tool Parity Awareness**: los agentes reconocen si tienen o no acceso a
  terminal y piden ayuda humana cuando hace falta.
