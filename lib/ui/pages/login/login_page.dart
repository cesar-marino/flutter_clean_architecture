import 'package:flutter/material.dart';

import '../../components/components.dart';

import 'login_presenter.dart';

class LoginPage extends StatelessWidget {
  final LoginPresenter presenter;

  LoginPage({@required this.presenter});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            LoginHeader(),
            Headline1(text: 'Login'),
            Padding(
              padding: const EdgeInsets.all(32),
              child: Form(
                child: Column(
                  children: [
                    StreamBuilder<String>(
                      stream: presenter.emailErrorStream,
                      builder: (context, snapshot) {
                        return TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            errorText: snapshot.data?.isEmpty == true
                                ? null
                                : snapshot.data,
                            icon: Icon(
                              Icons.mail_outline,
                              color: Theme.of(context).primaryColorLight,
                            ),
                          ),
                          onChanged: presenter.validateEmail,
                        );
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8, bottom: 32),
                      child: StreamBuilder<String>(
                        stream: presenter.passwordErrorStream,
                        builder: (context, snapshot) {
                          return TextFormField(
                            obscureText: true,
                            onChanged: presenter.validatePassword,
                            decoration: InputDecoration(
                              labelText: 'Senha',
                              icon: Icon(
                                Icons.lock_outline,
                                color: Theme.of(context).primaryColorLight,
                              ),
                              errorText: snapshot.data?.isEmpty == true
                                  ? null
                                  : snapshot.data,
                            ),
                          );
                        },
                      ),
                    ),
                    StreamBuilder<bool>(
                      stream: presenter.isFormValidStream,
                      builder: (context, snapshot) {
                        return RaisedButton(
                          onPressed: snapshot.data == true ? () {} : null,
                          child: Text('Entrar'.toUpperCase()),
                        );
                      },
                    ),
                    FlatButton.icon(
                      onPressed: () {},
                      icon: Icon(Icons.person_outline),
                      label: Text('Criar Conta'),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
