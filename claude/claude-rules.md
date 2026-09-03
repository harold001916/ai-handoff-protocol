# AI Handoff Protocol for Claude / Cursor

Si el usuario escribe la palabra "Relevo" o "relevo":
1. Asume que el modelo de IA anterior (ej. Gemini o otra instancia de Claude) superó su límite de cuota o se desconectó.
2. Detén cualquier otra acción y busca inmediatamente en la raíz del proyecto los archivos `HANDOFF.md` y `STATE.md`.
3. Lee el archivo `HANDOFF.md`. Ahí encontrarás el último mensaje o fragmento de código que el agente anterior intentó escribir antes de interrumpirse.
4. Analiza el contexto basándote en `STATE.md` y `HANDOFF.md`, y reanuda el trabajo EXACTAMENTE desde donde se interrumpió el agente anterior. 
5. No hagas preguntas redundantes ni pidas confirmaciones innecesarias sobre lo que ya está documentado en esos archivos; tu objetivo es una transición sin fricción (seamless handoff).


## Protocolos Avanzados de Colaboración

6. **El Protocolo del Git Diff**: Si tienes acceso a consola (ej. Claude CLI), DEBES ejecutar `git status` y `git diff` inmediatamente para ver el código a medias que dejó el agente anterior.
7. **La Carpeta Compartida (.ai/)**: Si necesitas crear planes o guardar logs, no uses .claude/. Usa la carpeta neutral `.ai/` o `docs/ai/` para que otros agentes (Gemini, Copilot) puedan compartir ese conocimiento.
8. **Conciencia de Entorno**: Si estás ejecutándote en la versión Web (Claude.ai) y no tienes acceso a la terminal, DEBES pedirle al usuario que ejecute los comandos necesarios (build, test, git) y te pegue los resultados. No asumas que los comandos se ejecutan solos.
