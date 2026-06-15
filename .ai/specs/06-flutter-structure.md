# SPEC 01 — Flutter Project Setup

---

## Checks

### Projeto

- [ ] Criar projeto Flutter com suporte a Web (`flutter create --platforms web`)
- [ ] Configurar `pubspec.yaml` com as dependências obrigatórias:
  - `flutter_bloc` + `bloc` (Cubit)
  - `get_it` (injeção de dependência)
  - `go_router` (navegação)
  - `dartz` (`Either` no domain)
  - `equatable` (entidades imutáveis)
  - `dio` (HTTP client)
  - `flutter_secure_storage` (local)
  - `google_fonts` (Roboto, Montserrat, Roboto Mono, Inter)

### Rules

- [ ] Configurar `.analysis_options.yaml` com regras de linting e formatação
- [ ] A pagina não deve ter no maximo entre 100 e 120 linhas
- [ ] Separar funções em arquivos menores quando possivel
- [ ] Não criar funções no mesmo arquivo que layout, utilizar pasta "components" ou "widgets" para componentes reutilizáveis
- [ ] Dentro de cada pasta use um arquivo `_exports.dart` para exportar todos os arquivos da pasta, até o root, e então use como import apenas o `_exports.dart` da raiz

### Estrutura de pastas

- [ ] Criar estrutura `lib/app/modules/` com as pastas:
  ```
  lib/
  ├── app/
  │   ├── core/
  │   │   ├── di/          ← GetIt setup
  │   │   ├── network/     ← ApiService + interceptor de refresh
  │   │   ├── router/      ← AppRouter (go_router)
  │   │   ├── storage/     ← StorageService
  │   │   └── theme/       ← AppTheme + design tokens
  │   └── modules/
  │       ├── auth/
  │       ├── home/
  │       ├── services/
  │       ├── docs/
  │       ├── ai/
  │       ├── apis/
  │       └── versions/
  └── main.dart
  ```

### Estrutura de arquivos

- [ ] Criar estrutura:
  ```
  modules/docs/
  ├── docs_binds.dart
  ├── data/
  │   ├── docs_datasource.dart
  │   └── docs_datasource_impl.dart
  ├── domain/
  │   ├── entities/doc_file.dart
  │   └── repositories/docs_repository.dart
  └── presenter/
      ├── docs_page.dart
      ├── widgets/
      │   ├── docs_tree.dart
      │   └── markdown_viewer.dart
      └── cubits/
          ├── docs_cubit.dart
          └── docs_state.dart

### Injeção de dependência (GetIt)

- [ ] Criar `di/injection.dart` com `setup()` chamado no `main.dart`
- [ ] Registrar `ApiService`, `StorageService` como singletons
- [ ] Cada módulo registra seus próprios datasources, repositories e cubits

### Navegação (go_router)

- [ ] Configurar rotas conforme CLAUDE.md:
  ```
  /            → HomepageScreen
  /login       → LoginPage
  /callback    → CallbackPage
  /service/:id → ServiceShell
    /docs
    /apis
    /ai
    /versions
    /settings
  ```
- [ ] Implementar redirect guard: rotas protegidas redirecionam para `/login` se não autenticado
- [ ] `ShellRoute` para `ServiceShell` (tabs persistentes)

### ApiService

- [ ] Configurar `Dio` com base URL via env/config
- [ ] Interceptor de refresh: ao receber `401`, tenta renovar token e repete request
- [ ] Interceptor de auth: injeta `Authorization: Bearer <token>` em toda request

### Tema

- [ ] Criar `AppTheme.dark()` com `ThemeData`:
  - Background: `#0B0B14`
  - Surface: `#10101E`
  - Primary: `#4B62FF`
  - Fontes: Roboto (body), Montserrat (display), Roboto Mono (mono)
- [ ] Expor constantes de cor e espaçamento alinhados com `tokens.css`
