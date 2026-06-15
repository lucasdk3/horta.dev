import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/garden_repository.dart';

part 'garden_state.dart';

class GardenCubit extends Cubit<GardenState> {
  GardenCubit(this._repository) : super(GardenLoading());

  final GardenRepository _repository;

  Future<void> load() async {
    emit(GardenLoading());
    final result = await _repository.fetchMyProfile();
    result.fold(
      (failure) => emit(GardenError(failure.message)),
      (profile) => emit(GardenLoaded(profile)),
    );
  }
}
