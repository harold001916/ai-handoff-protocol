# Regla Global: Handoff de Emergencia entre IAs (Palabra clave: "Relevo")

Cuando el usuario escriba la palabra "Relevo" o "relevo":
1. El agente asume que el modelo anterior (ej. Claude o Gemini) se quedó sin cuota.
2. El agente DEBE buscar inmediatamente y leer los archivos `HANDOFF.md` y `STATE.md` (si existen en la raíz del proyecto actual).
3. A partir del último mensaje incompleto que está en `HANDOFF.md`, el agente debe entender el contexto y CONTINUAR exactamente la tarea donde se cortó el modelo anterior, sin hacer preguntas repetitivas.
