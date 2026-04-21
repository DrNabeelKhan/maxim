# mxm-compliance

Regulatory compliance reasoning MCP server. Provides compliance verdicts (COMPLIANT / REVIEW / BLOCK), framework-specific requirements, and audit artifact generation.

## Tools

| Tool | Purpose |
|---|---|
| `get_frameworks` | List compliance frameworks applicable to a project from its manifest |
| `check_compliance` | Verdict (COMPLIANT/REVIEW/BLOCK) for a proposed action with PII/PHI/financial scope |
| `get_jurisdiction_requirements` | Requirements for a specific framework (GDPR, PIPEDA, PCI-DSS, SOC2, HIPAA, UAE-PDPL, CASL, FINTRAC) |
| `audit_data_handling` | Classify data fields by sensitivity (PII/PHI/financial/public) and check against project compliance |
| `generate_ropa_entry` | GDPR Record of Processing Activities (RoPA) entry template for a processing activity |

## Frameworks Covered (14)

GDPR · PIPEDA · PCI-DSS · SOC 2 · HIPAA · UAE-PDPL · CASL · FINTRAC · EU AI Act · ISO 27001 · ISO 13485 · ISO 14971 · NIST CSF · WCAG 2.1

## Data Source

Reads framework rules from server's bundled rule library. Reads project compliance scope from `config/project-manifest.json` → `compliance.frameworks[]` and `compliance.per_project[project.id]`.

## Run

```bash
node ./mcp/mxm-compliance/server.js
```

## License

Apache 2.0 (see repository root).
