import 'dart:developer';

enum EnvirontmentType { dev, prod }

class AppConfig {
  static Map<String, dynamic> _config = _Config.prod;
  static EnvirontmentType _envType = EnvirontmentType.prod;

  static void setupEnv() {
    String appEnv = const String.fromEnvironment('FLAVOUR_MODE');
    final env = EnvirontmentType.values.firstWhere(
      (element) => element.toString() == 'EnvirontmentType.$appEnv',
      orElse: () => EnvirontmentType.dev,
    );
    setEnvirontment(env);
    log('run on env -> $env');
  }

  static void setEnvirontment(EnvirontmentType env) {
    _envType = env;
    switch (_envType) {
      case EnvirontmentType.dev:
        _config = _Config.dev;
        break;
      case EnvirontmentType.prod:
        _config = _Config.prod;
        break;
      default:
        _config = _Config.prod;
        break;
    }
  }

  static bool get isProd => _config == _Config.prod;

  static String get baseUrl => _config[_Config.baseUrl];
}

class _Config {
  static const String baseUrl = 'baseUrl';

  static Map<String, dynamic> dev = {
    baseUrl: 'http://127.0.0.1:8000/v1',
  };

  static Map<String, dynamic> prod = {
    baseUrl: 'http://127.0.0.1:8000/v1',
  };
}
