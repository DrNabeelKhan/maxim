# AI Media Generation — Camera Movement Vocabulary

Quick reference for camera movements, angles, and shot sizes used in AI video prompts. Full vocabulary sourced from `community-packs/higgsfield-ai-prompts/vocab.md`.

---

## Camera Movements

### Linear
| Movement | Description | Emotional Effect |
|---|---|---|
| **Dolly In / Out** | Smooth track toward or away from subject | Intimacy (in) / isolation (out) |
| **Dolly Left / Right** | Smooth lateral track | Reveals, follow action |
| **Dolly Zoom** | Simultaneous dolly + counter-zoom (Hitchcock/Vertigo effect) | Disorientation, realization |
| **Super Dolly In / Out** | Exaggerated fast dolly | Dramatic emphasis |
| **Truck** | Lateral dolly movement (alternate term) | Parallel following |

### Vertical
| Movement | Description | Emotional Effect |
|---|---|---|
| **Crane Up / Down** | Vertical rise or descent | Reveal (up) / focus (down) |
| **Crane Over The Head** | Directly overhead, top-down | God's-eye perspective |
| **Levitation** | Smooth dreamlike float upward | Transcendence, fantasy |
| **Tilt Up / Down** | Camera rotates on horizontal axis (no physical movement) | Scanning, reveal |

### Orbit / Arc
| Movement | Description | Emotional Effect |
|---|---|---|
| **360 Orbit** | Complete circle around subject | Power, grandeur, hero moment |
| **Arc** | Semi-circular sweep | Dramatic tension, character study |
| **Lazy Susan** | Slow turntable rotation | Product showcase, contemplation |
| **Robo Arm** | Precision mechanical arc path | Technical, product, commercial |

### Zoom
| Movement | Description | Emotional Effect |
|---|---|---|
| **Crash Zoom In / Out** | Rapid sudden zoom | Shock, emphasis, comedy |
| **Rack Focus** | Refocus between near and far subjects | Shifting attention, revelation |

### Follow / Immersive
| Movement | Description | Emotional Effect |
|---|---|---|
| **Action Run** | Low follow behind running subject | Chase energy, urgency |
| **FPV Drone** | Fast agile aerial weaving | Adrenaline, exploration |
| **Handheld** | Organic shaky realistic movement | Documentary, raw emotion |
| **Head Tracking** | Locked to character's head | Intimacy, POV-adjacent |
| **Snorricam** | Mounted on actor, background sways | Disorientation, intoxication |

### Cinematic Techniques
| Movement | Description | Emotional Effect |
|---|---|---|
| **Bullet Time** | Slow-motion sweep around frozen subject | Iconic moments, peak action |
| **Dutch Angle** | Tilted diagonal composition | Unease, tension, madness |
| **Fisheye** | Wide distortion lens | Surreal, music video, skate |
| **Whip Pan** | Fast blur pan | Transition, energy, surprise |
| **Overhead** | Direct top-down | Patterns, scale, detachment |
| **Flying** | Free-floating aerial glide | Freedom, establishing shots |

### Time-Based
| Movement | Description | Emotional Effect |
|---|---|---|
| **Hyperlapse** | Moving camera + time-lapse | Journey, transformation |
| **Timelapse** | Fixed camera, fast-forward time | Passage of time, scale |
| **Low Shutter** | Motion blur from slow shutter speed | Dreamlike, ghostly |

---

## Camera Angles

| Angle | Frame | Effect |
|---|---|---|
| **Low Angle** | Camera looks up at subject | Power, dominance, heroism |
| **High Angle** | Camera looks down at subject | Vulnerability, smallness |
| **Eye Level** | Neutral, conversational | Equality, naturalism |
| **Bird's-Eye View** | Directly overhead | God's-eye, patterns, scale |
| **Worm's-Eye View** | Extreme low, looking straight up | Extreme power, monumentality |
| **Ground Level** | Camera on the ground surface | Gritty, intimate with terrain |
| **Dutch Tilt** | Tilted horizon for unease | Tension, psychological disturbance |
| **Over-the-Shoulder (OTS)** | Conversation framing | Dialogue, relationship |
| **POV / First Person** | Camera IS the character's eyes | Immersion, horror, action |

---

## Shot Sizes

| Shot | Frame Content | Use |
|---|---|---|
| **Extreme Long Shot (ELS)** | Vast landscape, subject tiny or absent | Establishing, isolation |
| **Wide Shot (WS)** | Full body + surroundings | Context, choreography |
| **Medium Long / Cowboy (MLS)** | Mid-thigh up | Western, readiness |
| **Medium (MS)** | Waist up | Conversation, general |
| **Medium Close-Up (MCU)** | Chest up | Emotion + context |
| **Close-Up (CU)** | Face | Emotion, reaction |
| **Extreme Close-Up (ECU)** | Detail — eyes, hands, object | Tension, detail, texture |
| **Insert Shot** | Detail of an object or action | Storytelling beat |
| **Two-Shot** | Two characters in frame | Relationship, dialogue |

---

## Cut & Continuity Rules

- **Double contrast:** Every cut changes BOTH shot size AND camera character (handheld / static / stabilized / crane / aerial)
- **180-degree rule:** Keep camera on one side of the line between subjects to preserve screen direction
- **Exit-frame rule:** Once a character leaves frame, they are gone for that shot — no re-entry in the same continuous shot
- **Match cut:** Cut between two shots linked by shape, motion, or composition
- **Whip-pan transition:** Blur pan bridges two shots as a single motion
- **L-cut / J-cut:** Audio from next shot leads picture (J) or trails (L)

---

## Prompt Usage

Always name the camera movement explicitly in prompts. Use the exact vocabulary above.

Good: `Camera: slow Dolly In from medium-wide to medium close-up.`
Bad: `Camera moves dramatically toward the subject.`

Good: `Camera: FPV Drone sweeping through the corridor.`
Bad: `Fast exciting camera movement through the space.`
