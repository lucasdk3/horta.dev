import '../../../flavors.dart';

enum Environment { dev, stg, prd }

abstract class IEnvironmentService {
  Environment get env;
}

class EnvironmentServer implements IEnvironmentService {
  const EnvironmentServer();

  @override
  Environment get env {
    switch (F.appFlavor) {
      case Flavor.dev:
        return Environment.dev;
      case Flavor.stg:
        return Environment.stg;
      case Flavor.prd:
        return Environment.prd;
    }
  }
}
