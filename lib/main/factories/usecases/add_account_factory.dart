import '../../../data/usecases/usecases.dart';

import '../../../domain/usecases/usecases.dart';

import '../factories.dart';

AddAccount makeRemoteAddAccount() {
  return RemoteAddAccount(client: makeHttpAdapter(), url: makeApiUrl('signup'));
}
