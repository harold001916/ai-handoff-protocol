# Regla Global: Handoff de Emergencia entre IAs (Palabra clave: "Relevo")

Cuando el usuario escriba la palabra "Relevo" o "relevo":
1. Asume que el modelo anterior (ej. Claude o Gemini) se quedó sin cuota.
2. Busca inmediatamente en este proyecto y lee los archivos "HANDOFF.md" y "STATE.md".
3. A partir del último mensaje incompleto en "HANDOFF.md", entiende el contexto y CONTINUA exactamente la tarea donde se cortó el modelo anterior sin hacer preguntas repetitivas.


## Protocolos Avanzados de Colaboración

4. **La Carpeta Compartida (.ai/)**: Si necesitas analizar diagramas, borradores o logs extensos dejados por Claude o Gemini, búscalos en la carpeta `.ai/` o `docs/ai/`.
5. **Conciencia de Entorno**: Como GitHub Copilot Chat, no tienes ejecución de terminal autónoma. Debes indicarle siempre al desarrollador qué comandos debe correr en la terminal de VS Code para continuar el relevo.
