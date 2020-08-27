import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../helpers/helpers.dart';

import '../signup_presenter.dart';

class EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final presenter = Provider.of<SignUpPresenter>(context);

    return StreamBuilder<UIError>(
      stream: presenter.emailErrorStream,
      builder: (context, snapshot) => TextFormField(
        keyboardType: TextInputType.emailAddress,
        onChanged: presenter.validateEmail,
        decoration: InputDecoration(
          labelText: R.strings.email,
          icon: Icon(
            Icons.mail_outline,
            color: Theme.of(context).primaryColorLight,
          ),
          errorText: snapshot.hasData ? snapshot.data.description : null,
        ),
      ),
    );
  }
}
