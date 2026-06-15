import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/lab_datasource.dart';

part 'lab_state.dart';

class ChatMessage {
  const ChatMessage({required this.role, required this.text});
  final String role;
  final String text;
}

class LabInsightsCubit extends Cubit<LabInsightsState> {
  LabInsightsCubit(this._datasource) : super(LabInsightsLoading());

  final LabDatasource _datasource;

  Future<void> load(String lang) async {
    emit(LabInsightsLoading());
    try {
      final surveys = await _datasource.fetchSurveys();
      emit(LabInsightsLoaded(surveys: surveys, summaries: {}, loadingIds: {}));
      for (final s in surveys) {
        fetchSummary(s['id'] as String, lang);
      }
    } catch (e) {
      emit(LabInsightsError(e.toString()));
    }
  }

  Future<void> fetchSummary(String id, String lang,
      {String country = 'Global'}) async {
    final current = state;
    if (current is! LabInsightsLoaded) return;
    emit(LabInsightsLoaded(
      surveys: current.surveys,
      summaries: current.summaries,
      loadingIds: {...current.loadingIds, id},
      countryFilter: current.countryFilter,
    ));
    try {
      final summary = await _datasource.fetchSurveySummary(
          surveyId: id, lang: lang, countryFilter: country);
      final updated = {...current.summaries, id: summary};
      final loaded = state as LabInsightsLoaded;
      emit(LabInsightsLoaded(
        surveys: loaded.surveys,
        summaries: updated,
        loadingIds: loaded.loadingIds..remove(id),
        countryFilter: loaded.countryFilter,
      ));
    } catch (_) {
      final loaded = state as LabInsightsLoaded;
      emit(LabInsightsLoaded(
        surveys: loaded.surveys,
        summaries: {...loaded.summaries, id: null},
        loadingIds: loaded.loadingIds..remove(id),
        countryFilter: loaded.countryFilter,
      ));
    }
  }
}

class LabChatCubit extends Cubit<LabChatState> {
  LabChatCubit(this._datasource) : super(LabChatIdle());

  final LabDatasource _datasource;

  Future<void> send(String text, String lang) async {
    final current = state as LabChatIdle;
    if (text.trim().isEmpty || current.isLoading) return;
    final updated = [
      ...current.messages,
      ChatMessage(role: 'user', text: text.trim())
    ];
    emit(current.copyWith(messages: updated, isLoading: true));
    try {
      final history = updated
          .take(updated.length - 1)
          .map((m) => {'role': m.role, 'parts': m.text})
          .toList();
      final reply = await _datasource.chatGlobal(
        surveysMetadata: const [],
        history: history,
        message: text.trim(),
        lang: lang,
      );
      final cur = state as LabChatIdle;
      emit(cur.copyWith(
        messages: [...cur.messages, ChatMessage(role: 'model', text: reply)],
        isLoading: false,
      ));
    } catch (_) {
      final cur = state as LabChatIdle;
      emit(cur.copyWith(
        messages: [
          ...cur.messages,
          const ChatMessage(role: 'model', text: 'Error')
        ],
        isLoading: false,
      ));
    }
  }
}
