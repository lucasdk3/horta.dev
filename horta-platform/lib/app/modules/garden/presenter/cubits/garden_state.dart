part of 'garden_cubit.dart';

sealed class GardenState {}

final class GardenLoading extends GardenState {}

final class GardenLoaded extends GardenState {
  GardenLoaded(this.profile);
  final UserProfile profile;
}

final class GardenError extends GardenState {
  GardenError(this.message);
  final String message;
}
