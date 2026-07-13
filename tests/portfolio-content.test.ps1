$ErrorActionPreference = 'Stop'

$siteRoot = Split-Path -Parent $PSScriptRoot
$portfolioRoot = Join-Path $siteRoot 'portfolio'
$caseSlugs = @('nocturne', 'signal', 'kinfolk')

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

foreach ($slug in $caseSlugs) {
  Assert-Contains $portfolio "./$slug/" "portfolio link for $slug"

  $caseFile = Join-Path (Join-Path $portfolioRoot $slug) 'index.html'
  if (-not (Test-Path $caseFile)) {
    throw "Missing case page: $caseFile"
  }

  $case = Get-Content -Raw $caseFile
  Assert-Contains $case 'Concept UI Case Study' "concept label in $slug"
  Assert-Contains $case 'Kemari Blakemore' "designer name in $slug"
  Assert-Contains $case 'Design Direction' "design direction section in $slug"
  Assert-Contains $case 'Selected Screens' "selected screens section in $slug"
  Assert-Contains $case 'Project brief' "project brief in $slug"
  Assert-Contains $case 'Independent concept work' "honesty note in $slug"
  Assert-Contains $case 'mailto:kemariblakemore734@gmail.com' "contact route in $slug"
}

Write-Host "Portfolio content checks passed for $($caseSlugs.Count) concept cases."
