---
name: start-task
description: Preparar uma nova tarefa do projeto, identificar mudanças recentes dos colegas no Gogs, conferir branch e estado do repositório e elaborar plano de implementação seguro antes de editar.
---
# Iniciar tarefa no projeto

1. Leia `AGENTS.md`, `docs/ARCHITECTURE.md` e `docs/TEAM_WORKFLOW.md`.
2. Execute `git status --short`, `git branch --show-current` e `git fetch origin --prune`, se estiver permitido. Como alternativa, use `scripts/check-git-context.ps1 -Fetch` no PowerShell.
3. Liste commits recentes de `origin/main`, identifique mudanças que afetem a tarefa e procure branches remotas relacionadas. Nunca presuma acesso aos arquivos não publicados dos colegas.
4. Receba o número e a descrição da Issue ou peça os requisitos ausentes. Se não tiver ferramenta de acesso ao Gogs, utilize apenas o texto da Issue fornecido pelo usuário, sem inventar contexto.
5. Confirme branch individual. Se a branch não existir, sugira nome; só crie quando o usuário solicitar ou a instrução da tarefa autorizar.
6. Para mudança ampla, preencha um rascunho baseado em `docs/specs/_TEMPLATE.md` e aguarde validação dos critérios de aceite antes de alterar contratos compartilhados.
7. Produza plano curto: arquivos previstos, possíveis áreas de sobreposição com colegas, critérios de aceite e testes existentes. Só depois comece a codificar.
