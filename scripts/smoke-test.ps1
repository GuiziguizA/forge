# Forge — lanceur PowerShell du smoke-test.
# Source unique = scripts/smoke-test.sh (les hooks Forge sont en bash). Ce lanceur
# trouve bash (git-bash sous Windows) et délègue. Évite la double-maintenance.
$ErrorActionPreference = 'Stop'
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sh = Join-Path $here 'smoke-test.sh'

$bash = (Get-Command bash -ErrorAction SilentlyContinue).Source
if (-not $bash) {
  foreach ($p in @("$env:ProgramFiles\Git\bin\bash.exe", "$env:ProgramFiles\Git\usr\bin\bash.exe")) {
    if (Test-Path $p) { $bash = $p; break }
  }
}
if (-not $bash) {
  Write-Error "bash introuvable. Les hooks Forge requièrent Git for Windows (git-bash). Installe-le puis relance."
  exit 1
}

& $bash $sh
exit $LASTEXITCODE
