import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/survey_request.dart';
import '../../domain/repositories/admin_repository.dart';

part 'admin_state.dart';

class AdminCubit extends Cubit<AdminState> {
  AdminCubit(this._repository) : super(AdminLoading());

  final AdminRepository _repository;

  Future<void> load() async {
    emit(AdminLoading());
    final result = await _repository.fetchSurveyRequests();
    result.fold(
      (failure) => emit(AdminError(failure.message)),
      (requests) => emit(AdminLoaded(requests)),
    );
  }

  Future<void> approve(String id) async {
    await _repository.approve(id);
    await load();
  }

  Future<void> reject(String id) async {
    await _repository.reject(id);
    await load();
  }

  Future<void> delete(String id) async {
    await _repository.delete(id);
    await load();
  }
}
