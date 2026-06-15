import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/survey.dart';
import '../../domain/repositories/nursery_repository.dart';

part 'nursery_state.dart';

class NurseryCubit extends Cubit<NurseryState> {
  NurseryCubit(this._repository) : super(NurseryLoading());

  final NurseryRepository _repository;

  Future<void> load() async {
    emit(NurseryLoading());
    final result = await _repository.fetchSurveys();
    result.fold(
      (failure) => emit(NurseryError(failure.message)),
      (surveys) => emit(NurseryLoaded(surveys: surveys)),
    );
  }

  void selectTag(String? tag) {
    final current = state;
    if (current is! NurseryLoaded) return;
    emit(current.copyWith(selectedTag: tag));
  }
}
