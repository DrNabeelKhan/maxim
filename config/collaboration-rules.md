# Collaboration Rules for Maxim

> Guidelines for effective multi-agent collaboration within the Maxim framework

_Last Updated: March 2026_

---

## Table of Contents

1. [Core Principles](#core-principles)
2. [Communication Protocols](#communication-protocols)
3. [Task Delegation & Handoffs](#task-delegation--handoffs)
4. [Conflict Resolution](#conflict-resolution)
5. [Context Sharing](#context-sharing)
6. [Quality Assurance](#quality-assurance)
7. [Escalation Procedures](#escalation-procedures)
8. [Documentation Standards](#documentation-standards)

---

## Core Principles

### 1.1 Purpose-Driven Collaboration

- Every agent interaction must serve a clear objective aligned with the user's goal
- Agents should explicitly state their intent before initiating collaboration
- Avoid redundant work: check if another agent is already handling a task

### 1.2 Respect for Specialization

- Route tasks to agents with relevant expertise (see `agent-categories/`)
- Do not override another agent's domain authority without justification
- When uncertain about ownership, consult the `skill-router` or `multi-agent-coordinator`

### 1.3 Transparency & Traceability

- Log all inter-agent communications in the session context
- Include agent identifiers in all collaborative outputs
- Maintain an audit trail for decisions made through consensus

---

## Communication Protocols

### 2.1 Message Format

```
[AGENT:<name>] [ACTION:<action>] [PRIORITY:<low|medium|high|critical>]
<Payload>
---
[CONTEXT:<reference>] [EXPECTS:<response-type>] [DEADLINE:<optional>]
```

### 2.2 Response Expectations

| Priority | Max Response Time | Retry Strategy           |
| -------- | ----------------- | ------------------------ |
| Critical | 30 seconds        | Immediate escalation     |
| High     | 2 minutes         | 2 retries, then escalate |
| Medium   | 10 minutes        | Queue for next cycle     |
| Low      | Best effort       | No automatic retry       |

### 2.3 Handshake Protocol

1. **Request**: Agent A sends collaboration request with clear scope
2. **Acknowledge**: Agent B confirms capacity and understanding
3. **Execute**: Both agents proceed with defined responsibilities
4. **Confirm**: Completion signal with output summary

---

## Task Delegation & Handoffs

### 3.1 Delegation Criteria

Delegate when:

- Task falls outside your skill category (see `.claude/skills/*/`)
- Another agent has demonstrably higher expertise
- Workload exceeds your capacity threshold
- Task requires parallel processing for efficiency

### 3.2 Handoff Checklist

Before transferring a task:

- [ ] Summarize current state and progress
- [ ] Attach relevant context files/references
- [ ] Specify expected output format
- [ ] Note any constraints or dependencies
- [ ] Confirm receiving agent acceptance

### 3.3 Return Protocol

When a delegated task completes:

1. Receiving agent tags output with `[COMPLETED:<task-id>]`
2. Include brief summary of actions taken
3. Flag any unresolved issues or recommendations
4. Return control to originating agent or next workflow step

---

## Conflict Resolution

### 4.1 Types of Conflicts

| Type               | Description                    | Resolution Approach                              |
| ------------------ | ------------------------------ | ------------------------------------------------ |
| **Priority**       | Competing task urgency         | Consult `project-shipper` or user                |
| **Resource**       | Shared tool/data contention    | First-come-first-served with queue               |
| **Interpretation** | Differing analysis conclusions | Escalate to `senior-architect` or consensus vote |
| **Scope**          | Overlapping task boundaries    | Refer to `product-strategist` for clarification  |

### 4.2 Resolution Workflow

```
1. Identify conflict → 2. Pause conflicting actions → 3.
   Notify involved agents → 4. Attempt peer resolution →
   5. If unresolved, escalate to coordinator → 6. Document outcome
```

### 4.3 Tie-Breaking Rules

1. User preference (if explicitly stated)
2. Agent with higher domain authority for the specific task
3. Approach with lower risk/complexity
4. Random selection (last resort, logged)

---

## Context Sharing

### 5.1 What to Share

✅ **Always Share**:

- User requirements and constraints
- Completed subtask results
- Error states and recovery attempts
- External API responses (sanitized)

✅ **Share on Request**:

- Intermediate reasoning steps
- Alternative approaches considered
- Performance metrics

❌ **Never Share**:

- Raw credentials or secrets
- Unsanitized user PII
- Internal agent prompt templates

### 5.2 Context Packaging

Use structured context blocks:

```markdown
<context-block id="unique-id" type="data|decision|reference">
  <source>agent-name</source>
  <timestamp>ISO-8601</timestamp>
  <content>
    <!-- Structured content here -->
  </content>
  <dependencies>
    <!-- Referenced context IDs -->
  </dependencies>
</context-block>
```

### 5.3 Context Lifecycle

- **Active**: Current session, full access
- **Archived**: Session complete, compressed storage
- **Expired**: Beyond retention policy, secure deletion

---

## Quality Assurance

### 6.1 Peer Review Triggers

Request review when:

- Output affects production systems
- Decision has financial/legal implications
- Novel approach without precedent
- Confidence score < 85%

### 6.2 Review Process

1. Tag output with `[REVIEW-REQUESTED:<agent>]`
2. Reviewer has 15 minutes to respond (adjustable by priority)
3. Reviewer provides: ✅ Approve, ✗ Reject + reason, or 🔁 Revise + suggestions
4. Original agent incorporates feedback or escalates disagreement

### 6.3 Quality Metrics

Track collaboratively:

- Task completion rate
- Handoff success rate
- Conflict resolution time
- User satisfaction scores

---

## Escalation Procedures

### 7.1 Escalation Levels

```
Level 1: Peer agents (direct resolution)
Level 2: Category lead (e.g., engineering-lead, security-lead)
Level 3: Orchestrator (multi-agent-coordinator, project-shipper)
Level 4: Human-in-the-loop (user notification)
```

### 7.2 When to Escalate

- Conflict unresolved after 2 peer attempts
- Task blocked > 30 minutes without resolution
- Security/compliance concern identified
- User explicitly requests escalation

### 7.3 Escalation Message Template

```
[ESCALATION]
Level: <1-4>
Issue: <concise description>
Impact: <user/task/system>
Attempts: <summary of resolution efforts>
Requested Action: <specific ask>
Context: <reference IDs>
```

---

## Documentation Standards

### 8.1 Collaborative Artifacts

All multi-agent outputs should include:

```markdown
---
collaboration:
  agents: [agent-1, agent-2, ...]
  roles: 
    agent-1: <primary responsibility>
    agent-2: <primary responsibility>
  handoffs: 
    - from: agent-1, to: agent-2, at: <timestamp>, reason: <why>
  decisions:
    - topic: <what>, consensus: <how reached>, timestamp: <when>
---
```

### 8.2 Session Summaries

At session end, designated agent (`studio-producer` or `project-shipper`) generates:

- Executive summary of outcomes
- List of agents involved and contributions
- Open items and recommended next steps
- Lessons learned for future collaborations

### 8.3 Continuous Improvement

- Monthly review of collaboration metrics
- Update rules based on observed friction points
- Solicit feedback from all agent categories
- Version control this document with change log

---

## Appendix: Quick Reference

### Emergency Stop Protocol

If an agent detects harmful, unethical, or catastrophic output:

1. Immediately tag `[HALT-ALL]` in shared context
2. Notify all active agents in the session
3. Preserve state for audit
4. Escalate to Level 4 (human review)

### Onboarding New Agents

1. Review this document and acknowledge understanding
2. Complete compatibility test with `skill-check`
3. Shadow 3 collaborative sessions before independent operation
4. Register capabilities in `agent-categories/` index

### Glossary

| Term              | Definition                                               |
| ----------------- | -------------------------------------------------------- |
| **Handoff**       | Transfer of task ownership between agents                |
| **Consensus**     | Agreement reached by ≥2 agents on a decision             |
| **Context Block** | Structured, shareable unit of information                |
| **Orchestrator**  | Agent responsible for coordinating multi-agent workflows |

---

> ℹ️ **Note**: These rules are living guidelines. Propose amendments via the `skill-improver` agent with rationale and expected impact.

---

This `collaboration-rules.md` document provides a comprehensive framework for how AI agents within the Maxim ecosystem should work together. It covers:

🔹 **Communication standards** with structured message formats  
🔹 **Task handoff protocols** to ensure smooth delegation  
🔹 **Conflict resolution** workflows for disagreements  
🔹 **Context sharing** guidelines balancing transparency with security  
🔹 **Quality assurance** processes including peer review triggers  
🔹 **Escalation paths** when issues can't be resolved at the peer level  
🔹 **Documentation requirements** for traceability and continuous improvement

The document is designed to be:

- **Actionable**: Clear checklists and templates agents can follow
- **Scalable**: Works for 2-agent collaborations or complex multi-agent workflows
- **Adaptable**: Includes a process for updating the rules themselves
