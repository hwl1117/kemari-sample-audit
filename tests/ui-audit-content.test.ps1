$ErrorActionPreference = 'Stop'

function Assert-Contains {
  param([string]$Content, [string]$Needle, [string]$Label)

  if ($Content -notmatch [regex]::Escape($Needle)) {
    throw "Missing ${Label}: $Needle"
  }
}

$siteRoot = Split-Path -Parent $PSScriptRoot
$auditFile = Join-Path $siteRoot 'ui-audit\index.html'
if (-not (Test-Path $auditFile)) {
  throw "Missing UI audit page: $auditFile"
}

$audit = Get-Content -Raw $auditFile
Assert-Contains $audit 'Audit Framework' 'audit framework section'
Assert-Contains $audit 'What the paid review includes' 'paid deliverables section'
Assert-Contains $audit 'Independent concept work' 'honesty note'
Assert-Contains $audit 'View concept UI cases' 'portfolio navigation'
Assert-Contains $audit 'mailto:kemariblakemore734@gmail.com' 'email contact route'

Write-Host 'UI audit content checks passed.'
