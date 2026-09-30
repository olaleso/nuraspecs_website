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
Write-Host "1. Checking Cloudflare login..." -ForegroundColor Cyan
& npx.cmd wrangler whoami
if ($LASTEXITCODE -ne 0) { throw "Cloudflare authentication failed. Run: npx.cmd wrangler login" }
Write-Host "2. Checking existing Pages projects..." -ForegroundColor Cyan
& npx.cmd wrangler pages project list
if ($LASTEXITCODE -ne 0) { throw "Unable to list Pages projects." }
Write-Host "3. Target project: $ProjectName | branch: staging | local site: $sitePath" -ForegroundColor Yellow
Write-Host "This action does not configure DNS or alter the public domain." -ForegroundColor Yellow
$answer = Read-Host "Confirm the project exists in YOUR account (type PREVIEW)"
if ($answer -cne "PREVIEW") { throw "Cancelled." }
Write-Host "4. Uploading to Pages PREVIEW branch..." -ForegroundColor Cyan
# Use the Windows npx.cmd shim instead of npx.ps1 (affected in some PowerShell / nvm setups).
& npx.cmd wrangler pages deploy "$sitePath" --project-name "$ProjectName" --branch staging
if ($LASTEXITCODE -ne 0) { throw "Preview deployment failed. No DNS settings were intentionally changed." }
Write-Host "Preview uploaded. Review the deployment URL and staging branch alias." -ForegroundColor Green
