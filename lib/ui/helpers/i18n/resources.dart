import 'package:flutter/widgets.dart';

import 'strings/strings.dart';

class R {
  static Translations strings = PtBr();

  static void load(Locale locale) {
    switch (locale.toString()) {
      case 'en_US':
        strings = PtBr();
        break;
      default:
        strings = PtBr();
        break;
    }
  }
}
