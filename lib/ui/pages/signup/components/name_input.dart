import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../helpers/helpers.dart';

import '../signup_presenter.dart';

class NameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final presenter = Provider.of<SignUpPresenter>(context);

    return StreamBuilder<UIError>(
      stream: presenter.nameErrorStream,
      builder: (context, snapshot) => TextFormField(
        keyboardType: TextInputType.name,
        onChanged: presenter.validateName,
        decoration: InputDecoration(
          labelText: R.strings.name,
          icon: Icon(
            Icons.person_outline,
            color: Theme.of(context).primaryColorLight,
          ),
          errorText: snapshot.hasData ? snapshot.data.description : null,
        ),
      ),
    );
  }
}
