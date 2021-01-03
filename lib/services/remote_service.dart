import 'package:firebase_remote_config/firebase_remote_config.dart';

class RemoteService {
  RemoteConfig _remoteConfig;

  RemoteService() {}

  Future<void> init() async {
    _remoteConfig = await RemoteConfig.instance;

    final defaults = <String, dynamic>{'available': true};

    await remoteConfig.setDefaults(defaults);
    await remoteConfig.fetch(expiration: Duration(seconds: 0));
    await remoteConfig.activateFetched();
  }

  RemoteConfig get remoteConfig => _remoteConfig;

  Future<void> getRemoteData() async {
    await remoteConfig.fetch(expiration: Duration(seconds: 0));
    await remoteConfig.activateFetched();
  }
}
