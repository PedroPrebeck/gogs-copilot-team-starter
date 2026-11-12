# Acordo de trabalho da equipe

## Responsabilidades

- Gogs é a fonte oficial do histórico publicado; OneDrive não é meio de sincronizar código.
- Cada integrante usa clone próprio fora do OneDrive, identidade Git própria e branch por Issue.
- `main` deve permanecer executável e protegida contra push direto e force push.
- Para uma equipe de quatro pessoas, comece sem branch `develop`: branches curtas + PR para `main`.
- Uma pessoa revisa o PR de outra, principalmente quando afetar contratos compartilhados, dados ou deploy.
- Mudanças pequenas podem ir direto da Issue para a implementação. Mudanças amplas exigem especificação curta.

## Convenções

Branches: `feat/NUMERO-resumo`, `fix/NUMERO-resumo`, `refactor/NUMERO-resumo`, `docs/NUMERO-resumo`.
Commits: `feat: ...`, `fix: ...`, `refactor: ...`, `docs: ...`, `test: ...`, `chore: ...`.
Evite branches longas e PRs que misturam tarefas não relacionadas.

## Início do dia

1. Verifique a branch e alterações locais.
2. Faça fetch para descobrir commits e branches de colegas; o VS Code pode fazer fetch periódico, mas não integra os commits.
3. Atualize a sua `main` local com `git pull --ff-only origin main` somente se estiver em `main` e com árvore limpa.
4. Abra ou retome a branch da Issue e revise seus impactos antes de editar.
5. Ao receber mudanças de `main`, incorpore `origin/main` na branch da tarefa quando apropriado, validando conflitos e testes.

## Pull Request

- Relacione a Issue. Indique objetivo, arquivos críticos, mudanças de contratos e testes realizados.
- Outro integrante deve revisar antes do merge.
- Se o Gogs permitir, configure proteção da `main` exigindo PR e restringindo pushes diretos.
- Não use o VS Code para enviar código à `main` sem passar pelo processo de revisão.

## Máquina de execução (servidor)

- Serviço de Gogs e aplicação devem possuir diretórios e permissões diferentes.
- O Gogs mantém seus próprios dados Git; não edite arquivos diretamente dentro do armazenamento interno do Gogs.
- Ambiente de execução recebe apenas versões aprovadas, por checkout em diretório isolado, empacotamento ou outro processo de deploy definido pela equipe.
- Antes de automatizar deploy, documente: SO, comando de execução, dependências, credenciais, backups, testes, responsável e rollback.
- Não dispare deploy a partir de push em uma branch de funcionalidade.

## Limitações da automação

- Um commit local só fica visível a colegas após push.
- `git.autofetch` não executa pull, merge ou deploy.
- `AGENTS.md` orienta o agente, mas não sincroniza conteúdo remotamente.
- Conflitos semânticos podem existir mesmo sem conflito textual, por isso testes e revisão continuam necessários.
