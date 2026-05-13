import '../../../core/localization/app_locale.dart';
import '../../../core/localization/app_strings.dart';

enum PortfolioSection {
  home,
  about,
  projects,
  contacts;

  String localizedLabel(AppLocale locale) {
    final strings = AppStrings.of(locale);
    return switch (this) {
      home => strings.home,
      about => strings.about,
      projects => strings.projects,
      contacts => strings.contact,
    };
  }
}
