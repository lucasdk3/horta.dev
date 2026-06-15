enum Flavor {
  dev,
  stg,
  prd,
}

class F {
  static late final Flavor appFlavor;

  static String get name => appFlavor.name;

  static String get title {
    switch (appFlavor) {
      case Flavor.dev:
        return 'Horta Dev';
      case Flavor.stg:
        return 'Horta Stg';
      case Flavor.prd:
        return 'Horta';
    }
  }

}
