# AI Handoff Protocol — Claude (Claude Code / Cursor / Claude.ai)

Protocolo de relevo entre agentes de IA. Cubre dos direcciones: qué hacer
cuando SOS el agente que retoma, y qué hacer continuamente para que el
próximo agente (Claude, Gemini o Copilot) pueda retomar sin perder nada si
a VOS te cortan por límite de cuota.

## 1. Protocolo de lectura — al recibir la palabra "Relevo"

Cuando el usuario escribe "Relevo" o "relevo":

1. Asumí que el agente anterior (otra instancia de Claude, Gemini o
   Copilot) llegó a su límite de cuota o se desconectó a mitad de tarea.
2. Buscá en la raíz del proyecto actual `HANDOFF.md` (formato en la
   sección 3). Si existe, es la fuente de verdad de "qué estaba pasando
   ahora mismo" — leelo antes que cualquier otra cosa.
3. Si el proyecto también tiene `STATE.md` u otro documento de estado
   propio del proyecto, leelo también: `HANDOFF.md` describe el instante
   exacto de la interrupción; `STATE.md` (si existe) describe el mapa
   completo del proyecto (roadmap, decisiones, qué está hecho). No son
   redundantes —úsalos juntos, y si te faltara uno de los dos, seguí con
   el que exista.
4. Si tenés terminal, ejecutá `git status` y `git diff` inmediatamente
   para ver el código sin confirmar que dejó el agente anterior, y
   contrastalo contra la sección "Archivos tocados" de `HANDOFF.md`.
5. Retomá el trabajo EXACTAMENTE desde la "Próxima acción exacta" de
   `HANDOFF.md`. No preguntes de nuevo lo que ya está documentado ahí ni
   en `STATE.md` — el objetivo es una transición sin fricción.
6. Si no encontrás ni `HANDOFF.md` ni `STATE.md`, decíselo al usuario
   explícitamente en vez de asumir contexto — no hay nada de qué partir.

## 2. Protocolo de escritura — antes de que TE cortes

Un agente no sabe de antemano cuándo va a quedarse sin cuota, así que
esperar a "el último momento" para escribir `HANDOFF.md` no funciona: para
cuando notás el corte, ya no podés escribir nada. La única forma de que
esto realmente evite pérdida de datos es hacer checkpoint seguido, no al
final:

- Actualizá `HANDOFF.md` en la raíz del proyecto **cada vez que termines
  un paso significativo** de una tarea multi-paso (no solo al cerrar toda
  la tarea) — pensalo como un commit frecuente, no como una nota de
  despedida.
- Si el usuario tiene un `STATE.md` con su propia disciplina de
  checkpoints (por módulo/tarea), respetá esa disciplina para `STATE.md`
  y usá `HANDOFF.md` para el grano más fino: el punto exacto dentro del
  módulo/tarea en curso.
- Nunca dejes `HANDOFF.md` describiendo un estado más viejo que el código
  real en disco — si acabas de tocar un archivo, `HANDOFF.md` tiene que
  reflejarlo antes de seguir con el siguiente paso.
- Cuando una tarea termina limpiamente (mergeada, revisada, sin cabos
  sueltos), vaciá o marcá `HANDOFF.md` como resuelto — un `HANDOFF.md`
  viejo apuntando a trabajo ya terminado es peor que no tener ninguno,
  porque el próximo agente puede retomar algo que ya no aplica.

## 3. Formato de `HANDOFF.md`

Este formato es autocontenido — no depende de que el repo
`ai-handoff-protocol` esté clonado junto al proyecto. Usalo tal cual (podés
agregar secciones propias del proyecto, pero no quites estas):

```markdown
# HANDOFF — <proyecto o tarea>
Actualizado: <fecha/hora ISO> por <Claude | Gemini | Copilot>

## Tarea en curso
<1-3 líneas: qué se está haciendo ahora mismo>

## Último paso completado y verificado
<lo último que quedó terminado, con evidencia — test corrido, comando y
resultado, no solo "lo hice">

## Próxima acción exacta
<el siguiente paso literal: comando a correr, archivo y función a tocar,
sin ambigüedad — el próximo agente no debería tener que inferir nada>

## Archivos tocados sin confirmar (staged/unstaged)
- ruta/archivo — qué falta en este archivo específicamente

## Bloqueadores o decisiones que solo el usuario puede tomar
<preguntas abiertas, si las hay; "ninguno" si no las hay>

## Contexto que no se deduce del código
<el "por qué" detrás de una decisión reciente — lo que un `git diff` no
muestra>
```

## 4. Conciencia de entorno

- **Con terminal (Claude Code, Cursor):** el protocolo del git diff (§1.4)
  es obligatorio antes de escribir código nuevo tras un relevo.
- **Sin terminal (Claude.ai web):** pedile al usuario que corra los
  comandos necesarios (`git status`, tests, build) y te pegue el
  resultado — no asumas que se ejecutaron solos.
- **Instalación real para Claude Code:** este archivo no se autodetecta.
  Para que Claude Code lo aplique, su contenido tiene que estar en tu
  `CLAUDE.md` global (`~/.claude/CLAUDE.md`) o de proyecto — `setup.ps1`
  lo instala ahí de forma idempotente (ver README).
