import 'package:flutter/material.dart';
import '../core/localization/language_constants.dart';

class LanguageProvider extends ChangeNotifier {
  Locale _currentLocale = koreanLocale;

  Locale get currentLocale => _currentLocale;

  void setLocale(Locale locale) {
    if (!supportedLocales.contains(locale)) return;

    _currentLocale = locale;
    notifyListeners();
  }

  String getLanguageName() {
    switch (_currentLocale.languageCode) {
      case 'ko':
        return '한국어';
      case 'vi':
        return 'Tiếng Việt';
      default:
        return '한국어';
    }
  }
}
