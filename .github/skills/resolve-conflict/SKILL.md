---
name: resolve-conflict
description: Analisar e propor resolução de conflitos de merge no projeto preservando a intenção de ambas as mudanças e exigindo validação antes de concluir a operação.
---
# Resolver conflito no projeto

1. Verifique `git status` para identificar merge, rebase ou cherry-pick em curso. Liste arquivos realmente conflitantes com `git diff --name-only --diff-filter=U`.
2. Para cada conflito, leia a versão base, o lado atual e o lado recebido. Em rebase, `ours` e `theirs` não correspondem intuitivamente à autoria original.
3. Verifique callers, testes, contratos de dados e mudanças associadas. Explique a função das duas mudanças antes de decidir a resolução.
4. Resolva somente conflitos de intenção clara. Preserve ambas as contribuições sempre que compatível. Se houver conflito de requisito ou alteração irreversível, peça decisão humana.
5. Revise o arquivo inteiro, sem marcadores de conflito, duplicações de lógica ou regressões. Execute os testes pertinentes e informe falhas.
6. Apresente a resolução e aguarde confirmação apropriada antes de fazer commit, continuar rebase ou enviar push. Nunca use `--ours`/`--theirs` indiscriminadamente.
