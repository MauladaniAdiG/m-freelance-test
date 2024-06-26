import 'dart:convert';

import 'package:app/r.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

abstract class AppLocalizationBase {
  Future<AppLocalization> load(Locale locale);
  Iterable<Locale> get supportedLocales;
  String localize(String key);
}

class AppLocalization extends AppLocalizationBase {
  late Locale locale;

  static List<String> supportedFormats = ['id'];
  static const Locale defaultLocale = Locale('id', 'ID');
  static Map<String, dynamic> _localizationMap = {};
  AppLocalization._(Locale loc) {
    locale = loc;
  }
  static AppLocalization get current =>
      AppLocalization._(WidgetsBinding.instance.platformDispatcher.locale);
  static final delegate = _AppLocalizationDelegate();

  @override
  Iterable<Locale> get supportedLocales =>
      supportedFormats.map<Locale>((e) => Locale(e, '')).toList();

  @override
  Future<AppLocalization> load(Locale locale) async {
    locale = defaultLocale;
    final appLocalization = AppLocalization._(locale);
    final assetLocalization =
        await rootBundle.loadString(R.languageCode(locale.languageCode));
    _localizationMap = json.decode(assetLocalization);
    return appLocalization;
  }

  @override
  String localize(String key) {
    return _localizationMap[key] ?? key;
  }
}

class _AppLocalizationDelegate extends LocalizationsDelegate<AppLocalization> {
  @override
  bool isSupported(Locale locale) =>
      AppLocalization.supportedFormats.contains(locale.languageCode);

  @override
  Future<AppLocalization> load(Locale locale) =>
      AppLocalization.current.load(locale);

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalization> old) =>
      false;
}
