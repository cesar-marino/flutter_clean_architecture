import 'package:meta/meta.dart';

import '../../../domain/entities/account_entity.dart';
import '../../../domain/usecases/usecases.dart';

import '../../http/http.dart';

class RemoteAddAccount implements AddAccount {
  final HttpClient client;
  final String url;

  RemoteAddAccount({@required this.client, @required this.url});

  @override
  Future<AccountEntity> add(AddAccountParams params) async {
    final body = RemoteAddAccountParams.fromEntity(params).toJson();
    await client.request(url: url, method: 'post', body: body);
  }
}

class RemoteAddAccountParams {
  final String name;
  final String email;
  final String password;
  final String passwordConfirmation;

  RemoteAddAccountParams({
    @required this.name,
    @required this.email,
    @required this.password,
    @required this.passwordConfirmation,
  });

  factory RemoteAddAccountParams.fromEntity(AddAccountParams params) {
    return RemoteAddAccountParams(
      name: params.name,
      email: params.email,
      password: params.password,
      passwordConfirmation: params.passwordConfirmation,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'passwordConfirmation': passwordConfirmation,
    };
  }
}
