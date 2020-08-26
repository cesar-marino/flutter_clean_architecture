import 'package:flutter/material.dart';

import '../../../helpers/helpers.dart';

class EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: R.strings.email,
        icon: Icon(
          Icons.mail_outline,
          color: Theme.of(context).primaryColorLight,
        ),
      ),
    );
  }
}
