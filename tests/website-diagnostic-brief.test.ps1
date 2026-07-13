$page = Join-Path $PSScriptRoot '..\ui-audit\index.html'
$content = Get-Content -LiteralPath $page -Raw -Encoding utf8

$requiredMarkers = @(
  'Website Diagnostic Brief',
  'Independent website diagnosis',
  'Observed evidence',
  'Priority 01',
  'Conversion path',
  'Next 14 days',
  'Kemari Blakemore'
)

foreach ($marker in $requiredMarkers) {
  if ($content -notmatch [regex]::Escape($marker)) {
    throw "Missing diagnostic marker: $marker"
  }
}

if ($content -match 'Concept Case') {
  throw 'Diagnostic brief must not be presented as a concept case.'
}

Write-Output 'website-diagnostic-brief=pass'
