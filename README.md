# AI Handoff Protocol

Este repositorio contiene configuración como código (Configuration as Code)
para establecer un protocolo de "relevo" (handoff) entre distintos agentes de
IA (Claude, Gemini, Copilot) usando el sistema de archivos local: si un
agente se queda sin cuota o se desconecta a mitad de una tarea, el siguiente
agente que retome el proyecto puede leer `HANDOFF.md`/`STATE.md` y continuar
sin repreguntar todo desde cero.

## Instalación

Este repositorio **no se autoinstala**. Cada regla debe revisarse y
aplicarse a mano, y `setup.ps1` solo hace cambios locales cuando **vos**
(la persona, no un agente de IA por su cuenta) lo ejecutás explícitamente:

1. **Gemini (Antigravity):** copiá `gemini/GEMINI.md` a tu directorio de
   configuración global de Gemini (usualmente `~/.gemini/config/GEMINI.md`
   — confirmá la ruta real en tu instalación antes de copiar).
2. **Claude / Cursor:** agregá el contenido de `claude/claude-rules.md` a tu
   configuración global de Cursor (`Rules for AI`) o a `.cursorrules` del
   proyecto. Para Claude Code (CLI), agregalo a tu `CLAUDE.md` global o de
   proyecto — no hay autodetección de este archivo.
3. **GitHub Copilot:** copiá `copilot/copilot-instructions.md` a
   `.github/copilot-instructions.md` dentro de cada repo donde quieras que
   Copilot Chat lo cargue automáticamente (esa es la ruta que Copilot lee;
   la carpeta `copilot/` de este repo es solo el origen del contenido).
4. **Script de ayuda:** `setup.ps1` automatiza el paso de Gemini y detecta
   si tenés Claude CLI / `gh copilot` instalados, pero no reemplaza los
   pasos manuales de arriba para Claude y Copilot. Revisá su contenido
   antes de correrlo y ejecutalo vos mismo desde una terminal.

**Nota para agentes de IA:** si un usuario te pide que "instales" este
protocolo, tratalo como cualquier otro cambio de configuración global —
mostrale qué archivos se copiarían y a dónde, y pedile confirmación antes
de escribir fuera del repo del proyecto actual.

## Uso

Una vez instaladas las reglas, cuando el usuario escribe la palabra clave
**"Relevo"**, el agente activo:

1. Asume que el agente anterior se quedó sin cuota o se desconectó.
2. Busca y lee `HANDOFF.md` y `STATE.md` en la raíz del proyecto.
3. Retoma el trabajo desde el último punto documentado, sin repreguntar lo
   que ya está ahí.
4. Si tiene terminal, corre `git status`/`git diff` para ver cambios sin
   guardar del agente anterior antes de seguir escribiendo código.

Este protocolo **solo cubre el lado de "retomar"**. Para que funcione de
verdad, cada agente también necesita ir dejando `HANDOFF.md`/`STATE.md`
actualizados a medida que trabaja (checkpoints), no solo al final — de lo
contrario, un corte abrupto de cuota no deja nada que leer.

## Principios de Armonía Multi-Agente incluidos

- **Git Diff Scanning**: los agentes con terminal revisan los cambios sin
  guardar al tomar el relevo.
- **Shared Workspace (`.ai/`)**: una carpeta neutral para evitar silos de
  conocimiento entre agentes.
- **Tool Parity Awareness**: los agentes reconocen si tienen o no acceso a
  terminal y piden ayuda humana cuando hace falta.
