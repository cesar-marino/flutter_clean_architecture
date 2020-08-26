import 'package:flutter/material.dart';

import '../../../helpers/helpers.dart';

class NameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.name,
      decoration: InputDecoration(
        labelText: R.strings.name,
        icon: Icon(
          Icons.person_outline,
          color: Theme.of(context).primaryColorLight,
        ),
      ),
    );
  }
}
