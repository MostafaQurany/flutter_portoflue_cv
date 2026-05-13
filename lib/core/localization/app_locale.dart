import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AppLocale {
  en('English', Locale('en')),
  ar('العربية', Locale('ar'));

  const AppLocale(this.name, this.locale);
  final String name;
  final Locale locale;

  bool get isRtl => this == AppLocale.ar;
  TextDirection get direction => isRtl ? TextDirection.rtl : TextDirection.ltr;
}

final localeProvider = StateProvider<AppLocale>((ref) => AppLocale.en);
