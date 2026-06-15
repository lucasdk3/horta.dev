import 'package:get_it/get_it.dart';
import 'data/nursery_datasource.dart';
import 'data/nursery_datasource_impl.dart';
import 'domain/repositories/nursery_repository.dart';
import 'domain/repositories/nursery_repository_impl.dart';
import 'presenter/cubits/nursery_cubit.dart';

void setupNurseryBinds(GetIt sl) {
  sl.registerLazySingleton<NurseryDatasource>(
    () => NurseryDatasourceImpl(sl()),
  );
  sl.registerLazySingleton<NurseryRepository>(
    () => NurseryRepositoryImpl(sl()),
  );
  sl.registerFactory<NurseryCubit>(
    () => NurseryCubit(sl()),
  );
}
