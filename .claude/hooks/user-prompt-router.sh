#!/usr/bin/env bash
# Copyright (c) 2026 iSystematic Inc. Maxim is a product of iSystematic Inc.
# SPDX-License-Identifier: BSL-1.1 (Apache-2.0 after 4 years per ADR-005)
# =============================================================================
# Maxim — UserPromptSubmit Hook: Default-On Intent Router (ADR-021)
# =============================================================================
# Fires on every user prompt. Classifies intent (deterministic keyword match
# against config/routing-table.json) and, ONLY on a confident match, injects a
# routing directive telling Claude which office + skills + frameworks to use,
# and to open its reply with a banner showing the routing token cost.
# A no-match prompt passes through SILENTLY (vanilla Claude). Opt out via
# routing-table.json "enabled": false  OR  <project>/.mxm-skills/router-off.
#
# I/O contract: reads the UserPromptSubmit JSON on stdin; on a match prints
# {"hookSpecificOutput":{"hookEventName":"UserPromptSubmit","additionalContext":"..."}}.
# Path discipline: prompt passed via env (not source interpolation); paths
# resolved natively in Python (BUG-008 lesson). Exit 0 always (never block).
# =============================================================================
set -uo pipefail

PLUGIN_ROOT="${CLAUDE_PLUGIN_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." 2>/dev/null && pwd)}"
INPUT="$(cat)"

MXM_HOOK_INPUT="$INPUT" MXM_PLUGIN_ROOT="$PLUGIN_ROOT" python3 <<'PYEOF' 2>/dev/null || true
import os, json, re, datetime
from pathlib import Path

def out_nothing():
    raise SystemExit(0)

try:
    data = json.loads(os.environ.get("MXM_HOOK_INPUT", "") or "{}")
except Exception:
    out_nothing()

prompt = (data.get("prompt") or "").strip()
if not prompt:
    out_nothing()
plow = prompt.lower()

root = Path(os.environ.get("MXM_PLUGIN_ROOT") or ".")
table_path = root / "config" / "routing-table.json"
if not table_path.is_file():
    out_nothing()
try:
    table = json.loads(table_path.read_text(encoding="utf-8"))
except Exception:
    out_nothing()

if not table.get("enabled", True):
    out_nothing()

cwd = data.get("cwd") or "."
if (Path(cwd) / ".mxm-skills" / "router-off").exists():
    out_nothing()

minhits = int(table.get("min_keyword_hits", 1))
weak = set(w.lower() for w in table.get("weak_keywords", []))

def _kw_hit(k, text):
    # Word-boundary match (allows a simple plural). Plain substring matching
    # caused false routes: "code"->codex, "api"->therapist, "plan"->explanation,
    # "feature"->features. \b anchors each keyword to whole words.
    return re.search(r"\b" + re.escape(k.lower()) + r"(?:s|es)?\b", text) is not None

best, best_hits = None, 0
for r in table.get("routes", []):
    matched = [k for k in r.get("keywords", []) if _kw_hit(k, plow)]
    hits = len(matched)
    strong = sum(1 for k in matched if k.lower() not in weak)
    # A single weak-only keyword (e.g. "plan" in "back to our plan") is not a
    # confident route: require >=1 strong hit OR >=2 total hits.
    if hits == 0 or (strong == 0 and hits < 2):
        continue
    if hits > best_hits:
        best, best_hits = r, hits
if not best or best_hits < minhits:
    out_nothing()  # no confident route → vanilla passthrough

office = best["office"]; rid = best["id"]
skills = best.get("skills", []); fw = best.get("frameworks", [])
fb = (table.get("fallback") or {}).get("command", 'bash bootstrap/mxm-find-skill.sh "<need>"')
skills_s, fw_s = ", ".join(skills), ", ".join(fw)
short = " · ".join(skills[:3]); fwshort = " · ".join(fw[:2])

tmpl = (
    "[Maxim Default-On Router · ADR-021] This is a {office}-office task ({rid}). "
    "Use Maxim skills: {skills}. Apply frameworks: {fw} — cite per ADR-007, confidence-tag per ADR-010. "
    "If you lack a native skill for any part, run: {fb} (external candidates are Maxim-UNENHANCED per ADR-008). "
    "Begin your reply with EXACTLY this line: \"\U0001F9ED Maxim: {office} · {short} · {fwshort} · routing ~{N} tokens\""
)
base = tmpl.format(office=office, rid=rid, skills=skills_s, fw=fw_s, fb=fb, short=short, fwshort=fwshort, N=0)
N = max(1, len(base) // 4)
final = tmpl.format(office=office, rid=rid, skills=skills_s, fw=fw_s, fb=fb, short=short, fwshort=fwshort, N=N)

if table.get("show_token_cost", True):
    try:
        logp = Path(cwd) / ".mxm-skills" / "routing-log.jsonl"
        logp.parent.mkdir(parents=True, exist_ok=True)
        with logp.open("a", encoding="utf-8") as f:
            f.write(json.dumps({
                "ts": datetime.datetime.now().isoformat(timespec="seconds"),
                "route": rid, "office": office, "keyword_hits": best_hits,
                "routing_tokens_est": N, "prompt_preview": prompt[:60]
            }) + "\n")
    except Exception:
        pass

print(json.dumps({"hookSpecificOutput": {
    "hookEventName": "UserPromptSubmit", "additionalContext": final}}))
PYEOF
exit 0
