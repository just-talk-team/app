import 'package:firebase_remote_config/firebase_remote_config.dart';

class RemoteService {
  RemoteConfig _remoteConfig;

  RemoteService() {
    init();
  }
  Future<void> init() async {
    _remoteConfig = await RemoteConfig.instance;

    final defaults = <String, dynamic>{'BadgesView': '1'};

    await remoteConfig.setDefaults(defaults);
    await remoteConfig.fetch(expiration: const Duration(hours: 5));
    await remoteConfig.activateFetched();
  }
  RemoteConfig get remoteConfig => _remoteConfig;
}
