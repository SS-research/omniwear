import 'package:omniwear/config/config.dart';

class ConfigManager {
  static final ConfigManager _instance = ConfigManager._internal();
  late Config _config;

  ConfigManager._internal();

  static ConfigManager get instance => _instance;

  Future<void> loadConfig(String path) async {
    _config = await Config.loadFromPath(path);
  }

  Config get config => _config;
}
