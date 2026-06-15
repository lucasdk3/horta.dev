part of 'lab_cubit.dart';

sealed class LabInsightsState {}

final class LabInsightsLoading extends LabInsightsState {}

final class LabInsightsLoaded extends LabInsightsState {
  LabInsightsLoaded({
    required this.surveys,
    required this.summaries,
    required this.loadingIds,
    this.countryFilter = 'Global',
  });

  final List<Map<String, dynamic>> surveys;
  final Map<String, String?> summaries;
  final Set<String> loadingIds;
  final String countryFilter;

  bool isLoadingId(String id) => loadingIds.contains(id);
}

final class LabInsightsError extends LabInsightsState {
  LabInsightsError(this.message);
  final String message;
}

// ─── Chat ────────────────────────────────────────────────────────────────────

sealed class LabChatState {}

final class LabChatIdle extends LabChatState {
  LabChatIdle({this.messages = const [], this.isLoading = false});
  final List<ChatMessage> messages;
  final bool isLoading;

  LabChatIdle copyWith({List<ChatMessage>? messages, bool? isLoading}) =>
      LabChatIdle(
        messages: messages ?? this.messages,
        isLoading: isLoading ?? this.isLoading,
      );
}
