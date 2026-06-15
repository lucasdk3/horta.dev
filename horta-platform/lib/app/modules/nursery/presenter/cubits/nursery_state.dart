part of 'nursery_cubit.dart';

sealed class NurseryState {}

final class NurseryLoading extends NurseryState {}

final class NurseryLoaded extends NurseryState {
  NurseryLoaded({required this.surveys, this.selectedTag});

  final List<Survey> surveys;
  final String? selectedTag;

  List<String> get allTags =>
      surveys.expand((s) => s.tags).toSet().toList();

  List<Survey> get filtered => selectedTag == null
      ? surveys
      : surveys.where((s) => s.tags.contains(selectedTag)).toList();

  NurseryLoaded copyWith({List<Survey>? surveys, Object? selectedTag = _sentinel}) {
    return NurseryLoaded(
      surveys: surveys ?? this.surveys,
      selectedTag:
          selectedTag == _sentinel ? this.selectedTag : selectedTag as String?,
    );
  }
}

final class NurseryError extends NurseryState {
  NurseryError(this.message);
  final String message;
}

const _sentinel = Object();
