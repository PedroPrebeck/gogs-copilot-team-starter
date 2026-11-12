---
name: integrate-main
description: Verificar divergência do projeto com origin/main, identificar alterações de colegas e preparar integração segura na branch atual, sem sobrescrever mudanças locais.
---
# Integrar avanços da main

1. Confirme branch atual e `git status --short`. Não prossiga automaticamente se estiver na `main`, em detached HEAD ou se houver mudanças locais não tratadas.
2. Faça `git fetch origin --prune`; pare e informe se falhar. Compare a base com `git merge-base HEAD origin/main` e veja `git log --oneline HEAD..origin/main`.
3. Analise arquivos alterados recentemente por colegas e os efeitos sobre a tarefa. Se não houver avanço da main, não crie merge desnecessário.
4. Somente com autorização para incorporar alterações, use `git merge origin/main` na branch da tarefa. Não use rebase de branch compartilhada ou force push.
5. Se houver conflitos, siga a skill `resolve-conflict`. Não finalize o merge automaticamente se não puder confirmar os critérios de negócio.
6. Execute testes relevantes e revise o diff da integração. Relate estado final e as ações necessárias para publicar o branch e abrir PR.
