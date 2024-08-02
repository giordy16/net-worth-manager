import '../../i18n/strings.g.dart';

enum AppThemeEnum {
  light,
  dark;

  @override
  String toString() {
    switch (this) {
      case AppThemeEnum.light:
        return t.app_theme_light;
      case AppThemeEnum.dark:
        return t.app_theme_dark;
    }
  }
}
