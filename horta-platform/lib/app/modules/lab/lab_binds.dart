import 'package:get_it/get_it.dart';
import 'data/lab_datasource.dart';
import 'data/lab_datasource_impl.dart';
import 'presenter/cubits/lab_cubit.dart';

void setupLabBinds(GetIt sl) {
  sl.registerLazySingleton<LabDatasource>(() => LabDatasourceImpl(sl()));
  sl.registerFactory<LabInsightsCubit>(() => LabInsightsCubit(sl()));
  sl.registerFactory<LabChatCubit>(() => LabChatCubit(sl()));
}
