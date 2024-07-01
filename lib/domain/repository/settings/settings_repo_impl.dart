import 'package:get_it/get_it.dart';
import 'package:net_worth_manager/domain/repository/settings/settings_repo.dart';
import 'package:net_worth_manager/models/obox/currency_obox.dart';
import 'package:net_worth_manager/models/obox/settings_obox.dart';
import 'package:objectbox/objectbox.dart';

class SettingsRepoImpl extends SettingsRepo {

  Box<Settings> box = GetIt.I<Store>().box<Settings>();

  @override
  Currency? getDefaultCurrency() {
    return box.getAll().first.defaultCurrency.target;
  }

  @override
  void setCurrency(Currency currency) {
    Settings settings = box.getAll().first;
    settings.defaultCurrency.target = currency;
    box.put(settings);
  }
}
