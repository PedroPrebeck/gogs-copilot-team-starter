# Git + Gogs + GitHub Copilot no VS Code: kit para equipes

Template para **4 desenvolvedores trabalhando em máquinas separadas** com VS Code, GitHub Copilot e um servidor Gogs interno. Inclui instruções compartilhadas para agentes, quatro Agent Skills, checklists de Pull Request, modelos leves de SDD e um script de diagnóstico Git.

> **Este repositório é público e contém somente modelos e documentação.** Não contém o código de nenhuma aplicação corporativa, servidores internos, URLs privadas, credenciais ou configuração de produção. Use-o como fonte dos arquivos de configuração e mantenha o **código real no Gogs privado**.

## 1. Como a equipe vai trabalhar

```text
Dev 1 ─ branch feat/101 ─┐
Dev 2 ─ branch fix/102  ─┼──> Gogs interno ──> Pull Request ──> main protegida
Dev 3 ─ branch feat/103 ─┤                                      │
Dev 4 ─ branch docs/104 ─┘                                      ▼
                                                     deploy controlado no servidor
```

Cada pessoa tem um **clone Git local separado**, fora do OneDrive. A `main` reúne apenas alterações revisadas. A máquina que executa o sistema pode hospedar o Gogs, mas o **diretório de execução da aplicação deve ser independente** do armazenamento Git e de qualquer pasta compartilhada por desenvolvedores.

**O que o Copilot consegue fazer:** consultar a cópia local, ler as instruções versionadas, executar comandos Git autorizados, detectar commits dos colegas já publicados e ajudar na resolução de conflitos.

**O que não consegue fazer sozinho:** ler arquivos ainda não publicados no PC de outra pessoa, saber de um conflito funcional sem examinar código e testes, garantir que um merge esteja correto ou se conectar automaticamente às Issues e PRs do Gogs sem ferramenta de integração.

## 2. Pré-requisitos e verificações de segurança

- Git for Windows, VS Code e extensão **GitHub Copilot** instalados em cada PC.
- Permissão da organização para usar Copilot com o repositório interno. **Não envie código confidencial a serviços externos sem autorização.**
- Usuário individual por desenvolvedor no Gogs, com acesso à aplicação privada.
- Acesso de rede ao Gogs interno, idealmente via **HTTPS validado ou SSH**. HTTP simples é inadequado para credenciais e código sensível.
- Uma branch principal estável: este kit supõe `main`. Se o projeto usa `master`, substitua as referências a `main` **em todos os comandos, instruções e scripts**.
- Backup confirmado da versão que hoje está na pasta compartilhada. Defina um intervalo para interromper edições durante a migração.

> Este guia considera **Windows + PowerShell**. Em Linux/macOS, use os mesmos comandos Git em um terminal e copie os arquivos manualmente.

## 3. Migrar da pasta compartilhada para o Gogs (uma única vez)

**Um responsável pela migração:**

1. Peça à equipe para interromper edições na pasta do OneDrive e marque a versão de referência.
2. Faça backup e identifique `.env`, credenciais, dados reais, arquivos temporários, dependências instaladas e binários que **não devem** ser publicados.
3. Confirme no navegador a existência do repositório Gogs e sua branch principal. Não inicialize outro Git dentro de um clone existente.
4. Clone o projeto em uma pasta **fora do OneDrive**. Substitua `<URL_PRIVADA_GOGS>` pelo endereço copiado da interface Gogs:

   ```powershell
   New-Item -ItemType Directory -Force C:\dev | Out-Null
   git clone <URL_PRIVADA_GOGS> C:\dev\minha-aplicacao
   cd C:\dev\minha-aplicacao
   git remote -v
   git status
   ```

5. Compare o conteúdo do clone com a versão aprovada no OneDrive. **Se já estiver atualizado, não copie nada por cima.** Se o Gogs estiver vazio ou defasado, migre seletivamente o código, depois de configurar um `.gitignore` apropriado à stack. Não copie `.git`, bancos locais, segredos, cache ou a própria pasta de execução.
6. Revise os arquivos antes de publicar: `git status`, `git diff` e `git diff --cached` depois de selecionar arquivos. Registre um commit-base no Gogs somente após conferir que não há dados confidenciais. Nunca use `push --force` para completar a migração.
7. Confirme que o repositório Gogs contém a versão correta. **Só então** os demais desenvolvedores devem cloná-lo em máquinas distintas.

> A URL real do Gogs é informação para uso **apenas no computador corporativo**. Não a insira em Issues ou commits deste template público.

## 4. Instalar este kit no clone privado (uma única vez)

Em qualquer PC com acesso ao GitHub público e ao Gogs privado, abra um PowerShell. **Primeiro crie uma branch para o setup no clone privado, com a árvore de trabalho limpa:**

```powershell
cd C:\dev\minha-aplicacao
git status --short
git switch main
git pull --ff-only origin main
git switch -c chore/configurar-copilot-equipe
```

Depois, em uma segunda pasta fora do OneDrive, obtenha este template público e instale os arquivos:

```powershell
cd C:\dev
git clone https://github.com/PedroPrebeck/gogs-copilot-team-starter.git
cd .\gogs-copilot-team-starter

# Veja o que seria copiado, sem alterar nada:
.\scripts\install-starter.ps1 -TargetPath "C:\dev\minha-aplicacao" -DryRun

# Copie apenas os arquivos que ainda não existem:
.\scripts\install-starter.ps1 -TargetPath "C:\dev\minha-aplicacao"
```

**Atenção:** o endereço acima só passa a funcionar após a publicação deste template na conta indicada. Se ainda não estiver disponível, baixe o ZIP do kit e execute o mesmo script na pasta extraída.

O instalador **não altera o repositório público**, não faz `git commit`, `git push`, `merge` nem `deploy`, e **não sobrescreve arquivos existentes**. Se o clone já tiver `AGENTS.md`, `.github/` ou outros arquivos com os mesmos nomes, ele avisa e pula o arquivo. Mescle regras existentes manualmente.

Agora entre no clone privado:

```powershell
cd C:\dev\minha-aplicacao
code .
git status --short
```

Adicione o kit à **branch de configuração que você já criou**, não diretamente à `main`:

```powershell
# Inspecione o diff e selecione apenas os arquivos de configuração
git status
git add AGENTS.md .github .vscode docs scripts/check-git-context.ps1
git diff --cached --stat
git diff --cached
git commit -m "chore: configurar fluxo Git e Copilot"
git push -u origin chore/configurar-copilot-equipe
```

Abra um Pull Request no **Gogs**, solicite revisão de um colega e integre à `main`. Se a proteção da `main` ainda não estiver configurada, defina uma pessoa responsável pela integração inicial e ative a proteção antes do desenvolvimento normal.

## 5. Configurar os quatro desenvolvedores

Cada pessoa clona o **mesmo repositório privado do Gogs**, em um diretório próprio fora do OneDrive:

```powershell
git clone <URL_PRIVADA_GOGS> C:\dev\minha-aplicacao
cd C:\dev\minha-aplicacao
code .
```

Configure sua identidade Git **apenas nesse repositório**, sem modificar as configurações globais da máquina:

```powershell
git config --local user.name "Seu Nome"
git config --local user.email "seu.email@empresa.example"
git config --local pull.ff only
git config --local merge.conflictStyle zdiff3

# Opcional: Git reaproveita resoluções anteriores sem preparar o stage automaticamente
git config --local rerere.enabled true
git config --local rerere.autoupdate false
```

No VS Code, abra a **raiz do repositório**, entre no Copilot Chat e selecione o modo **Agent**. Confira se os arquivos abaixo estão versionados na branch recebida:

- `AGENTS.md`: regras gerais compartilhadas.
- `.github/copilot-instructions.md`: instruções explícitas para o Copilot.
- `.github/skills/start-task/SKILL.md`: preparação de tarefa.
- `.github/skills/integrate-main/SKILL.md`: análise de novas mudanças.
- `.github/skills/resolve-conflict/SKILL.md`: resolução assistida de conflitos.
- `.github/skills/prepare-pr/SKILL.md`: checklist para PR.
- `docs/ARCHITECTURE.md`: contexto real da aplicação, inicialmente a preencher.
- `docs/specs/_TEMPLATE.md`: especificação leve para mudanças maiores.
- `scripts/check-git-context.ps1`: diagnóstico Git.

As instruções auxiliam o agente e podem ser compartilhadas no Git. **Não garantem** que ele executará todas as ações; verifique a atividade do Chat e os resultados.

## 6. Configurar o Gogs

Na interface de administração do repositório, confirme os recursos disponíveis na versão instalada e configure:

1. **Branch principal:** `main` (ou substitua todas as referências do kit se já usa `master`).
2. **Protected Branches:** proteja `main` contra push direto e force push. Exija integração por Pull Request se a versão/permissões permitirem.
3. **Usuários:** cada pessoa com sua própria conta; restrinja administradores.
4. **Issues e Pull Requests:** uma tarefa por Issue e revisão por pelo menos um colega.
5. **Acesso:** preferir HTTPS ou SSH. Não incluir tokens e senhas em arquivos versionados.

Para uma equipe de quatro pessoas, **não crie `develop` inicialmente**: mantenha branches curtas integradas à `main` via PR.

## 7. Fluxo diário, com exemplos

**Começar uma Issue #42:**

```powershell
cd C:\dev\minha-aplicacao
git status --short
git switch main
git pull --ff-only origin main
git switch -c feat/42-nova-consulta
.\scripts\check-git-context.ps1 -Fetch
```

Se `git status` mostrar alterações locais, **não mude de branch cegamente**: primeiro identifique quem as fez e para qual tarefa pertencem.

Peça ao Copilot Chat:

> Use a skill `start-task` para a Issue #42. Leia o `AGENTS.md` e a arquitetura, execute `git fetch origin --prune`, confira os commits recentes da `main`, identifique áreas que outros colegas alteraram e apresente um plano antes de editar. Não descarte mudanças locais.

**Durante a implementação:**

```powershell
git status
git add caminho/do/arquivo1 caminho/do/arquivo2
git diff --cached
git commit -m "feat: implementar nova consulta"
git push -u origin feat/42-nova-consulta
```

**Sincronizar mudanças publicadas dos colegas:**

```powershell
git status --short       # pare se houver mudanças que precisem ser protegidas
git fetch origin --prune
git log --oneline HEAD..origin/main
# Somente com a branch de tarefa limpa, após avaliar impacto:
git merge origin/main
```

O fetch automático configurado em `.vscode/settings.json` apenas atualiza referências remotas. Ele **não faz pull ou merge**. O Copilot também não enxerga arquivos que os outros ainda não publicaram.

Se houver conflito, use o **Merge Editor** do VS Code ou peça:

> Use a skill `resolve-conflict`. Compare a base comum e os dois lados, identifique contratos e testes afetados, proponha uma resolução que preserve ambas as intenções e mostre o diff. Se houver decisão de negócio, pare e peça minha orientação antes de concluir o merge.

Depois dos testes, publique sua branch. Use a skill `prepare-pr` para produzir a descrição do Pull Request e peça a revisão de um colega.

## 8. Quando criar uma especificação (SDD leve)

Crie `docs/specs/42-nova-consulta.md`, usando o template, quando houver novas regras de negócio, alterações de contratos, integração entre módulos ou tarefas que atinjam vários desenvolvedores. Registre:

- Objetivo e escopo da Issue.
- Comportamento esperado e exemplos relevantes.
- Contratos ou arquivos compartilhados afetados.
- Critérios de aceite verificáveis e plano de testes.
- Dependências e decisões pendentes.

Correções pequenas podem ser descritas diretamente na Issue. Evite burocracia que não ajude a equipe.

## 9. Servidor de execução e deploy

Se a mesma máquina hospedar Gogs e a aplicação, mantenha **três responsabilidades separadas**: dados internos do Gogs, repositórios/clones usados para desenvolvimento e ambiente de execução.

- Nunca execute a aplicação a partir do armazenamento interno de repositórios do Gogs.
- Use um diretório independente para staging e outro para execução.
- Só entregue uma versão aprovada da `main`, por um processo de deploy definido pela equipe.
- Documente SO, dependências, serviços, credenciais, backup, testes e rollback antes de automatizar.
- Não faça deploy automático de branches individuais ou de um push ainda não revisado.

O template **não inclui um script de deploy** porque o runtime real da aplicação ainda precisa ser inspecionado.

## 10. Diagnóstico e checklist

```powershell
git remote -v
git branch -a
git status
git fetch origin --prune
git log --oneline -10 origin/main
.\scripts\check-git-context.ps1 -Fetch
```

- [ ] Código validado e versionado no Gogs interno
- [ ] Quatro clones individuais fora do OneDrive
- [ ] Permissão de uso do Copilot confirmada
- [ ] Branch principal protegida e PRs habilitados
- [ ] Equipe recebeu `AGENTS.md` e as skills via Git
- [ ] `docs/ARCHITECTURE.md` preenchido com fatos verificados
- [ ] Testes e comandos reais de inicialização documentados
- [ ] Aplicação executada fora da pasta do Gogs e do OneDrive
- [ ] Procedimento de backup e rollback definido

## 11. Próximas melhorias, quando houver necessidade

- **CI:** executar testes em PRs, se o Gogs/infraestrutura suportarem integração via hooks/webhooks e runners externos.
- **MCP para Gogs:** permitir ao agente consultar Issues e PRs pela API do Gogs com credenciais armazenadas fora do repositório. Isto exige implementação e autorização da equipe; não está configurado neste kit.
- **Instruções específicas:** depois de mapear a stack, criar `.github/instructions/*.instructions.md` para testes, banco, API e frontend, se fizer sentido.

## Fontes oficiais

- [VS Code: custom instructions](https://code.visualstudio.com/docs/agent-customization/custom-instructions)
- [VS Code: Agent Skills](https://code.visualstudio.com/docs/agent-customization/agent-skills)
- [GitHub: instruções do Copilot na IDE](https://docs.github.com/en/copilot/how-tos/copilot-in-your-ide/customize-copilot/configure-custom-instructions/add-repository-instructions-in-your-ide)
- [GitHub CLI: criar repositórios](https://cli.github.com/manual/gh_repo_create)
- [Gogs: documentação](https://gogs.io/docs)