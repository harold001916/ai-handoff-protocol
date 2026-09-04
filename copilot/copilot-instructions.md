# AI Handoff Protocol — GitHub Copilot Chat

Protocolo de relevo entre agentes de IA. Copilot Chat no soporta reglas
globales a nivel de máquina — este archivo solo tiene efecto si vive en
`.github/copilot-instructions.md` **dentro de cada repo** donde lo
quieras. Cubre dos direcciones: qué hacer cuando SOS el agente que retoma,
y qué hacer continuamente para que el próximo agente (Copilot, Claude o
Gemini) pueda retomar sin perder nada si a VOS te cortan por límite de
cuota.

## 1. Protocolo de lectura — al recibir la palabra "Relevo"

Cuando el usuario escribe "Relevo" o "relevo":

1. Asumí que el agente anterior (Claude, Gemini u otra sesión de Copilot)
   llegó a su límite de cuota o se desconectó a mitad de tarea.
2. Buscá y leé `HANDOFF.md` en la raíz del proyecto (formato en la sección
   3) — es la fuente de verdad de "qué estaba pasando ahora mismo".
3. Si el proyecto también tiene `STATE.md`, leelo también: `HANDOFF.md`
   describe el instante exacto de la interrupción, `STATE.md` (si existe)
   el mapa completo del proyecto. Usalos juntos; si falta uno, seguí con
   el que exista.
4. A partir de la "Próxima acción exacta" de `HANDOFF.md`, continuá la
   tarea sin repreguntar lo ya documentado.

## 2. Protocolo de escritura — antes de que TE cortes

No hay forma de saber de antemano cuándo se corta la cuota, así que
esperar al "último momento" para escribir `HANDOFF.md` no funciona. La
mitigación real es hacer checkpoint seguido:

- Sugerile al usuario (o escribilo vos si tenés edición de archivos)
  actualizar `HANDOFF.md` cada vez que se cierra un paso significativo de
  una tarea multi-paso, no solo al final.
- Cualquier borrador, log largo o plan de arquitectura que generes va en
  una carpeta neutral `.ai/` o `docs/ai/` en la raíz del proyecto.
- Cuando una tarea termina limpiamente, marcá `HANDOFF.md` como resuelto
  o vacialo — uno viejo apuntando a trabajo ya terminado confunde más de
  lo que ayuda.

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

## 4. Limitaciones reales de Copilot Chat (no las ignores)

- **Sin terminal autónoma**: no podés correr `git status`/`git diff` por
  tu cuenta. Indicale siempre al desarrollador el comando exacto que debe
  correr en la terminal de VS Code y pedile que te pegue el resultado
  antes de asumir el estado del repo.
- **Copilot CLI (`gh copilot`)** no soporta inyección automática de este
  archivo como system prompt — solo la extensión de Copilot Chat en
  VS Code lee `.github/copilot-instructions.md` automáticamente.
- **Sin reglas globales**: si trabajás en varios repos, este archivo tiene
  que copiarse a cada uno (`setup.ps1 -ProjectPath <repo>` lo hace por
  vos), no se comparte solo.
