param(
    [string]$Root = "C:\Users\leomi\Documents\0 - JORNADAS PC LOCAL",
    [string]$FolderName = "00 - DOCUMENTAÇÃO CARTORÁRIA",
    [string]$GitHubOwner = "leomioishi",
    [string]$RepoName = "documentacao-cartoraria"
)

$ErrorActionPreference = "Stop"
$baseDir = Join-Path $Root $FolderName
$repoFull = "$GitHubOwner/$RepoName"

Write-Host "== DC | Documentação Cartorária ==" -ForegroundColor Cyan
Write-Host "Destino local: $baseDir"
Write-Host "Destino Cloud:  $repoFull"

# 1. Pré-checks
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    throw "Git não encontrado no PATH."
}
if (-not (Get-Command gh -ErrorAction SilentlyContinue)) {
    throw "GitHub CLI (gh) não encontrado no PATH."
}

# 2. Pasta local
New-Item -ItemType Directory -Force -Path $baseDir | Out-Null
Set-Location $baseDir

$dirs = @(
    "00-livro-de-registro",
    "01-matriculas",
    "02-procedimentos",
    "03-scripts",
    "04-modelos"
)
foreach ($d in $dirs) {
    New-Item -ItemType Directory -Force -Path (Join-Path $baseDir $d) | Out-Null
}

# 3. Copiar conteúdo do pacote se o script estiver sendo executado de uma pasta que os contenha
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$map = @{
    "README.md" = "README.md"
    "LIVRO-DE-REGISTRO.md" = "00-livro-de-registro\LIVRO-DE-REGISTRO.md"
    "PROCEDIMENTO-DC.md" = "02-procedimentos\PROCEDIMENTO-DC.md"
    "MODELO-MINUTA.md" = "04-modelos\MODELO-MINUTA.md"
    "MODELO-ESCRITURA.md" = "04-modelos\MODELO-ESCRITURA.md"
    "MODELO-MATRICULA.md" = "04-modelos\MODELO-MATRICULA.md"
}
foreach ($src in $map.Keys) {
    $sourcePath = Join-Path $scriptDir $src
    $destPath = Join-Path $baseDir $map[$src]
    if (Test-Path $sourcePath) {
        Copy-Item $sourcePath $destPath -Force
    }
}

# Copia o próprio script para o Cartório
Copy-Item $MyInvocation.MyCommand.Path (Join-Path $baseDir "03-scripts\dc.ps1") -Force

# 4. Git local
if (-not (Test-Path (Join-Path $baseDir ".git"))) {
    git init
}

# Padroniza branch principal
$currentBranch = (git branch --show-current).Trim()
if ([string]::IsNullOrWhiteSpace($currentBranch)) {
    git checkout -b main
} elseif ($currentBranch -eq "master") {
    git branch -M main
}

# 5. GitHub / remote
$origin = ""
try { $origin = (git remote get-url origin 2>$null).Trim() } catch {}

$remoteExists = $false
try {
    gh repo view $repoFull --json nameWithOwner *> $null
    if ($LASTEXITCODE -eq 0) { $remoteExists = $true }
} catch {}

if (-not $remoteExists) {
    Write-Host "Criando repositório GitHub $repoFull ..." -ForegroundColor Yellow
    gh repo create $repoFull --public --source=. --remote=origin
} elseif ([string]::IsNullOrWhiteSpace($origin)) {
    git remote add origin "https://github.com/$repoFull.git"
}

# 6. Commit
git add .
$hasChanges = git status --porcelain
if ($hasChanges) {
    git commit -m "docs: registra Documentação Cartorária - estrutura inicial DC"
}

# 7. Push
git push -u origin main

# 8. Verificação final
$gitOk = Test-Path (Join-Path $baseDir ".git")
$originNow = (git remote get-url origin).Trim()
$statusNow = git status --porcelain
$branchNow = (git branch --show-current).Trim()

$cloudOk = $false
try {
    gh repo view $repoFull --json nameWithOwner *> $null
    if ($LASTEXITCODE -eq 0) { $cloudOk = $true }
} catch {}

if ($gitOk -and $cloudOk -and $branchNow -eq "main" -and [string]::IsNullOrWhiteSpace($statusNow)) {
    Write-Host ""
    Write-Host "DC-PC: OK" -ForegroundColor Green
    Write-Host "DC-CD: OK" -ForegroundColor Green
    Write-Host "DC-OK:  OK" -ForegroundColor Green
    Write-Host "Local:   $baseDir"
    Write-Host "Cloud:   https://github.com/$repoFull"
} else {
    Write-Host ""
    Write-Host "DC ainda não pode ser declarada OK." -ForegroundColor Yellow
    Write-Host "Git local: $gitOk | Cloud: $cloudOk | Branch: $branchNow | Working tree limpo: $([string]::IsNullOrWhiteSpace($statusNow))"
}
