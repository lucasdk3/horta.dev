part of 'admin_cubit.dart';

sealed class AdminState {}

final class AdminLoading extends AdminState {}

final class AdminLoaded extends AdminState {
  AdminLoaded(this.requests);
  final List<SurveyRequest> requests;
}

final class AdminError extends AdminState {
  AdminError(this.message);
  final String message;
}
