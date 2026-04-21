# [Maxim-OVERLAY] — injected by bootstrap/new-project-setup.sh
if (Test-Path "config/project-manifest.json") {
  $manifest = Get-Content "config/project-manifest.json" -Raw | ConvertFrom-Json -ErrorAction SilentlyContinue
  if ($manifest) {
    Write-Output "[Maxim] Project: $($manifest.project.id) | Model: $($manifest.tech_stack.default_model_provider)"
  }
}
Write-Output "[Maxim] Dispatch: 1) .claude/skills/ -> 2) community-packs/claude-skills-library/ -> 3) composable-skills/ -> 4) agents/ -> 5) behavioral layer"
if (Test-Path ".mxm-skills/agents-handoff.md") {
  $handoff = Get-Content ".mxm-skills/agents-handoff.md" -Raw
  if ($handoff -match 'status: "(BLOCKED|FAILED|PARTIAL)"') {
    Write-Output "[Maxim] !!  HANDOFF $($Matches[1]) — check .mxm-skills/agents-handoff.md before proceeding"
  }
}
# planning-with-files: User prompt submit hook for Cursor (PowerShell)
# Injects plan context on every user message.
# Critical for session recovery after /clear — dumps actual content, not just advice.

if (Test-Path "task_plan.md") {
    Write-Output "[planning-with-files] ACTIVE PLAN — current state:"
    Get-Content "task_plan.md" -TotalCount 50 -Encoding UTF8
    Write-Output ""
    Write-Output "=== recent progress ==="
    if (Test-Path "progress.md") {
        Get-Content "progress.md" -Tail 20 -Encoding UTF8
    }
    Write-Output ""
    Write-Output "[planning-with-files] Read findings.md for research context. Continue from the current phase."
}
exit 0
