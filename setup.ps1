# Git101 workshop setup — run in PowerShell:
#   iwr https://raw.githubusercontent.com/iman-izzat/Git101/main/setup.ps1 -UseBasicParsing | iex
# Installs: git, Node LTS, VS Code via winget. Sets git identity.
$ErrorActionPreference = 'Stop'
function ok($m){ Write-Host "  OK  $m" -ForegroundColor Green }
function warn($m){ Write-Host "  !   $m" -ForegroundColor Yellow }
function die($m){ Write-Host "  X   $m" -ForegroundColor Red; exit 1 }

if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
  die "winget not found - update 'App Installer' from the Microsoft Store (comes with Win10/11), or ask IT"
}

# refresh PATH so tools installed by an earlier run are visible now
$env:Path = [Environment]::GetEnvironmentVariable('Path','Machine') + ';' + [Environment]::GetEnvironmentVariable('Path','User')

Write-Host "Installing missing tools (click YES on any UAC popup)..."
$pkgs = @(
  @{ id='Git.Git';                  check='git'  },
  @{ id='OpenJS.NodeJS.LTS';        check='node' },
  @{ id='Microsoft.VisualStudioCode'; check='code' }
)
foreach ($p in $pkgs) {
  if (Get-Command $p.check -ErrorAction SilentlyContinue) { ok "$($p.check) already installed" }
  else {
    Write-Host "-> Installing $($p.id)..."
    winget install --id $p.id -e --accept-source-agreements --accept-package-agreements | Out-Null
    if ($LASTEXITCODE -ne 0) { die "$($p.id) failed to install - ask IT" }
    ok "$($p.id) installed"
  }
}

# tools land on PATH only in new terminals - re-read it so this script can verify now
$env:Path = [Environment]::GetEnvironmentVariable('Path','Machine') + ';' + [Environment]::GetEnvironmentVariable('Path','User')
$gitStd = 'C:\Program Files\Git\cmd'
if (-not (Get-Command git -ErrorAction SilentlyContinue) -and (Test-Path "$gitStd\git.exe")) { $env:Path += ";$gitStd" }

# git identity (shown on every commit; commitlint/semantic-release attribute commits to this)
$name = (& git config --global user.name) 2>$null
$mail = (& git config --global user.email) 2>$null
if ($name -and $mail) { ok "git identity already set: $name <$mail>" }
else {
  Write-Host "-> Set your git identity"
  $name = Read-Host "  Full name"
  if (-not $name) { die "name required" }
  do { $mail = Read-Host "  Email (the one your GitHub account uses)" } while ($mail -notmatch '@')
  git config --global user.name $name
  git config --global user.email $mail
  ok "git identity set: $name <$mail>"
}

Write-Host ""
Write-Host "-- Versions --"
git  --version
node --version
Write-Host ("  npm v" + (npm --version))
Write-Host ""
Write-Host "Done. Still on you (browser - cannot be scripted):"
Write-Host "  1. GitHub account  ->  https://github.com/join"
Write-Host "  2. Fork the repo   ->  https://github.com/iman-izzat/Git101  -> Fork button -> Create fork"
Write-Host "  3. On YOUR fork: Settings -> Actions -> General ->"
Write-Host "       Allow all actions, and Workflow permissions: Read and write"
Write-Host "  4. Clone + install once (PowerShell):"
Write-Host "       git clone https://github.com/YOUR-USERNAME/Git101.git ; cd Git101 ; npm ci"
Write-Host "  5. In-house AI tool -> ask IT for the installer"
