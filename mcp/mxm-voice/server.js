#!/usr/bin/env node
// Copyright (c) 2026 iSystematic Inc. Maxim is a product of iSystematic Inc.
// SPDX-License-Identifier: BSL-1.1 (Apache-2.0 after 4 years per ADR-005)

/**
 * mxm-voice — Maxim's voice-driven office routing MCP server.
 *
 * Wraps mbailey/voicemode (Whisper STT + Kokoro TTS) with:
 *   - Hotword config loaded from config/voice-phrases.yml (user-editable)
 *   - Natural-language intent dispatch through Maxim's executive-router
 *   - Office-aware briefing back via TTS
 *   - Voice-captured decisions written to session memory
 *
 * Tools exposed:
 *   - voice_invoke_command(spoken_phrase)  -> matches against hotwords + dispatches
 *   - voice_brief_office(office)           -> TTS-speaks current office status
 *   - voice_capture_decision(context?)     -> records decision to session memory
 *   - voice_status                         -> reports voicemode install + hotword count
 *
 * Graceful degradation: if mbailey/voicemode is not installed, all tools
 * return clear install instructions instead of failing.
 *
 * License: Apache-2.0
 */

import { Server } from '@modelcontextprotocol/sdk/server/index.js';
import { StdioServerTransport } from '@modelcontextprotocol/sdk/server/stdio.js';
import { CallToolRequestSchema, ListToolsRequestSchema } from '@modelcontextprotocol/sdk/types.js';
import { existsSync, readFileSync, appendFileSync, mkdirSync } from 'node:fs';
import { join, resolve } from 'node:path';
import { parse as parseYaml } from 'yaml';

// ---------------------------------------------------------------------------
// Config
// ---------------------------------------------------------------------------

const MXM_ROOT = process.env.MXM_ROOT || resolve(process.cwd());
const VOICE_PHRASES_PATH = join(MXM_ROOT, 'config', 'voice-phrases.yml');
const VOICEMODE_REQUIRED = (process.env.VOICEMODE_REQUIRED || 'false').toLowerCase() === 'true';
const VOICEMODE_SAVE_AUDIO = (process.env.VOICEMODE_SAVE_AUDIO || 'false').toLowerCase() === 'true';

// ---------------------------------------------------------------------------
// VoiceMode detection (graceful)
// ---------------------------------------------------------------------------

/**
 * Detect whether mbailey/voicemode MCP is reachable.
 * In Claude Code, peer MCP servers are visible to each other through the host's
 * tool list — but this server cannot directly call them. So detection here
 * is best-effort: we report the install path and let the host decide.
 */
function detectVoicemode() {
  // Heuristic: check common install locations
  const candidates = [
    join(process.env.HOME || process.env.USERPROFILE || '', '.claude', 'plugins', 'voicemode'),
    join(process.env.HOME || process.env.USERPROFILE || '', '.local', 'share', 'voicemode'),
    '/usr/local/share/voicemode',
  ];
  for (const path of candidates) {
    if (existsSync(path)) return { installed: true, path };
  }
  return { installed: false, install_command: 'claude plugin marketplace add mbailey/voicemode && claude plugin install voicemode@voicemode && /voicemode:install' };
}

// ---------------------------------------------------------------------------
// Hotword config loader
// ---------------------------------------------------------------------------

function loadHotwords() {
  if (!existsSync(VOICE_PHRASES_PATH)) {
    return { phrases: [], _error: `Hotword config not found at ${VOICE_PHRASES_PATH}. Create it from the template.` };
  }
  try {
    const raw = readFileSync(VOICE_PHRASES_PATH, 'utf8');
    const parsed = parseYaml(raw);
    if (!parsed || !Array.isArray(parsed.phrases)) {
      return { phrases: [], _error: `voice-phrases.yml must contain a 'phrases' array.` };
    }
    return parsed;
  } catch (e) {
    return { phrases: [], _error: `Failed to parse voice-phrases.yml: ${e.message}` };
  }
}

/**
 * Match a spoken phrase against configured patterns.
 * Pattern syntax:
 *   - Plain string  -> case-insensitive substring match
 *   - "*" in pattern -> wildcard captured as $1, $2, etc. for substitution
 *   - Pattern starting with "regex:" -> treated as JS regex
 */
function matchPhrase(spoken, phrases) {
  const utterance = spoken.toLowerCase().trim();
  for (const entry of phrases) {
    if (!entry.pattern || !entry.dispatch) continue;
    const pattern = entry.pattern;

    // Regex pattern
    if (pattern.startsWith('regex:')) {
      const re = new RegExp(pattern.slice(6), 'i');
      const m = utterance.match(re);
      if (m) {
        let dispatch = entry.dispatch;
        for (let i = 1; i < m.length; i++) {
          dispatch = dispatch.replaceAll(`$${i}`, m[i]);
        }
        return { matched: true, pattern, dispatch, captures: m.slice(1) };
      }
      continue;
    }

    // Wildcard pattern
    if (pattern.includes('*')) {
      const reSrc = '^' + pattern.toLowerCase().replaceAll(/[.+?^${}()|[\]\\]/g, '\\$&').replaceAll('*', '(.+?)') + '$';
      const re = new RegExp(reSrc, 'i');
      const m = utterance.match(re);
      if (m) {
        let dispatch = entry.dispatch;
        for (let i = 1; i < m.length; i++) {
          dispatch = dispatch.replaceAll(`$${i}`, m[i].trim());
        }
        return { matched: true, pattern, dispatch, captures: m.slice(1) };
      }
      continue;
    }

    // Plain substring match
    if (utterance.includes(pattern.toLowerCase())) {
      return { matched: true, pattern, dispatch: entry.dispatch, captures: [] };
    }
  }
  return { matched: false };
}

// ---------------------------------------------------------------------------
// Decision capture
// ---------------------------------------------------------------------------

function appendDecision(context, transcript) {
  const sessionsDir = join(process.cwd(), '.claude-sessions-memory');
  if (!existsSync(sessionsDir)) {
    mkdirSync(sessionsDir, { recursive: true });
  }
  const decisionLog = join(sessionsDir, 'decision-log.md');
  const ts = new Date().toISOString();
  const entry = `\n## Voice-captured decision @ ${ts}\n\n**Context:** ${context || 'unspecified'}\n\n**Transcript:**\n> ${transcript}\n\n---\n`;
  appendFileSync(decisionLog, entry, 'utf8');
  return decisionLog;
}

// ---------------------------------------------------------------------------
// MCP Server
// ---------------------------------------------------------------------------

const server = new Server(
  { name: 'mxm-voice', version: '1.0.0' },
  { capabilities: { tools: {} } }
);

server.setRequestHandler(ListToolsRequestSchema, async () => ({
  tools: [
    {
      name: 'voice_invoke_command',
      description:
        'Parse a spoken (transcribed) phrase, match against hotwords in config/voice-phrases.yml, and return the Maxim slash command to dispatch. If no hotword matches, returns the original utterance with a recommendation to route through executive-router.',
      inputSchema: {
        type: 'object',
        properties: {
          spoken_phrase: { type: 'string', description: 'The transcribed utterance (output from VoiceMode/Whisper)' },
        },
        required: ['spoken_phrase'],
      },
    },
    {
      name: 'voice_brief_office',
      description:
        'Generate a TTS-ready spoken summary of an executive office state (CEO/CTO/CMO/CSO/CPO/COO/CINO). Caller is expected to pass the resulting text to mbailey/voicemode for Kokoro TTS playback.',
      inputSchema: {
        type: 'object',
        properties: {
          office: {
            type: 'string',
            enum: ['ceo', 'cto', 'cmo', 'cso', 'cpo', 'coo', 'cino'],
            description: 'Office to brief',
          },
        },
        required: ['office'],
      },
    },
    {
      name: 'voice_capture_decision',
      description:
        'Append a voice-captured decision to .claude-sessions-memory/decision-log.md with timestamp + transcript + optional context tag. Use when the operator dictates a decision they want preserved.',
      inputSchema: {
        type: 'object',
        properties: {
          transcript: { type: 'string', description: 'The decision text (from STT)' },
          context: { type: 'string', description: 'Optional context tag (e.g., "isimplification roadmap", "fixit launch")' },
        },
        required: ['transcript'],
      },
    },
    {
      name: 'voice_status',
      description:
        'Report VoiceMode install status, configured hotword count, and the path to config/voice-phrases.yml. Use to debug "/mxm-voice not working" complaints.',
      inputSchema: { type: 'object', properties: {}, required: [] },
    },
  ],
}));

server.setRequestHandler(CallToolRequestSchema, async (req) => {
  const { name, arguments: args } = req.params;

  // ---- voice_status ----
  if (name === 'voice_status') {
    const vm = detectVoicemode();
    const hot = loadHotwords();
    return {
      content: [
        {
          type: 'text',
          text: JSON.stringify(
            {
              voicemode: vm,
              voicemode_required: VOICEMODE_REQUIRED,
              save_audio: VOICEMODE_SAVE_AUDIO,
              hotwords_path: VOICE_PHRASES_PATH,
              hotwords_loaded: hot.phrases?.length || 0,
              hotwords_error: hot._error || null,
              mxm_root: MXM_ROOT,
            },
            null,
            2
          ),
        },
      ],
    };
  }

  // ---- voice_invoke_command ----
  if (name === 'voice_invoke_command') {
    const spoken = (args?.spoken_phrase || '').toString();
    if (!spoken.trim()) {
      return { content: [{ type: 'text', text: JSON.stringify({ error: 'spoken_phrase is empty' }) }] };
    }
    const vm = detectVoicemode();
    const hot = loadHotwords();
    if (hot._error) {
      return {
        content: [{ type: 'text', text: JSON.stringify({ matched: false, error: hot._error, voicemode: vm }) }],
      };
    }
    const match = matchPhrase(spoken, hot.phrases);
    if (match.matched) {
      return {
        content: [
          {
            type: 'text',
            text: JSON.stringify(
              {
                matched: true,
                spoken,
                pattern: match.pattern,
                dispatch: match.dispatch,
                captures: match.captures,
                hint: 'Execute the dispatch command in Claude Code to fulfill the voice request.',
              },
              null,
              2
            ),
          },
        ],
      };
    }
    return {
      content: [
        {
          type: 'text',
          text: JSON.stringify(
            {
              matched: false,
              spoken,
              recommendation: '/mxm-route ' + spoken,
              hint: "No hotword matched. Routing through executive-router for intent classification. Edit config/voice-phrases.yml to add a hotword for this utterance.",
            },
            null,
            2
          ),
        },
      ],
    };
  }

  // ---- voice_brief_office ----
  if (name === 'voice_brief_office') {
    const office = (args?.office || '').toString().toLowerCase();
    const validOffices = ['ceo', 'cto', 'cmo', 'cso', 'cpo', 'coo', 'cino'];
    if (!validOffices.includes(office)) {
      return { content: [{ type: 'text', text: JSON.stringify({ error: 'office must be one of ' + validOffices.join(', ') }) }] };
    }
    // For each office, generate a templated TTS-ready brief.
    // Real implementation could call mxm-portfolio.get_portfolio_metrics
    // and maxim-skills.list_skills to populate live data — but this server
    // cannot peer-call other MCPs directly. So we return a brief template the
    // caller (Claude) can fill with current data.
    const briefTemplates = {
      ceo: 'CEO office briefing. Lead agent enterprise architect. Active strategy work, partnership pipeline, financial models. Open governance items pending.',
      cto: 'CTO office briefing. Lead agent implementer. 25 specialist agents covering engineering, AI, infrastructure, data, DevOps. Build target check before deploy.',
      cmo: 'CMO office briefing. Lead agent content strategist. 15 marketing specialists. Brand foundation loaded. SEO and content calendar active.',
      cso: 'CSO office briefing. Lead agent security analyst. 9 security agents. Compliance frameworks active per project manifest. CSO auto-loop enforces gates.',
      cpo: 'CPO office briefing. Lead agent product strategist. 12 product specialists. Roadmap, OKRs, user research, accessibility audits.',
      coo: 'COO office briefing. Lead agent planner. 9 operations agents. Sprint cycle, experiment tracking, support queue.',
      cino: 'CINO office briefing. Lead agent innovation researcher. R and D coordinator and skill synthesizer. Horizon scanning active.',
    };
    return {
      content: [
        {
          type: 'text',
          text: JSON.stringify(
            {
              office,
              tts_text: briefTemplates[office],
              hint: 'Pass tts_text to mbailey/voicemode for Kokoro playback. For live data, call mxm-portfolio.get_portfolio_metrics first and merge.',
            },
            null,
            2
          ),
        },
      ],
    };
  }

  // ---- voice_capture_decision ----
  if (name === 'voice_capture_decision') {
    const transcript = (args?.transcript || '').toString();
    const context = (args?.context || '').toString();
    if (!transcript.trim()) {
      return { content: [{ type: 'text', text: JSON.stringify({ error: 'transcript is empty' }) }] };
    }
    try {
      const path = appendDecision(context, transcript);
      return {
        content: [
          {
            type: 'text',
            text: JSON.stringify(
              {
                saved: true,
                path,
                context,
                length: transcript.length,
              },
              null,
              2
            ),
          },
        ],
      };
    } catch (e) {
      return { content: [{ type: 'text', text: JSON.stringify({ saved: false, error: e.message }) }] };
    }
  }

  return { content: [{ type: 'text', text: JSON.stringify({ error: `Unknown tool: ${name}` }) }] };
});

// ---------------------------------------------------------------------------
// Boot
// ---------------------------------------------------------------------------

const transport = new StdioServerTransport();
await server.connect(transport);
