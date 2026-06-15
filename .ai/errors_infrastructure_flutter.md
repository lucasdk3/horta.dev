# Errors in flutter infrastructure

## 1 - Has modules not following the struct and rules


### Rules

- [ ] Configurar `.analysis_options.yaml` com regras de linting e formatação
- [ ] A pagina não deve ter no maximo entre 100 e 120 linhas (has files with 500 lines, and 3 or 4 functions calling other layouts)
- [ ] Separar funções em arquivos menores quando possivel
- [ ] Não criar funções no mesmo arquivo que layout, utilizar pasta "components" ou "widgets" para componentes reutilizáveis
- [ ] Dentro de cada pasta use um arquivo `_exports.dart` para exportar todos os arquivos da pasta, até o root, e então use como import apenas o `_exports.dart` da raiz

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

### Change

#### Incorrect ui file struct
Example: horta-platform/lib/app/modules/nursery/presenter/nursery_screen.dart

Wrong:
```dart
  
class NurseryScreen extends StatelessWidget {
  const NurseryScreen({super.key});

  Color _accent(int i) => HortaTheme.primaryEmerald;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.I<NurseryCubit>()..load(),
      child: BlocBuilder<NurseryCubit, NurseryState>(
        builder: (context, state) {
          final cubit = context.read<NurseryCubit>();
          final isDesktop = MediaQuery.of(context).size.width > 900;
          final lang = context.locale.languageCode;

          return RefreshIndicator(
            onRefresh: cubit.load,
            color: const Color(0xFF10B981),
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 32, 24, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _HeroRow(isDesktop: isDesktop, cubit: cubit),
...
}

class _HeroRow extends StatelessWidget {
...
}
```

Correct: use two files
Screen: horta-platform/lib/app/modules/nursery/presenter/nursery_screen.dart
Component: horta-platform/lib/app/modules/nursery/presenter/widgets/nursery_hero_row.dart


#### Incorrect datasource implements
I not need it in api_service

```dart
  Future<List<Map<String, dynamic>>> getSurveys() async {
    final res = await _dio.get('/api/v1/surveys');
    final List<dynamic> data =
        res.data is List ? res.data : res.data['surveys'] ?? [];
    return data.cast<Map<String, dynamic>>();
  }
```

I need that this part stay in datasource_impl

```dart
class NurseryDatasourceImpl implements NurseryDatasource {
  const NurseryDatasourceImpl(this._api);

  final ApiService _api;

  @override
  Future<List<Map<String, dynamic>>> fetchSurveys() async {
    final res = await _api.client.get('/api/v1/surveys');
    final List<dynamic> data =
        res.data is List ? res.data : res.data['surveys'] ?? [];
    return data.cast<Map<String, dynamic>>();
  }
```

#### Incorrect auth datasource implement

Auth implement need stay in lib/modules/auth/data, no in lib/modules/core/auth