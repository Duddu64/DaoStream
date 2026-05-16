# daostream

## Visão geral
**daostream** é um app Flutter (com Riverpod) que consome dados do **protocolo Nostr** para montar fluxos (feeds) de conteúdo.

Neste repositório, a base foi estruturada para ficar escalável:
- **DataSource (infra/protocolo)**: comunicação com Nostr (relays, subscribe, publish)
- **Mappers (decodificação)**: convertem `NostrEvent` (tags/kinds) para entidades do domínio
- **Repository (casca de domínio)**: aplica regras e expõe streams prontos para a camada de apresentação
- **Providers (DI)**: wiring com Riverpod

> Observação: a camada de UI ainda é um protótipo (existe estrutura de pastas, mas não há telas completas no momento).

---

## Conceito do app (o que ele faz)
1. Inicializa comunicação com relays Nostr.
2. Cria uma subscription filtrada (ex.: kinds e tags relevantes para “manhua”).
3. Recebe eventos em stream.
4. Decodifica `event.tags` para construir entidades de domínio.
5. Exibe/propaga o resultado via repository para consumo na UI.

Atualmente:
- Existe suporte a **feed de posts** via `FeedRepository.listenToManhuaFeed()`.
- A decodificação principal está em `PostMapper`.

---

## Arquitetura atual (pastas e responsabilidades)

### `lib/core/providers/`
- **`network.dart`**: registra instâncias no Riverpod (DI).
  - `nostrInstanceProvider`
  - `authServiceProvider`
  - `nostrDataSourceProvider`
  - `feedRepositoryProvider`

### `lib/data/datasources/`
- **`nostr_data_source.dart`**: camada de infra com responsabilidades de:
  - `initRelays()`
  - `subscribeManhuaContent()`
  - `publishPost()`

### `lib/data/mappers/`
- **`post_mapper.dart`**: `NostrEvent -> PostEntity` (parse de tags: `t`, `e`, `a` etc.)
- **`manhua_mapper.dart`**: `NostrEvent -> ManhuaEntity`

### `lib/data/repositories/`
- **`feed.dart`**: expõe `Stream<PostEntity>` já mapeado para o domínio.

### `lib/data/services/`
- **`auth.dart`**: geração/armazenamento de chaves Nostr com `flutter_secure_storage`.
- (Existe também `services/nostr.dart` legado/protótipo; o caminho recomendado daqui pra frente é usar `NostrDataSource`.
  Se desejar, a refatoração pode remover/limpar o service legado após completar a migração.)

### `lib/domain/entities/`
Entidades imutáveis com campos centrais para o app:
- `PostEntity`
- `ManhuaEntity` (e demais entidades já existentes).

---

## Como rodar (dev)
1. Requisitos:
   - Flutter instalado
   - Dispositivo/emulador
2. Instale dependências:
   - `flutter pub get`
3. Rode:
   - `flutter run`

---

## Fluxo de dados (end-to-end)
1. `FeedRepository.listenToManhuaFeed()` chama:
   - `NostrDataSource.subscribeManhuaContent()`
2. Cada `NostrEvent` recebido é transformado por:
   - `PostMapper.fromNostrEvent(event)`
3. O repository retorna o `Stream<PostEntity>`.

---

## Melhorias ideias (backlog técnico)

### 1) Robustez do parsing (schema do Nostr)
- Tratar eventos com campos faltantes (`content`, `tags`, `createdAt` etc.).
- Centralizar convenções do schema (quais tags representam o quê para cada tipo de entidade).
- Adicionar testes unitários para os mappers com fixtures de `NostrEvent`.

### 2) Deduplicação e ordenação
- Deduplicar eventos por `event.id` (principalmente em streams longos).
- Ordenar por `createdAt` antes de emitir (ou definir uma estratégia consistente).

### 3) Cache/local storage
- Criar um `LocalDataSource` para persistir posts/caches por filtro.
- Estratégia sugerida:
  - carregar cache ao iniciar
  - atualizar com stream do Nostr
  - persistir “last seen” por filtro

### 4) Gerenciamento de estado na apresentação
- Criar controllers/providers para consumir streams com estado:
  - `loading / error / empty / data`
- Garantir cancelamento correto de subscriptions ao trocar telas.

### 5) Separar mais responsabilidades no futuro
- Introduzir interfaces (contratos) para:
  - `IFeedRepository`
  - `INostrDataSource`
- Permitir troca de implementação (mock/testing / fallback offline).

### 6) Suporte a mais tipos de conteúdo
- Expandir para:
  - capítulos
  - perfis
  - interações (likes/replies)
- Com isso, criar novos mappers e repositories (ex.: `ChapterRepository`).

---

## Passos futuros sugeridos (roadmap)

### Semana 1: UI mínima consumindo feed
- Criar tela e controller para exibir `Stream<PostEntity>`.
- Feedback de UX para loading/error.

### Semana 2: Qualidade do stream
- Deduplicação + ordenação.
- Tratamento de edge-cases nos mappers.
- Testes unitários de `PostMapper`.

### Semana 3: Cache/offline
- Implementar persistência de posts e “last seen”.
- Ao abrir app, mostrar cache enquanto o stream sincroniza.

### Semana 4: Manhua (detalhe e navegação)
- Criar `ManhuaRepository` (ou expandir um repository existente).
- Tela de detalhes usando `ManhuaEntity`.

### Semana 5: Capítulos e fluxo de leitura
- Criar mappers para eventos de capítulo.
- Tela de lista de capítulos e tela de leitura (render de páginas conforme schema).

### Semana 6: Polimento e escalabilidade
- Ajustes de reconexão e resiliência.
- Estruturar filtros parametrizados (ex.: por manhuaId).
- Reforçar testes e documentação.

---

## Notas de implementação (importante)
- Evite acoplamento: **DataSource** deve conhecer Nostr/protocolo; **Mappers** devem conhecer o schema; **Repository** deve orquestrar regras e expor para UI.
- Mantenha entidades no domínio o mais simples possível e imutáveis.

---

## Contribuindo
Sugestões de contribuição:
- adicionar testes de mappers
- melhorar parsing/validação do schema
- criar UI para consumir os providers
- evoluir cache/local storage

