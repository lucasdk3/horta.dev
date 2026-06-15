import '../envs/env.dart';

abstract class IConfigsService {
  String get baseUrl;
  String get ssoBaseUrl;
  String get dashboardUrl;
  String get scriptLogsUrl;
  String get defaultBranch;
}

class ConfigsService extends IConfigsService {
  final IEnvironmentService environmentServer;

  ConfigsService({required this.environmentServer});

  @override
  String get baseUrl {
    switch (environmentServer.env) {
      case Environment.dev:
        return 'http://localhost:8080';
      case Environment.stg:
        return 'https://api.stg.horta.dev';
      case Environment.prd:
        return 'https://api.horta.dev';
    }
  }

  @override
  String get ssoBaseUrl {
    switch (environmentServer.env) {
      case Environment.dev:
        return 'https://sso.dev.wevy.cloud';
      case Environment.stg:
        return 'https://sso.stg.wevy.cloud';
      case Environment.prd:
        return 'https://sso.wevy.cloud';
    }
  }

  @override
  String get dashboardUrl {
    switch (environmentServer.env) {
      case Environment.dev:
        return 'https://monitor-run.stg.wevy.cloud/d/af6lucwigydc0d/jobs?orgId=1';
      case Environment.stg:
        return 'https://monitor-run.stg.wevy.cloud/d/af6lucwigydc0d/jobs?orgId=1';
      case Environment.prd:
        return 'https://monitor-run.prd.wevy.cloud/d/af6lucwigydc0d/jobs?orgId=1';
    }
  }

  @override
  String get scriptLogsUrl {
    switch (environmentServer.env) {
      case Environment.dev:
        return 'https://monitor-run.stg.wevy.cloud/d/2cehxe9dw7ahvkb/logs-de-aplicacao-loki?orgId=1';
      case Environment.stg:
        return 'https://monitor-run.stg.wevy.cloud/d/2cehxe9dw7ahvkb/logs-de-aplicacao-loki?orgId=1';
      case Environment.prd:
        return 'https://monitor-run.prd.wevy.cloud/d/2cehxe9dw7ahvkb/logs-de-aplicacao-loki?orgId=1';
    }
  }

  @override
  String get defaultBranch {
    switch (environmentServer.env) {
      case Environment.dev:
        return 'develop';
      case Environment.stg:
        return 'release';
      case Environment.prd:
        return 'main';
    }
  }
}
