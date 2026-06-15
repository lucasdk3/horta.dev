import 'package:get_it/get_it.dart';
import 'data/garden_datasource.dart';
import 'data/garden_datasource_impl.dart';
import 'domain/repositories/garden_repository.dart';
import 'domain/repositories/garden_repository_impl.dart';
import 'presenter/cubits/garden_cubit.dart';

void setupGardenBinds(GetIt sl) {
  sl.registerLazySingleton<GardenDatasource>(
    () => GardenDatasourceImpl(sl()),
  );
  sl.registerLazySingleton<GardenRepository>(
    () => GardenRepositoryImpl(sl()),
  );
  sl.registerFactory<GardenCubit>(
    () => GardenCubit(sl()),
  );
}
