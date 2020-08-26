import 'package:flutter/material.dart';

import 'package:curso/ui/helpers/helpers.dart';

class PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: true,
      decoration: InputDecoration(
        labelText: R.strings.password,
        icon: Icon(
          Icons.lock_outline,
          color: Theme.of(context).primaryColorLight,
        ),
      ),
    );
  }
}
