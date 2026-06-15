import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import '../auth/auth_service.dart';
import '../configs/config_service.dart';
import '../envs/env.dart';
import '../network/api_service.dart';
import '../storage/storage_service.dart';
import '../theme/theme_notifier.dart';
import '../../modules/nursery/nursery_binds.dart';
import '../../modules/garden/garden_binds.dart';
import '../../modules/admin/admin_binds.dart';
import '../../modules/lab/lab_binds.dart';
import '../../modules/auth/auth_binds.dart';

final GetIt sl = GetIt.instance;

Future<void> setupInjection() async {
  const storage = FlutterSecureStorage();

  sl.registerSingleton<FlutterSecureStorage>(storage);
  sl.registerSingleton<StorageService>(const StorageService(storage));
  sl.registerSingleton<IEnvironmentService>(const EnvironmentServer());
  sl.registerSingleton<IConfigsService>(
    ConfigsService(environmentServer: sl<IEnvironmentService>()),
  );
  sl.registerSingleton<ApiService>(
    ApiService(storage: storage, configsService: sl<IConfigsService>()),
  );
  sl.registerSingleton<AuthService>(AuthService());
  sl.registerSingleton<ThemeNotifier>(ThemeNotifier());

  setupNurseryBinds(sl);
  setupGardenBinds(sl);
  setupAdminBinds(sl);
  setupLabBinds(sl);
  setupAuthBinds(sl);
}
