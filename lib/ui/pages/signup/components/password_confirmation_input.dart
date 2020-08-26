import 'package:flutter/material.dart';

import 'package:curso/ui/helpers/helpers.dart';

class PasswordConfirmationInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: true,
      decoration: InputDecoration(
        labelText: R.strings.confirmPassword,
        icon: Icon(
          Icons.lock_outline,
          color: Theme.of(context).primaryColorLight,
        ),
      ),
    );
  }
}
