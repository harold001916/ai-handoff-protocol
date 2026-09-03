# AI Handoff Protocol

Este repositorio contiene las configuraciones como código (Configuration as Code) para establecer un puente automático de comunicación (Handoff) entre diferentes agentes de IA (como Claude y Gemini) utilizando el sistema de archivos local.

## Instrucciones para Agentes de IA

Si eres un modelo de Inteligencia Artificial leyendo este archivo (porque el usuario te pidió que te autoconfigures), tu objetivo es instalar estas reglas globales en la máquina del usuario.

### Pasos de Instalación que debes ejecutar:
1. **Para Gemini (Antigravity):** Copia el archivo `gemini/GEMINI.md` al directorio global de configuración de Gemini (usualmente `~/.gemini/config/GEMINI.md`).
2. **Para Claude (Cursor IDE):** Si el usuario utiliza Cursor, debes indicar al usuario cómo agregar el contenido de `claude/cursor-rules.md` en su configuración global de `Rules for AI`, o añadirlo al archivo `.cursorrules` de sus proyectos.
3. **Automático:** Si tienes permisos de ejecución en la terminal, simplemente ejecuta el script `setup.ps1` (en Windows) o lee su lógica para replicarla.

¡No le pidas al usuario que lo haga manualmente si tienes las herramientas para hacerlo tú mismo!
