import 'package:net_worth_manager/utils/enum/app_theme_enum.dart';
import 'package:objectbox/objectbox.dart';
import 'currency_obox.dart';

@Entity()
class Settings {
  @Id()
  int id = 0;

  ToOne<Currency> defaultCurrency = ToOne<Currency>();

  @Property(type: PropertyType.date)
  DateTime? startDateGainGraph;

  @Property(type: PropertyType.date)
  DateTime? endDateGainGraph;

  int? homeGraphIndex;

  bool? showTutorial;

  int? appThemeEnumIndex;

  Settings({required this.showTutorial});

  AppThemeEnum get appTheme {
    return AppThemeEnum.values[appThemeEnumIndex ?? 1];
  }

  bool isDarkMode() {
    return appTheme == AppThemeEnum.dark;
  }
}
