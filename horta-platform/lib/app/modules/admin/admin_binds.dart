import 'package:get_it/get_it.dart';
import 'data/admin_datasource.dart';
import 'data/admin_datasource_impl.dart';
import 'domain/repositories/admin_repository.dart';
import 'domain/repositories/admin_repository_impl.dart';
import 'presenter/cubits/admin_cubit.dart';

void setupAdminBinds(GetIt sl) {
  sl.registerLazySingleton<AdminDatasource>(
    () => AdminDatasourceImpl(sl()),
  );
  sl.registerLazySingleton<AdminRepository>(
    () => AdminRepositoryImpl(sl()),
  );
  sl.registerFactory<AdminCubit>(
    () => AdminCubit(sl()),
  );
}
