import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:curso/ui/helpers/helpers.dart';
import '../login_presenter.dart';

class PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final presenter = Provider.of<LoginPresenter>(context);

    return StreamBuilder<UIError>(
      stream: presenter.passwordErrorStream,
      builder: (context, snapshot) {
        return TextFormField(
          obscureText: true,
          onChanged: presenter.validatePassword,
          decoration: InputDecoration(
            labelText: R.strings.password,
            icon: Icon(
              Icons.lock_outline,
              color: Theme.of(context).primaryColorLight,
            ),
            errorText: snapshot.hasData ? snapshot.data.description : null,
          ),
        );
      },
    );
  }
}
