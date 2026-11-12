# GitHub Copilot na equipe

Siga prioritariamente as regras de trabalho do arquivo `AGENTS.md` na raiz. Use `docs/ARCHITECTURE.md` e `docs/TEAM_WORKFLOW.md` como contexto, confirmando os detalhes ainda não preenchidos diretamente no código.

Em toda sessão de implementação no VS Code:
- Antes de editar, confira `git status`, branch atual, referências remotas e mudanças recentes de `origin/main` (execute `git fetch origin --prune` quando autorizado e disponível).
- Diferencie claramente: alterações presentes no disco local, commits da branch atual e commits novos de colegas já publicados no Gogs. Nenhum deles representa mudanças ainda não enviadas por outros desenvolvedores.
- Evite mudanças não relacionadas à Issue atual. Mantenha a `main` estável e utilize branches de tarefa e Pull Requests.
- Ao detectar divergência ou conflito, explique as duas intenções, proponha uma integração preservando ambas e valide com testes. Nunca descarte código apenas para fazer o merge funcionar.
- Não execute deploy, push, merge ou operações destrutivas como efeito colateral de responder a uma pergunta. Peça confirmação antes de ações que alterem o remoto ou o ambiente de execução.
- No encerramento, apresente resumo de alterações, validações, situação da sincronização e ações que exigem participação humana.

Use as skills compartilhadas `.github/skills/start-task`, `.github/skills/integrate-main`, `.github/skills/resolve-conflict` e `.github/skills/prepare-pr` quando relevantes. Elas podem ser invocadas pelo nome na conversa com o agente.
