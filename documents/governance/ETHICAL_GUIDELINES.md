# ⚖️ Ethical Guidelines for Behavior Science & Persuasion

> Copyright (c) 2026 iSystematic Inc. Maxim product. BSL 1.1 licensed.


**Responsible Use of Influence and Behavior Change Techniques**

---

## 🎯 Purpose

This document establishes ethical guidelines for using behavior science and persuasion techniques within the AI Agent Directory. These frameworks are powerful tools that must be used responsibly.

---

## 📜 Core Ethical Principles

### 1. Transparency

- **BE CLEAR** about intentions and desired outcomes
- **DISCLOSE** when persuasion techniques are being used
- **AVOID** hidden manipulation or deception

### 2. Beneficence

- **DESIGN** for user benefit, not just business metrics
- **PRIORITIZE** user wellbeing over conversion rates
- **MEASURE** positive outcomes, not just engagement

### 3. Autonomy

- **PRESERVE** user choice and control
- **PROVIDE** clear opt-out mechanisms
- **RESPECT** informed consent

### 4. Justice

- **AVOID** exploiting vulnerable populations
- **ENSURE** fair treatment across user groups
- **CONSIDER** societal impact of behavior change

### 5. Accountability

- **DOCUMENT** ethical decisions and rationale
- **MEASURE** and report on ethical outcomes
- **REVIEW** and update practices regularly

---

## 🚫 Dark Patterns to Avoid

| Dark Pattern                    | Description                         | Why It's Harmful              |
| ------------------------------- | ----------------------------------- | ----------------------------- |
| **Hidden Costs**                | Fees revealed late in process       | Violates trust, wastes time   |
| **Forced Continuity**           | Hard to cancel subscriptions        | Traps users, removes autonomy |
| **Misdirection**                | Visual tricks to guide clicks       | Deceptive, manipulative       |
| **Privacy Zuckering**           | Tricking into sharing data          | Violates privacy, consent     |
| **Confirm Shaming**             | Guilt-tripping opt-outs             | Emotional manipulation        |
| **Roach Motel**                 | Easy in, hard out                   | Removes user control          |
| **Price Comparison Prevention** | Hiding better options               | Prevents informed decisions   |
| **Bait and Switch**             | Unexpected changes after commitment | Breaks trust                  |
| **False Scarcity**              | Fake urgency or limits              | Manipulative, deceptive       |
| **Hidden Subscription**         | Auto-enroll without clear consent   | Violates autonomy             |

---

## ✅ Ethical Persuasion Checklist

Before deploying any persuasion technique, ask:

- [ ] Is this transparent to the user?
- [ ] Does this benefit the user, not just the business?
- [ ] Can the user easily opt out?
- [ ] Am I exploiting any vulnerabilities?
- [ ] Would I be comfortable if this was done to me?
- [ ] Does this respect user autonomy?
- [ ] Have I disclosed the intention?
- [ ] Is the scarcity/urgency real?
- [ ] Are social proof claims accurate?
- [ ] Would this pass an ethics review?

---

## 📋 Framework-Specific Guidelines

### Cialdini's Principles

| Principle    | Ethical Use               | Unethical Use                    |
| ------------ | ------------------------- | -------------------------------- |
| Reciprocity  | Give genuine value first  | Create obligation through tricks |
| Scarcity     | Real limited availability | Fake urgency or limits           |
| Authority    | Legitimate credentials    | Fake experts or endorsements     |
| Consistency  | Honor past commitments    | Trap users in commitments        |
| Liking       | Build genuine rapport     | Manipulate through flattery      |
| Social Proof | Accurate user data        | Fake reviews or counts           |

### Nudge Theory

| Guideline        | Implementation                     |
| ---------------- | ---------------------------------- |
| Preserve Freedom | Always allow opt-out               |
| Transparency     | Disclose nudges when asked         |
| User Benefit     | Nudge toward user's best interest  |
| Avoid Sludge     | Don't add friction to good choices |

### Hook Model

| Guideline      | Implementation                              |
| -------------- | ------------------------------------------- |
| Healthy Habits | Build positive habits, not addiction        |
| User Control   | Allow breaks and disengagement              |
| Value Creation | Provide genuine value, not empty engagement |
| Transparency   | Be clear about engagement design            |

---

## 🏢 Organizational Implementation

### Ethics Review Process

1. **Proposal** - Document intended behavior change
2. **Assessment** - Evaluate against ethical principles
3. **Approval** - Get ethics committee sign-off
4. **Implementation** - Deploy with monitoring
5. **Review** - Regular ethics audits

### Red Flags Requiring Review

- Targeting vulnerable populations
- Hidden or deceptive practices
- Difficulty opting out
- Potential for addiction or harm
- Significant financial impact on users
- Privacy implications

### Documentation Requirements

- Ethical rationale for each technique
- User benefit analysis
- Opt-out mechanism description
- Monitoring and metrics plan
- Review schedule

---

## 📞 Reporting Concerns

If you identify unethical use of behavior science techniques:

1. **Document** the specific concern
2. **Report** to ethics committee or leadership
3. **Escalate** if not addressed appropriately
4. **Protect** whistleblowers from retaliation

---

## 📚 Resources

- [Dark Patterns](https://www.darkpatterns.org/)
- [Ethical Design Handbook](https://ethicaldesignhandbook.com/)
- [Centre for Humane Technology](https://www.humanetech.com/)
- [Behavioral Ethics Research](https://behavioralethics.org/)

---

**Version:** 1.0
**Last Updated:** March 1st, 2026
**Review Schedule:** Quarterly

---

## Super User Mode

When `super_user.enabled = true` in `config/project-manifest.json`, the following
Maxim-level governance gates are suppressed for the declared identity:

| Gate | Default | Super User |
|---|---|---|
| CSO auto-loop on security/compliance signals | Active | Suppressed |
| `ethics_required` agent pre-checks | Active | Suppressed |
| Compliance framework pre-enforcement | Active | Suppressed |
| `escalation_required` flags | Active | Suppressed |
| Confidence tagging | Active | Configurable |

### What Remains Active

The following are **not affected** by super_user mode and cannot be suppressed:

- Claude's own core values and judgment
- `.mxm-skills/agents-skill-gaps.log` monitoring (non-blocking, observation only)
- Output tagging: all super user outputs are tagged 🔵 SUPER USER

### Output Tag

| Tag | Meaning |
|---|---|
| 🔵 SUPER USER | Maxim governance gates suppressed — operating under super_user mode |

### Configuration

Set in `config/project-manifest.json`:
```json
"super_user": {
  "enabled": true,
  "identity": "your-identity"
}
```

> **Note:** `CLAUDE.md` is the universal Maxim operating standard and is never edited
> per permanent policy. Super user dispatch rules are declared in `CLAUDE.md` and
> read from `project-manifest.json` at runtime.
