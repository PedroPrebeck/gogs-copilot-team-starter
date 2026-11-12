# projeto - Instruções compartilhadas para agentes de IA

Estas regras valem para qualquer agente que trabalhe no repositório do projeto, inclusive o GitHub Copilot no VS Code.
As mudanças passam pelo Git e pelos Pull Requests do Gogs. O agente não tem acesso contínuo ao trabalho não publicado dos demais desenvolvedores.

## Hierarquia de contexto

1. Código e testes atuais do checkout local.
2. Histórico e branches disponíveis no Git, especialmente `origin/main` após um `git fetch` bem-sucedido.
3. Contrato da tarefa na Issue do Gogs e sua especificação, quando houver.
4. `docs/ARCHITECTURE.md`, `docs/TEAM_WORKFLOW.md` e decisões registradas em `docs/decisions/`.
5. Esta orientação. Se a documentação contradisser o código, destaque a inconsistência em vez de inventar uma resposta.

## Antes de modificar arquivos

1. Descubra a raiz do repositório e a branch atual com `git rev-parse --show-toplevel`, `git branch --show-current` e `git status --short`.
2. Execute `git fetch origin --prune`, quando a rede e as permissões permitirem, para atualizar as referências remotas. Um fetch não incorpora mudanças automaticamente à árvore de trabalho.
3. Examine o histórico recente de `origin/main` com `git log -n 10 --oneline origin/main`, os arquivos pertinentes e os testes existentes.
4. Confirme que a tarefa está em uma branch individual (`feat/`, `fix/`, `refactor/`, `docs/` ou `chore/`). Não comece novas funcionalidades diretamente em `main`.
5. Identifique efeitos sobre interfaces, contratos de dados, consultas, migrações, configurações e arquivos que outros integrantes possam editar.
6. Se houver alterações locais já existentes, preserve-as. Não as descarte, sobrescreva nem as misture com a sua tarefa sem confirmar a autoria e o objetivo.
7. Se o remoto estiver inacessível, informe que o contexto pode estar desatualizado. Não afirme que está sincronizado.

## Implementação

- Prefira alterações pequenas e alinhadas à Issue. Respeite o estilo e as bibliotecas que já existem no repositório.
- Para alterações amplas ou de comportamento, registre requisitos, critérios de aceite, impacto e plano de teste em `docs/specs/` usando o modelo disponível.
- Antes de mudar contratos compartilhados, verifique os consumidores existentes e solicite decisão humana quando a alteração for incompatível.
- Não introduza dependências novas, migrações destrutivas ou mudanças de arquitetura sem justificativa e aprovação adequadas.
- Acrescente ou atualize testes para o comportamento alterado. Execute apenas comandos identificados e seguros; não invente comando de teste.
- Não edite arquivos de produção por conexão direta nem trate a pasta do serviço em execução como ambiente de desenvolvimento.

## Integração e conflitos

- Use `main` como ramo integrador estável; cada tarefa utiliza uma branch própria e segue por Pull Request no Gogs.
- Atualize as referências remotas antes de propor integração. Se `main` avançou, avalie impactos e incorpore `origin/main` à sua branch por merge, preservando o histórico compartilhado.
- O Git pode mesclar mudanças compatíveis automaticamente. Diante de conflitos reais, analise base comum, alterações locais e alterações remotas. Preserve a intenção de ambas as contribuições quando possível.
- Nunca resolva conflitos escolhendo cegamente `ours`, `theirs`, `accept current` ou `accept incoming` para arquivos inteiros.
- Se a resolução exigir uma decisão funcional ou puder descartar uma regra de negócio, interrompa e peça decisão ao responsável.
- Após resolver, rode os testes relevantes e examine o diff. Não continue operação ou publique mudanças sem validar a resolução.
- `git rerere` pode reaplicar resoluções já registradas localmente, mas isso não substitui a verificação.

## Operações proibidas sem autorização explícita

- `git push --force`, `git reset --hard`, apagar branches de colegas, limpar arquivos não rastreados, sobrescrever arquivos locais, reescrever branches compartilhadas ou fazer merge diretamente em `main`.
- Efetuar deploy, reiniciar serviço, alterar dados reais, executar DDL/DML destrutivo ou mudar credenciais.
- Publicar senhas, tokens, dados de clientes, segredos empresariais ou informações confidenciais em commits, logs ou mensagens do agente.

## Entrega ao desenvolvedor

Ao concluir uma tarefa, informe: branch, arquivos modificados, comportamento alterado, testes executados e resultado, riscos ou pendências, mudanças de `origin/main` que afetam o trabalho e próximos passos para abrir o Pull Request. Não afirme ter lido Issues/PRs do Gogs sem acesso real à interface ou ferramenta que os forneça.