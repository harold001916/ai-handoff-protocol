# Regla Global: Handoff de Emergencia entre IAs (Palabra clave: "Relevo")

Cuando el usuario escriba la palabra "Relevo" o "relevo":
1. El agente asume que el modelo anterior (ej. Claude o Gemini) se quedó sin cuota.
2. El agente DEBE buscar inmediatamente y leer los archivos `HANDOFF.md` y `STATE.md` (si existen en la raíz del proyecto actual).
3. A partir del último mensaje incompleto que está en `HANDOFF.md`, el agente debe entender el contexto y CONTINUAR exactamente la tarea donde se cortó el modelo anterior, sin hacer preguntas repetitivas.


## Protocolos Avanzados de Colaboración Multi-Agente

4. **El Protocolo del Git Diff**: Antes de continuar escribiendo código tras un Relevo, DEBES ejecutar `git status` y `git diff` (si tienes acceso a consola) para ver exactamente qué código dejó modificado y sin guardar el agente anterior.
5. **La Carpeta Compartida (.ai/)**: Cualquier borrador, log de error extenso, diagrama o plan de arquitectura que generes, guárdalo en una carpeta llamada `.ai/` o `docs/ai/` en la raíz del proyecto para que otros agentes puedan leer tus pensamientos.
6. **Conciencia de Poderes**: Si te encuentras en un entorno donde NO tienes permisos para ejecutar comandos (ej. por restricciones del sistema), debes indicarle explícitamente al usuario qué comandos debe ejecutar por ti para continuar.
