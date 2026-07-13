$ErrorActionPreference = 'Stop'

$siteRoot = Split-Path -Parent $PSScriptRoot
$portfolioRoot = Join-Path $siteRoot 'portfolio'
$caseSlugs = @('nocturne', 'signal', 'kinfolk')
$caseExperiences = @{
  nocturne = @('data-product-option', 'data-collection-button', 'gallery-stage')
  signal = @('data-system-mode', 'signal-console', 'scanline')
  kinfolk = @('data-day-filter', 'booking-drawer', 'programme-grid')
}

function Assert-Contains {
  param([string]$Content, [string]$Needle, [string]$Label)

  if ($Content -notmatch [regex]::Escape($Needle)) {
    throw "Missing ${Label}: $Needle"
  }
}

$portfolioFile = Join-Path $portfolioRoot 'index.html'
if (-not (Test-Path $portfolioFile)) {
  throw "Missing portfolio entry page: $portfolioFile"
}

$portfolio = Get-Content -Raw $portfolioFile
Assert-Contains $portfolio 'Concept UI Cases' 'portfolio heading'
Assert-Contains $portfolio 'Kemari Blakemore' 'designer name'
Assert-Contains $portfolio 'Independent concept work' 'portfolio honesty note'
Assert-Contains $portfolio 'Website UI Designer' 'portfolio role'
Assert-Contains $portfolio 'max-width:1050px' 'wide desktop portfolio heading'
Assert-Contains $portfolio 'padding:72px 0 34px' 'compact portfolio hero spacing'

foreach ($slug in $caseSlugs) {
  Assert-Contains $portfolio "./$slug/" "portfolio link for $slug"

  $caseFile = Join-Path (Join-Path $portfolioRoot $slug) 'index.html'
  if (-not (Test-Path $caseFile)) {
    throw "Missing case page: $caseFile"
  }

  $case = Get-Content -Raw $caseFile
  Assert-Contains $case 'Concept UI Case Study' "concept label in $slug"
  Assert-Contains $case 'Kemari Blakemore' "designer name in $slug"
  Assert-Contains $case 'Independent concept work' "honesty note in $slug"
  Assert-Contains $case 'mailto:kemariblakemore734@gmail.com' "contact route in $slug"

  foreach ($experienceMarker in $caseExperiences[$slug]) {
    Assert-Contains $case $experienceMarker "distinct experience marker $experienceMarker in $slug"
  }
}

Write-Host "Portfolio content checks passed for $($caseSlugs.Count) concept cases."
