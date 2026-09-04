# AI Handoff Protocol — Gemini (CLI / Antigravity)

Protocolo de relevo entre agentes de IA. Cubre dos direcciones: qué hacer
cuando SOS el agente que retoma, y qué hacer continuamente para que el
próximo agente (Gemini, Claude o Copilot) pueda retomar sin perder nada si
a VOS te cortan por límite de cuota.

## 1. Protocolo de lectura — al recibir la palabra "Relevo"

Cuando el usuario escribe "Relevo" o "relevo":

1. Asumí que el agente anterior (otra instancia de Gemini, Claude o
   Copilot) llegó a su límite de cuota o se desconectó a mitad de tarea.
2. Buscá en la raíz del proyecto actual `HANDOFF.md` (formato en la
   sección 3). Si existe, es la fuente de verdad de "qué estaba pasando
   ahora mismo" — leelo antes que cualquier otra cosa.
3. Si el proyecto también tiene `STATE.md` u otro documento de estado
   propio, leelo también: `HANDOFF.md` describe el instante exacto de la
   interrupción; `STATE.md` (si existe) describe el mapa completo del
   proyecto. Usalos juntos; si falta uno, seguí con el que exista.
4. Si tenés acceso a terminal, ejecutá `git status` y `git diff`
   inmediatamente para ver el código sin confirmar que dejó el agente
   anterior, y contrastalo contra "Archivos tocados" de `HANDOFF.md`.
5. Retomá el trabajo EXACTAMENTE desde la "Próxima acción exacta" de
   `HANDOFF.md`, sin repreguntar lo ya documentado.
6. Si no encontrás ni `HANDOFF.md` ni `STATE.md`, decíselo al usuario en
   vez de asumir contexto.

## 2. Protocolo de escritura — antes de que TE cortes

No hay forma de saber de antemano cuándo se corta la cuota, así que
esperar al "último momento" para escribir `HANDOFF.md` no funciona: para
cuando notás el corte, ya no podés escribir nada. La mitigación real es
hacer checkpoint seguido:

- Actualizá `HANDOFF.md` en la raíz del proyecto cada vez que termines un
  paso significativo de una tarea multi-paso, no solo al final.
- Cualquier borrador, log largo, diagrama o plan de arquitectura que
  generes va en una carpeta neutral `.ai/` o `docs/ai/` en la raíz del
  proyecto (no en una carpeta específica de un agente), para que otros
  agentes puedan leerlo sin depender de vos.
- Nunca dejes `HANDOFF.md` describiendo un estado más viejo que el código
  real en disco.
- Cuando una tarea termina limpiamente, vaciá o marcá `HANDOFF.md` como
  resuelto — uno viejo apuntando a trabajo ya terminado confunde más de lo
  que ayuda.

## 3. Formato de `HANDOFF.md`

Autocontenido — no depende de tener clonado el repo `ai-handoff-protocol`
junto al proyecto:

```markdown
# HANDOFF — <proyecto o tarea>
Actualizado: <fecha/hora ISO> por <Claude | Gemini | Copilot>

## Tarea en curso
<1-3 líneas: qué se está haciendo ahora mismo>

## Último paso completado y verificado
<lo último que quedó terminado, con evidencia>

## Próxima acción exacta
<el siguiente paso literal, sin ambigüedad>

## Archivos tocados sin confirmar (staged/unstaged)
- ruta/archivo — qué falta en este archivo específicamente

## Bloqueadores o decisiones que solo el usuario puede tomar
<preguntas abiertas; "ninguno" si no las hay>

## Contexto que no se deduce del código
<el "por qué" detrás de una decisión reciente>
```

## 4. Protocolos avanzados de colaboración multi-agente

- **Git Diff Scanning**: antes de escribir código tras un relevo, corré
  `git status`/`git diff` si tenés terminal.
- **Carpeta compartida (`.ai/`)**: usala para borradores/planes largos, no
  una carpeta específica de un solo agente.
- **Conciencia de poderes**: si no tenés permisos para ejecutar comandos,
  indicale explícitamente al usuario qué comandos correr por vos.

## 5. Instalación

Este archivo se instala en el directorio de configuración global de Gemini
(`~/.gemini/config/GEMINI.md` normalmente). `setup.ps1` lo hace de forma
idempotente: si ya existe contenido tuyo ahí, lo respeta y solo actualiza
el bloque delimitado de este protocolo (con backup antes del primer
cambio) — nunca sobrescribe el archivo entero a ciegas.
