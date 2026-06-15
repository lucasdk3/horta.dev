# SPEC 07 — Flutter Refactor: Structure, Cubit & GetIt

> Objetivo: alinhar o projeto `horta-platform` às regras definidas no SPEC 06
> (estrutura de arquivos, tamanho de página, Cubit, GetIt por módulo, `_exports.dart`).

---

## Gap Analysis — estado atual vs. esperado

### 1. Arquivos duplicados / mal posicionados

| Arquivo atual | Problema | Ação |
|---|---|---|
| `modules/auth/login_screen.dart` | Na raiz do módulo, fora de `presenter/` | Mover para `presenter/login_page.dart` |
| `modules/garden/garden_screen.dart` | Duplicata — versão correta já em `presenter/` | Deletar |
| `modules/lab/lab_screen.dart` | Duplicata — versão correta já em `presenter/` | Deletar |
| `modules/nursery/nursery_screen.dart` | Duplicata — versão correta já em `presenter/` | Deletar |
| `core/auth_service.dart` | Na raiz de `core/`, fora de subpasta | Mover para `core/auth/auth_service.dart` |
| `core/routes.dart` | Redundante — `core/router/app_router.dart` já existe | Deletar |
| `core/theme.dart` | Na raiz de `core/`, fora de `theme/` | Mover para `core/theme/app_theme.dart` |

---

### 2. Pastas ausentes no `core/`

```
core/
├── auth/          ← auth_service.dart deve vir para cá
├── di/            ✅ existe
├── network/       ✅ existe
├── router/        ✅ existe
├── storage/       ✗ AUSENTE — criar StorageService
├── theme/         ✗ AUSENTE — mover theme.dart para cá
└── widgets/       ✅ existe
```

---

### 3. Estrutura de módulos — template obrigatório

Cada módulo deve seguir exatamente:

```
modules/{module}/
├── {module}_binds.dart         ← registra deps no GetIt
├── data/
│   ├── {module}_datasource.dart
│   └── {module}_datasource_impl.dart
├── domain/
│   ├── entities/
│   └── repositories/{module}_repository.dart
└── presenter/
    ├── {module}_page.dart       ← máx 120 linhas
    ├── widgets/                 ← componentes extraídos
    │   └── _exports.dart
    └── cubits/
        ├── {module}_cubit.dart
        └── {module}_state.dart
```

#### Estado atual por módulo

| Módulo | `_binds` | `data/` | `domain/` | `presenter/` | `cubits/` | Conformidade |
|---|---|---|---|---|---|---|
| `auth` | ✗ | ✗ | ✗ | ✗ (fora de `presenter/`) | ✗ | 0% |
| `nursery` | ✗ | ✗ | ✅ parcial | ✅ | ✗ | 25% |
| `garden` | ✗ | ✗ | ✅ parcial | ✅ | ✗ | 25% |
| `lab` | ✗ | ✗ | ✗ | ✅ | ✗ | 10% |
| `about` | ✗ | ✗ | ✗ | ✅ | ✗ | 10% |
| `admin` | ✗ | ✗ | ✗ | ✅ | ✗ | 10% |

---

### 4. Violações de tamanho de página (> 120 linhas)

| Arquivo | Linhas | Ação necessária |
|---|---|---|
| `lab/presenter/lab_screen.dart` | 681 | Extrair seções para `widgets/` |
| `about/presenter/about_page.dart` | 602 | Extrair seções para `widgets/` |
| `core/widgets/global_assistant.dart` | 535 | Dividir em widgets menores |
| `nursery/presenter/nursery_screen.dart` | 516 | `_PillButton`, `_TagFilterBar`, `_TagChip`, `_SurveyCard`, `_EmptyState` → `widgets/` |
| `admin/presenter/admin_dashboard.dart` | 460 | Extrair seções para `widgets/` |
| `nursery/presenter/widgets/survey_chat_tab.dart` | 456 | Dividir em widgets menores |
| `garden/presenter/garden_screen.dart` | 436 | `_StatCard` → `widgets/`; lógica → Cubit |
| `nursery/presenter/widgets/survey_form_tab.dart` | 390 | Dividir em widgets menores |
| `core/widgets/horta_navbar.dart` | 322 | Extrair items/menu para widgets separados |
| `nursery/presenter/survey_detail_screen.dart` | 261 | Extrair tabs para `widgets/` |
| `nursery/presenter/widgets/survey_ai_tab.dart` | 239 | Dividir em widgets menores |
| `nursery/presenter/widgets/survey_table_tab.dart` | 213 | Dividir em widgets menores |
| `auth/login_screen.dart` | 200 | Extrair `_LoginCard`, `_BackgroundGlow` → `widgets/` |
| `nursery/presenter/widgets/request_survey_modal.dart` | 193 | Dividir em widgets menores |
| `core/router/app_router.dart` | 133 | Extrair `MainShell` para `core/widgets/main_shell.dart` |

---

### 5. Gerenciamento de estado — migração para Cubit

Todos os módulos usam `StatefulWidget` + `setState` para lógica assíncrona. Devem usar Cubit.

#### Padrão obrigatório

**`{module}_state.dart`**
```dart
part of '{module}_cubit.dart';

sealed class {Module}State extends Equatable {
  const {Module}State();
}

final class {Module}Loading extends {Module}State {
  const {Module}Loading();
  @override List<Object?> get props => [];
}

final class {Module}Loaded extends {Module}State {
  const {Module}Loaded(this.data);
  final SomeEntity data;
  @override List<Object?> get props => [data];
}

final class {Module}Error extends {Module}State {
  const {Module}Error(this.message);
  final String message;
  @override List<Object?> get props => [message];
}
```

**`{module}_cubit.dart`**
```dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part '{module}_state.dart';

class {Module}Cubit extends Cubit<{Module}State> {
  {Module}Cubit(this._repository) : super(const {Module}Loading());

  final {Module}Repository _repository;

  Future<void> load() async {
    final result = await _repository.fetchData();
    result.fold(
      (err) => emit({Module}Error(err.message)),
      (data) => emit({Module}Loaded(data)),
    );
  }
}
```

**Página consumindo o Cubit via GetIt:**
```dart
class {Module}Page extends StatelessWidget {
  const {Module}Page({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.I<{Module}Cubit>()..load(),
      child: BlocBuilder<{Module}Cubit, {Module}State>(
        builder: (context, state) => switch (state) {
          {Module}Loading() => const _LoadingView(),
          {Module}Loaded(:final data) => _ContentView(data: data),
          {Module}Error(:final message) => _ErrorView(message: message),
        },
      ),
    );
  }
}
```

#### Módulos que precisam de Cubit criado do zero

| Módulo | Estado a gerenciar |
|---|---|
| `nursery` | `List<Survey>`, `selectedTag`, `loading` |
| `garden` | `UserProfile?`, `loading`, `progressPercent` |
| `lab` | conteúdo do Lab (a definir) |
| `auth` | `isLoading`, resultado do login |
| `admin` | lista de recursos administrativos |

---

### 6. Injeção de dependência — `_binds.dart` por módulo

**Padrão:** cada módulo registra suas próprias deps. O `injection.dart` apenas chama os binds.

**`{module}_binds.dart`**
```dart
import 'package:get_it/get_it.dart';

void setup{Module}Binds(GetIt sl) {
  sl.registerLazySingleton<{Module}Datasource>(
    () => {Module}DatasourceImpl(sl()),
  );
  sl.registerLazySingleton<{Module}Repository>(
    () => {Module}RepositoryImpl(sl()),
  );
  sl.registerFactory<{Module}Cubit>(
    () => {Module}Cubit(sl()),
  );
}
```

**`core/di/injection.dart`** atualizado:
```dart
Future<void> setupInjection() async {
  // Core
  sl.registerSingleton<StorageService>(StorageService());
  sl.registerSingleton<ApiService>(ApiService(storage: sl()));
  sl.registerSingleton<AuthService>(AuthService());

  // Modules
  setupNurseryBinds(sl);
  setupGardenBinds(sl);
  setupLabBinds(sl);
  setupAuthBinds(sl);
  setupAdminBinds(sl);
}
```

---

### 7. Camada `data/` ausente nos módulos

A lógica de API está chamada diretamente nas telas (`GetIt.I<ApiService>().getSurveys()`).
Deve ser encapsulada em datasource + repository com `Either` do `dartz`.

**`{module}_datasource.dart`**
```dart
abstract interface class {Module}Datasource {
  Future<List<{Entity}Json>> fetchAll();
}
```

**`{module}_datasource_impl.dart`**
```dart
class {Module}DatasourceImpl implements {Module}Datasource {
  const {Module}DatasourceImpl(this._api);
  final ApiService _api;

  @override
  Future<List<{Entity}Json>> fetchAll() => _api.get{Entities}();
}
```

**`domain/repositories/{module}_repository.dart`**
```dart
import 'package:dartz/dartz.dart';

abstract interface class {Module}Repository {
  Future<Either<Failure, List<{Entity}>>> fetchAll();
}
```

---

### 8. `_exports.dart` — ausente em todas as pastas

Cada pasta deve ter um `_exports.dart` que re-exporta todos os arquivos da pasta.

**Exemplo para `nursery/presenter/widgets/_exports.dart`:**
```dart
export 'request_survey_modal.dart';
export 'survey_ai_tab.dart';
export 'survey_chat_tab.dart';
export 'survey_form_tab.dart';
export 'survey_table_tab.dart';
export 'survey_card.dart';
export 'tag_filter_bar.dart';
export 'empty_state.dart';
```

**Root exports — `modules/nursery/_exports.dart`:**
```dart
export 'nursery_binds.dart';
export 'presenter/nursery_page.dart';
export 'presenter/cubits/nursery_cubit.dart';
```

---

## Checklist de implementação

### Fase 1 — Limpeza e reorganização

- [ ] Deletar `modules/garden/garden_screen.dart` (duplicata)
- [ ] Deletar `modules/lab/lab_screen.dart` (duplicata)
- [ ] Deletar `modules/nursery/nursery_screen.dart` (duplicata)
- [ ] Deletar `core/routes.dart` (redundante)
- [ ] Mover `core/auth_service.dart` → `core/auth/auth_service.dart`
- [ ] Mover `core/theme.dart` → `core/theme/app_theme.dart` (ajustar imports)
- [ ] Criar `core/storage/storage_service.dart`
- [ ] Mover `auth/login_screen.dart` → `auth/presenter/login_page.dart`
- [ ] Extrair `MainShell` de `app_router.dart` → `core/widgets/main_shell.dart`

### Fase 2 — Cubit por módulo

- [ ] `nursery`: criar `presenter/cubits/nursery_cubit.dart` + `nursery_state.dart`
- [ ] `garden`: criar `presenter/cubits/garden_cubit.dart` + `garden_state.dart`
- [ ] `lab`: criar `presenter/cubits/lab_cubit.dart` + `lab_state.dart`
- [ ] `auth`: criar `presenter/cubits/auth_cubit.dart` + `auth_state.dart`
- [ ] `admin`: criar `presenter/cubits/admin_cubit.dart` + `admin_state.dart`
- [ ] Migrar todas as telas de `setState` + async para `BlocBuilder`

### Fase 3 — Camada de dados

- [ ] `nursery`: criar `data/nursery_datasource.dart` + `_impl.dart`
- [ ] `nursery`: criar `domain/repositories/nursery_repository.dart` + impl
- [ ] `garden`: criar `data/garden_datasource.dart` + `_impl.dart`
- [ ] `garden`: criar `domain/repositories/garden_repository.dart` + impl
- [ ] `admin`: criar `data/admin_datasource.dart` + `_impl.dart`
- [ ] Remover chamadas diretas a `ApiService` das telas

### Fase 4 — Binds por módulo

- [ ] Criar `nursery/nursery_binds.dart`
- [ ] Criar `garden/garden_binds.dart`
- [ ] Criar `lab/lab_binds.dart`
- [ ] Criar `auth/auth_binds.dart`
- [ ] Criar `admin/admin_binds.dart`
- [ ] Atualizar `core/di/injection.dart` para chamar todos os binds

### Fase 5 — Quebra de arquivos grandes

- [ ] `nursery_screen.dart` → página ≤120 linhas + extrair para `widgets/`:
  - `survey_card.dart`
  - `tag_filter_bar.dart`
  - `tag_chip.dart`
  - `pill_button.dart`
  - `empty_state.dart`
- [ ] `garden_screen.dart` → página ≤120 linhas + extrair para `widgets/`:
  - `profile_card.dart`
  - `stat_card.dart`
  - `badges_card.dart`
  - `admin_link_card.dart`
- [ ] `lab_screen.dart` → página ≤120 linhas + extrair seções para `widgets/`
- [ ] `about_page.dart` → página ≤120 linhas + extrair seções para `widgets/`
- [ ] `admin_dashboard.dart` → página ≤120 linhas + extrair seções para `widgets/`
- [ ] `global_assistant.dart` → dividir em `assistant_fab.dart` + `assistant_chat.dart` + widgets
- [ ] `horta_navbar.dart` → extrair `navbar_item.dart`, `user_menu.dart`, `language_toggle.dart`
- [ ] `survey_detail_screen.dart` → página ≤120 linhas (tabs já estão em `widgets/`)
- [ ] `login_page.dart` → página ≤120 linhas + extrair:
  - `login_card.dart`
  - `background_glow.dart`

### Fase 6 — `_exports.dart`

- [ ] Criar `_exports.dart` em cada subpasta de cada módulo
- [ ] Criar `_exports.dart` na raiz de cada módulo
- [ ] Criar `_exports.dart` em `core/` e suas subpastas
- [ ] Atualizar imports nas telas e no router para usar `_exports.dart`

---

## Estrutura alvo completa

```
lib/
├── app/
│   ├── core/
│   │   ├── _exports.dart
│   │   ├── auth/
│   │   │   ├── auth_service.dart
│   │   │   └── _exports.dart
│   │   ├── di/
│   │   │   ├── injection.dart
│   │   │   └── _exports.dart
│   │   ├── network/
│   │   │   ├── api_service.dart
│   │   │   └── _exports.dart
│   │   ├── router/
│   │   │   ├── app_router.dart
│   │   │   └── _exports.dart
│   │   ├── storage/
│   │   │   ├── storage_service.dart
│   │   │   └── _exports.dart
│   │   ├── theme/
│   │   │   ├── app_theme.dart
│   │   │   └── _exports.dart
│   │   └── widgets/
│   │       ├── bento_card.dart
│   │       ├── global_assistant/
│   │       │   ├── assistant_fab.dart
│   │       │   ├── assistant_chat.dart
│   │       │   └── _exports.dart
│   │       ├── horta_logo.dart
│   │       ├── horta_navbar/
│   │       │   ├── horta_navbar.dart
│   │       │   ├── navbar_item.dart
│   │       │   └── _exports.dart
│   │       ├── main_shell.dart
│   │       ├── plant_progress_bar.dart
│   │       └── _exports.dart
│   └── modules/
│       ├── auth/
│       │   ├── auth_binds.dart
│       │   ├── _exports.dart
│       │   └── presenter/
│       │       ├── login_page.dart
│       │       ├── cubits/
│       │       │   ├── auth_cubit.dart
│       │       │   ├── auth_state.dart
│       │       │   └── _exports.dart
│       │       └── widgets/
│       │           ├── login_card.dart
│       │           ├── background_glow.dart
│       │           └── _exports.dart
│       ├── nursery/
│       │   ├── nursery_binds.dart
│       │   ├── _exports.dart
│       │   ├── data/
│       │   │   ├── nursery_datasource.dart
│       │   │   ├── nursery_datasource_impl.dart
│       │   │   └── _exports.dart
│       │   ├── domain/
│       │   │   ├── entities/
│       │   │   │   ├── survey.dart
│       │   │   │   └── _exports.dart
│       │   │   └── repositories/
│       │   │       ├── nursery_repository.dart
│       │   │       └── _exports.dart
│       │   └── presenter/
│       │       ├── nursery_page.dart
│       │       ├── _exports.dart
│       │       ├── cubits/
│       │       │   ├── nursery_cubit.dart
│       │       │   ├── nursery_state.dart
│       │       │   └── _exports.dart
│       │       └── widgets/
│       │           ├── survey_card.dart
│       │           ├── tag_filter_bar.dart
│       │           ├── tag_chip.dart
│       │           ├── pill_button.dart
│       │           ├── empty_state.dart
│       │           ├── request_survey_modal.dart
│       │           ├── survey_ai_tab.dart
│       │           ├── survey_chat_tab.dart
│       │           ├── survey_form_tab.dart
│       │           ├── survey_table_tab.dart
│       │           └── _exports.dart
│       ├── garden/
│       │   ├── garden_binds.dart
│       │   ├── _exports.dart
│       │   ├── data/
│       │   │   ├── garden_datasource.dart
│       │   │   ├── garden_datasource_impl.dart
│       │   │   └── _exports.dart
│       │   ├── domain/
│       │   │   ├── entities/
│       │   │   │   ├── user_profile.dart
│       │   │   │   └── _exports.dart
│       │   │   └── repositories/
│       │   │       ├── garden_repository.dart
│       │   │       └── _exports.dart
│       │   └── presenter/
│       │       ├── garden_page.dart
│       │       ├── _exports.dart
│       │       ├── cubits/
│       │       │   ├── garden_cubit.dart
│       │       │   ├── garden_state.dart
│       │       │   └── _exports.dart
│       │       └── widgets/
│       │           ├── profile_card.dart
│       │           ├── stat_card.dart
│       │           ├── badges_card.dart
│       │           ├── admin_link_card.dart
│       │           └── _exports.dart
│       ├── lab/
│       │   ├── lab_binds.dart
│       │   ├── _exports.dart
│       │   └── presenter/
│       │       ├── lab_page.dart
│       │       ├── _exports.dart
│       │       ├── cubits/
│       │       │   ├── lab_cubit.dart
│       │       │   ├── lab_state.dart
│       │       │   └── _exports.dart
│       │       └── widgets/
│       │           └── _exports.dart
│       ├── about/
│       │   ├── _exports.dart
│       │   └── presenter/
│       │       ├── about_page.dart
│       │       ├── _exports.dart
│       │       └── widgets/
│       │           └── _exports.dart
│       └── admin/
│           ├── admin_binds.dart
│           ├── _exports.dart
│           ├── data/
│           │   ├── admin_datasource.dart
│           │   ├── admin_datasource_impl.dart
│           │   └── _exports.dart
│           └── presenter/
│               ├── admin_page.dart
│               ├── _exports.dart
│               ├── cubits/
│               │   ├── admin_cubit.dart
│               │   ├── admin_state.dart
│               │   └── _exports.dart
│               └── widgets/
│                   └── _exports.dart
└── main.dart
```

---

## Regras de import após refactor

- Nunca importar arquivos individuais de outra pasta — sempre importar o `_exports.dart` da pasta.
- Imports dentro do mesmo módulo podem referenciar diretamente.
- O `app_router.dart` importa apenas `_exports.dart` de cada módulo.

**Exemplo correto:**
```dart
// ✅
import '../../../core/widgets/_exports.dart';
import '../../nursery/_exports.dart';

// ✗ errado
import '../../../core/widgets/horta_navbar.dart';
import '../../nursery/presenter/nursery_page.dart';
```
