param([string]$ProjectName = "nuraspecs-cinematic")
$ErrorActionPreference = "Stop"
Set-Location $PSScriptRoot
$sitePath = Join-Path $PSScriptRoot "site"
if (-not (Test-Path (Join-Path $sitePath "index.html"))) {
    throw "Expected site/index.html next to this script. Extract the full website package before deploying."
}
if (-not (Get-Command npx.cmd -ErrorAction SilentlyContinue)) {
    throw "npx.cmd was not found. Confirm Node.js is installed and npx is on PATH."
}
Write-Host "This publishes to the PRODUCTION branch (main) for $ProjectName." -ForegroundColor Yellow
Write-Host "Publishing will update any domain ALREADY attached to this project." -ForegroundColor Yellow
Write-Host "It does not change DNS or attach your existing domain." -ForegroundColor Yellow
Write-Host "Only continue after checking staging, approved branding, privacy and contact links." -ForegroundColor Yellow
$answer = Read-Host "To proceed, type RELEASE"
if ($answer -cne "RELEASE") { throw "Cancelled." }
& npx.cmd wrangler pages deploy "$sitePath" --project-name "$ProjectName" --branch main
if ($LASTEXITCODE -ne 0) { throw "Production deployment failed. Do not cut over the custom domain." }
Write-Host "Production uploaded. Verify the Pages URL before any DNS/custom-domain change." -ForegroundColor Green
