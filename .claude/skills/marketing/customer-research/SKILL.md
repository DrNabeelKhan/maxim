---
skill_id: marketing-customer-research
name: Customer Research
version: 1.0.0
parent: marketing
office: CMO
reads_first: MARKETING-CONTEXT.md
triggers:
  - customer research
  - user interviews
  - survey
  - NPS
  - feedback analysis
  - voice of customer
  - VOC
  - jobs to be done
  - JTBD
  - customer discovery
---

# Customer Research

> **Before starting:** Read `MARKETING-CONTEXT.md` in this domain for product, ICP, and positioning context.

## What This Skill Does

Designs and executes customer research programs that produce actionable insights -- not just data. Covers interview protocol design, survey creation, feedback synthesis, and jobs-to-be-done analysis. Every research output feeds directly into positioning, copy, product decisions, and growth strategy. Applies behavioral science to research design (reducing bias, improving signal quality).

## Key Questions to Ask

1. What decision will this research inform? (positioning, feature priority, churn diagnosis, pricing)
2. What do we already know vs. what are we assuming?
3. Who should we talk to? (current users, churned users, prospects, non-users)
4. What is the timeline and budget for research?
5. What existing data sources are available? (support tickets, reviews, NPS scores, analytics)

## Framework / Approach

### Jobs-to-be-Done Interview Protocol (Primary)

JTBD interviews uncover the causal mechanisms behind purchase/adoption decisions:

1. **Recruit the right people** -- Recent switchers (adopted your product in last 90 days) or recent churners
2. **The Timeline Interview** (45-60 minutes):
   - **First thought** -- When did you first realize you needed something different?
   - **Passive looking** -- What alternatives did you consider passively?
   - **Active looking** -- What triggered you to start actively searching?
   - **Decision** -- What made you choose [product]? What almost stopped you?
   - **Consumption** -- How did the first experience match expectations?
   - **Satisfaction** -- What would make you switch again?
3. **Forces of Progress Analysis**:
   - **Push** -- Dissatisfaction with current solution
   - **Pull** -- Attraction to new solution
   - **Anxiety** -- Fear of change, risk, learning curve
   - **Habit** -- Comfort with status quo
4. **Extract**:
   - Job statements: "When I [situation], I want to [motivation], so I can [outcome]"
   - Hiring criteria: What made them "hire" your product
   - Firing criteria: What would make them "fire" it

### Survey Design Protocol

1. **Define the objective** -- One survey, one objective
2. **Question types**:
   - **Sean Ellis test** -- "How would you feel if you could no longer use [product]?" (Very disappointed / Somewhat / Not disappointed)
   - **NPS** -- "How likely are you to recommend [product]?" (0-10)
   - **CES** -- "How easy was it to [task]?" (1-7)
   - **Open-ended** -- "What is the primary benefit you get from [product]?"
3. **Design principles**:
   - 5-10 questions maximum (completion drops 20% per additional question)
   - No leading questions, no double-barreled questions
   - Randomize option order for multiple choice
   - Include "Other" with text field
   - Test with 5 people before sending to full list
4. **Sample size** -- 100+ responses for quantitative significance; 15-20 for qualitative themes

### Feedback Synthesis Framework

1. **Collect** from all sources: interviews, surveys, support tickets, reviews, social mentions, sales call recordings
2. **Tag** each insight by:
   - Theme (feature request, pain point, praise, confusion)
   - Segment (ICP, plan tier, tenure, acquisition channel)
   - Frequency (how often this theme appears)
   - Intensity (how strongly people feel about it)
3. **Prioritize** using the Frequency x Intensity matrix:
   - High frequency + high intensity = urgent action
   - High frequency + low intensity = quality-of-life improvement
   - Low frequency + high intensity = niche but critical
   - Low frequency + low intensity = monitor
4. **Distribute** findings to relevant teams with specific, actionable recommendations

## Output Format

```markdown
## Customer Research Report: [Research Name]

### Objective
[What decision this research informs]

### Methodology
- Method: [interviews / survey / feedback analysis / mixed]
- Sample: [N participants, segment description]
- Period: [dates]

### Key Findings

#### Finding 1: [Headline]
- **Evidence:** [quote, data point, frequency]
- **Implication:** [what this means for the business]
- **Recommendation:** [specific action to take]

#### Finding 2: [Headline]
...

### Jobs-to-be-Done (if applicable)
| Job Statement | Frequency | Current Solution | Opportunity |
|---|---|---|---|
| When I [situation], I want to [motivation], so I can [outcome] | [N mentions] | [what they use now] | [how we can serve this better] |

### Feedback Themes
| Theme | Frequency | Intensity | Segment | Priority |
|---|---|---|---|---|
| [theme] | [count] | [H/M/L] | [who] | [urgent/monitor/improve] |

### Recommended Actions
| Action | Informed By | Owner | Timeline |
|---|---|---|---|
| [action] | [finding #] | [team] | [when] |
```

## Related Skills
- `positioning` -- research validates and refines positioning
- `growth-retention` -- churn research informs retention strategy
- `cro` -- user insights inform conversion hypotheses
- `copywriting` -- voice-of-customer language for copy
- `content-strategy` -- topic validation from customer questions

---
_Copyright (c) 2026 iSystematic Inc. Maxim product. BSL 1.1._
