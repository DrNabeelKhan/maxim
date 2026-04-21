# Maxim — BSL License FAQ

> Copyright (c) 2026 iSystematic Inc. Maxim product. BSL 1.1 licensed.

The Business Source License 1.1 is source-available, not open source. This FAQ answers the eight questions most new readers ask about what they can and cannot do with Maxim under BSL.

---

### 1. Can I use Maxim commercially?

**Yes, for most use cases.** The Additional Use Grant in LICENSE permits production use for internal tooling, client engagements, research, education, commercial services that integrate Maxim, and forking for internal use.

The one exception is offering a competing pack catalog or a competing behavioral intelligence framework on a paid basis to third parties. That is what BSL restricts until the Change Date.

### 2. When does Maxim become Apache 2.0?

**Four years after each version is first publicly distributed.** Each version has its own Change Date. Maxim v1.0.0 (released 2026-04-21) becomes Apache 2.0 on 2030-04-21. Maxim v1.1.0 has its own four-year clock.

This is a promise in the license, not a marketing line. After the Change Date, the version converts automatically.

### 3. Can I fork Maxim?

**Yes.** Forking for internal use is explicitly permitted. Redistributing modified copies is also permitted, provided Maxim is not the primary commercial offering of the redistribution.

### 4. Can I resell or rebrand Maxim as my own product?

**No, not during the BSL period.** Reselling Maxim or rebranding it as a competing behavioral intelligence framework is the specific case BSL prevents. After the Change Date, this restriction lifts.

### 5. Are the paid packs covered by BSL?

**No.** Commercial pack content (L1, L2, L3 packs) is separately licensed per-purchase via Stripe and remains proprietary. The packs are not source-available under BSL — they are commercial content under their own license terms. See `documents/guides/PACKS.md`.

### 6. Can I contribute a PR?

**Yes.** Contributions to the core framework are welcome under the standard contributor agreement in `CONTRIBUTING.md`. Your contribution is BSL-licensed along with the rest of the core.

Community-authored packs (ADR-008) are separate: they ship under whatever license the pack author chooses. See `CONTRIBUTING.md` § Community Packs.

### 7. Is BSL OSI-approved?

**No.** The Open Source Initiative has not approved BSL 1.1 because it restricts certain commercial uses. BSL is "source-available" — you can read the source, modify it, and use it under the terms — but it is not open source in the OSI sense until the Change Date (when it becomes Apache 2.0).

### 8. Who can I contact for commercial licensing alternatives?

**`https://maxim.isystematic.com/contact`**. If your use case does not fit the Additional Use Grant and you need a custom license, reach out. The same address handles BSL interpretation questions.

---
Copyright (c) 2026 iSystematic Inc. Maxim is a product of iSystematic Inc.
Licensed under Business Source License 1.1 (converts to Apache 2.0 after 4 years per ADR-005).
