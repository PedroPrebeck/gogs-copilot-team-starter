# Executar a partir do clone do projeto: .\scripts\check-git-context.ps1 -Fetch
# Apenas consulta estado; -Fetch atualiza referências, sem alterar arquivos de trabalho.
param([switch]$Fetch)

$ErrorActionPreference = 'Stop'

function Invoke-Git([string[]]$Arguments) {
    & git @Arguments
    if ($LASTEXITCODE -ne 0) {
        throw "Falha em: git $($Arguments -join ' ') (exit $LASTEXITCODE)"
    }
}

$root = (& git rev-parse --show-toplevel 2>$null)
if ($LASTEXITCODE -ne 0 -or -not $root) {
    throw 'Execute dentro de um repositorio Git.'
}
Push-Location $root.Trim()
try {
    Write-Host '=== REPOSITORIO ==='
    Invoke-Git -Arguments @('remote','-v')
    Write-Host '=== BRANCH ATUAL ==='
    Invoke-Git -Arguments @('branch','--show-current')
    Write-Host '=== MUDANCAS LOCAIS ==='
    Invoke-Git -Arguments @('status','--short')
    if ($Fetch) {
        Write-Host '=== BUSCANDO REFERENCIAS REMOTAS ==='
        Invoke-Git -Arguments @('fetch','origin','--prune')
    }
    & git show-ref --verify --quiet refs/remotes/origin/main
    if ($LASTEXITCODE -ne 0) {
        Write-Warning 'Nao foi encontrada origin/main. Confirme o nome da branch principal e o acesso remoto.'
        return
    }
    Write-Host '=== ULTIMOS COMMITS PUBLICADOS NA MAIN ==='
    Invoke-Git -Arguments @('log','-n','10','--oneline','origin/main')
    Write-Host '=== COMMITS DA MAIN AINDA NAO INTEGRADOS ==='
    Invoke-Git -Arguments @('log','-n','10','--oneline','HEAD..origin/main')
    Write-Host '=== ARQUIVOS EM CONFLITO ==='
    Invoke-Git -Arguments @('diff','--name-only','--diff-filter=U')
    Write-Host 'Concluido. Nenhuma alteracao de arquivo foi incorporada ou publicada.'
}
finally {
    Pop-Location
}
