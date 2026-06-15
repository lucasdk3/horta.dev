import 'package:get_it/get_it.dart';
import 'presenter/cubits/auth_cubit.dart';

void setupAuthBinds(GetIt sl) {
  sl.registerFactory<AuthCubit>(() => AuthCubit(sl()));
}
