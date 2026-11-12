# Instala arquivos de instrucoes no clone privado, sem sobrescrever os existentes.
# Uso: .\scripts\install-starter.ps1 -TargetPath "C:\dev\minha-aplicacao" -DryRun
param(
    [Parameter(Mandatory = $true)]
    [string] $TargetPath,
    [switch] $DryRun
)

$ErrorActionPreference = 'Stop'
$sourceRoot = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot '..')).Path
$target = (Resolve-Path -LiteralPath $TargetPath).Path

if (-not (Test-Path -LiteralPath (Join-Path $target '.git'))) {
    throw 'O destino precisa ser a raiz de um clone Git existente. Clone primeiro o repositório privado do Gogs.'
}
if ($target -eq $sourceRoot) {
    throw 'Origem e destino nao podem ser a mesma pasta.'
}

$files = @(
    'AGENTS.md',
    '.github/copilot-instructions.md',
    '.github/skills/start-task/SKILL.md',
    '.github/skills/integrate-main/SKILL.md',
    '.github/skills/resolve-conflict/SKILL.md',
    '.github/skills/prepare-pr/SKILL.md',
    '.vscode/settings.json',
    'docs/ARCHITECTURE.md',
    'docs/TEAM_WORKFLOW.md',
    'docs/PR_CHECKLIST.md',
    'docs/specs/_TEMPLATE.md',
    'docs/decisions/_TEMPLATE.md',
    'scripts/check-git-context.ps1'
)

$copied = 0
$skipped = 0
foreach ($relative in $files) {
    $relativeOS = $relative.Replace('/', [IO.Path]::DirectorySeparatorChar.ToString())
    $source = Join-Path $sourceRoot $relativeOS
    $destination = Join-Path $target $relativeOS
    if (-not (Test-Path -LiteralPath $source -PathType Leaf)) {
        throw "Arquivo do kit ausente: $relative"
    }
    if (Test-Path -LiteralPath $destination) {
        Write-Warning "EXISTE, nao sobrescrito: $relative"
        $skipped++
        continue
    }
    if ($DryRun) {
        Write-Host "COPIARIA: $relative"
    } else {
        New-Item -ItemType Directory -Force -Path (Split-Path -Parent $destination) | Out-Null
        Copy-Item -LiteralPath $source -Destination $destination -ErrorAction Stop
        Write-Host "COPIADO: $relative"
    }
    $copied++
}
Write-Host "Arquivos $(if ($DryRun) { 'previstos' } else { 'copiados' }): $copied; existentes preservados: $skipped."
Write-Host 'Proximo passo: abra o clone privado, revise git status/diff, crie uma branch e abra um Pull Request no Gogs.'
