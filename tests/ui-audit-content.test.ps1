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

$audit = Get-Content -Raw $auditFile -Encoding utf8
Assert-Contains $audit 'Website Diagnostic Brief' 'diagnostic brief heading'
Assert-Contains $audit 'Observed evidence' 'evidence section'
Assert-Contains $audit 'Conversion path' 'conversion path section'
Assert-Contains $audit 'Next 14 days' 'action plan section'
Assert-Contains $audit 'Fictional B2B example' 'honesty note'
Assert-Contains $audit 'assets/diagnostic-evidence-v2.png' 'neutral B2B evidence asset'
Assert-Contains $audit 'mailto:kemariblakemore734@gmail.com' 'email contact route'

if ($audit -match 'interior design|hospitality owner|residential client|Concept Case') {
  throw 'The diagnostic sample includes a prohibited legacy design-industry reference.'
}

Write-Host 'UI diagnostic content checks passed.'
