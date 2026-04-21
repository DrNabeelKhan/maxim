# AI Media Generation — Prompt Formula Reference

The core prompt structures for AI video and image generation. These formulas ensure consistent, high-quality prompt output across all styles and platforms.

---

## Video Prompt Formula: MCSLA

Every video prompt follows the **MCSLA** structure:

```
M — Model selection
C — Camera movement
S — Subject description
L — Look (style, lighting, color grade)
A — Action (what happens, what changes)
```

### Template

```
Model: [model name]
Aspect: [ratio] | Duration: [seconds] | Style: [named style]

[Subject description — WHO/WHAT is in frame, observable details only]
[Environment — WHERE, with specific visual details]
Camera: [Named movement] — [specific direction and behavior]
[Action — WHAT HAPPENS, active verbs, timed if possible]
Style: [Named style]. [Color grade]. [Lighting]. [Aspect ratio].
```

### Rules

1. **Name the model explicitly** — Kling 3.0, Sora 2, Veo 3.1, Wan 2.7, Seedance 2.0, etc.
2. **One camera movement per shot** — never stack contradictory movements (no "FPV Drone while orbiting while crash zooming")
3. **Observable details only** — everything must pass the "can a camera see/measure this?" test
4. **Active verbs for action** — "sprints," "slides," "erupts," not "beautifully moves"
5. **No slop words** — ban "stunning," "breathtaking," "epic masterpiece," "ultra-realistic 8K," "award-winning." These are unmeasurable and the model cannot act on them.
6. **Explicit color grade** — name the palette (teal/orange blockbuster, cold blue thriller, warm amber nostalgia)
7. **Explicit lighting** — name the source and quality (golden hour, single side-light, neon, volumetric fog)

### Example (Good)

```
Model: Kling 3.0
Aspect: 16:9 | Duration: 8s | Style: Cinematic

A weathered detective stands at the edge of a rain-soaked harbour dock at night.
An old leather briefcase sits at his feet, open, papers scattered by the wind.
He stares at the horizon, collar turned up against the driving rain.
Harbour lights fracture on the black water below.
Camera: slow Dolly In from medium-wide to medium close-up.
Style: Cinematic. Crushed blacks, single sodium-vapour key light from the right,
cold blue fill, 2.35:1 anamorphic.
```

### Anti-Patterns (Bad)

```
# BAD: Slop words, no camera, no style spec
An epic cinematic masterpiece shot of a stunning detective in a breathtaking
noir setting. Ultra-realistic 8K quality. Award-winning cinematography.

# BAD: Camera soup — contradictory movements
Camera does a dramatic FPV drone shot while also orbiting the subject
and then crash zooming into their face with a dolly zoom effect.

# BAD: Describing what the image already shows (for image-to-video)
A beautiful woman with long dark hair and brown eyes wearing a red silk dress
is standing on a balcony with a city behind her at sunset.
```

---

## Image Prompt Formula

For still image generation, use this structure:

```
[Shot size] + [Angle] + [Movement keyword] of [character/subject].
[Pose].
[Environment].
[Lighting].
[Style].
```

### Template

```
Model: [model name]
Aspect: [ratio] | Style: [named style]

[Shot size] [Angle] [Movement keyword] of [subject with specific details].
[Pose — body position, expression, hands, gaze].
[Environment — location with tangible visual details].
[Lighting — named source, quality, direction, color].
[Style — named look, film stock, color grade, resolution].
```

### Example

```
Model: Nano Banana Pro
Aspect: 16:9 | Style: Cinematic

Medium Close-Up (MCU) Low Angle Dolly Zoom of a weathered space pilot in a cracked visor.
Staring intensely off-camera, jaw clenched.
The sparking, smoke-filled cockpit of a crashing starfighter.
Flashing red emergency lights, hard side-key illumination.
Photorealistic sci-fi cinematic, ultra-sharp detail.
```

---

## Image-to-Video (I2V) Prompt Formula

When generating video FROM an existing image:

```
Starting from the provided image as the first frame.
[ONLY describe what CHANGES — motion, new elements, transitions]
Camera: [named movement]
[Sound/audio cues if model supports it]
Style: [named style, color grade, lighting changes]
```

### Rules for I2V

1. **NEVER re-describe the image** — the model can already see it
2. **Only describe what changes** — hair moves, eyes shift, light changes, subject acts
3. **Add camera movement** — this is the primary addition
4. **Add audio cues** if the model supports it (Kling 3.0, Wan 2.7)

### Example

```
Starting from the provided image as the first frame.
Her hair lifts gently in the evening breeze. She turns her head slowly to the right,
eyes narrowing slightly as if recognizing someone below.
Camera: slow Dolly In toward her profile.
Wind catches the dress fabric. City lights begin flickering on in the distance.
Style: Cinematic, warm golden hour, shallow depth of field.
```

---

## Audio Integration (for models that support it)

Models with audio support: Kling 3.0, Kling 3.0 Omni, Wan 2.7, Veo 3.1

```
Dialogue: "[Character name]: [spoken line in quotes]"
Ambient: [environmental sounds — specific, not generic]
SFX: [specific sound effects timed to action]
Music: [mood descriptor — not a song name]
```

### Example

```
Dialogue: "I found something — you need to see this."
Ambient: quiet cafe murmur, espresso machine hiss, rain on window.
SFX: cup set down on saucer (0.5s mark).
Music: low tension strings building underneath.
```

---

## Platform-Specific Prompt Additions

Append to any prompt when targeting a specific platform:

**TikTok:** `Format: 9:16 vertical. Hook in first 0.8s. Duration: [15-60]s. Quick cuts.`
**YouTube Shorts:** `Format: 9:16 vertical. Hook in first 2s. Duration: up to 60s.`
**Instagram Reels:** `Format: 9:16 vertical. Aesthetic-first. Duration: [15-90]s.`
**LinkedIn:** `Format: 16:9. Professional tone. Subtitles required. Duration: [30-120]s.`
**YouTube Standard:** `Format: 16:9 cinematic. Hook in 2s. Any duration.`

---

## Prompt Quality Checklist

Before finalizing any prompt, verify:

- [ ] Model is explicitly named
- [ ] Camera movement is a single named preset (not "dramatic" or "cinematic movement")
- [ ] Subject has observable details (clothing, posture, expression — not "beautiful" or "elegant")
- [ ] Environment has tangible visual details (materials, weather, light sources)
- [ ] Color grade is named (not just "cinematic")
- [ ] Lighting source and quality are specified
- [ ] Action uses active verbs
- [ ] No slop words (stunning, breathtaking, masterpiece, ultra-realistic, award-winning)
- [ ] First 2 seconds explicitly addressed for social content
- [ ] Aspect ratio matches target platform
