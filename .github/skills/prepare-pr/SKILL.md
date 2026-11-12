---
name: prepare-pr
description: Preparar Pull Request do projeto para o Gogs, revisando alterações, testes e impactos em colegas, sem fazer merge ou deploy automaticamente.
---
# Preparar Pull Request

1. Confira `git status --short`, branch atual e `git fetch origin --prune` quando disponível.
2. Compare a branch com `origin/main` e examine todos os arquivos alterados; identifique itens que não pertencem à Issue.
3. Confirme que não há credenciais, dados sensíveis, arquivos gerados ou alterações de configuração local a serem publicados.
4. Execute testes e validações existentes. Informe explicitamente o que não pôde verificar.
5. Se `origin/main` avançou, proponha integrar as mudanças na branch antes do PR; não faça operações destrutivas.
6. Preencha um texto de PR com base em `docs/PR_CHECKLIST.md`, incluindo Issue, resumo, testes, riscos, impacto em contratos e instruções de rollback se necessário.
7. Não abra ou conclua PR automaticamente sem ferramenta Gogs conectada e autorização. Nunca faça merge direto em `main` nem deploy automático nesta skill.
