/// Generated file. Do not edit.
///
/// Original: lib/i18n
/// To regenerate, run: `dart run slang`
///
/// Locales: 2
/// Strings: 308 (154 per locale)
///
/// Built on 2024-07-14 at 09:15 UTC

// coverage:ignore-file
// ignore_for_file: type=lint

import 'package:flutter/widgets.dart';
import 'package:slang/builder/model/node.dart';
import 'package:slang_flutter/slang_flutter.dart';
export 'package:slang_flutter/slang_flutter.dart';

const AppLocale _baseLocale = AppLocale.en;

/// Supported locales, see extension methods below.
///
/// Usage:
/// - LocaleSettings.setLocale(AppLocale.en) // set locale
/// - Locale locale = AppLocale.en.flutterLocale // get flutter locale from enum
/// - if (LocaleSettings.currentLocale == AppLocale.en) // locale check
enum AppLocale with BaseAppLocale<AppLocale, Translations> {
	en(languageCode: 'en', build: Translations.build),
	it(languageCode: 'it', build: _StringsIt.build);

	const AppLocale({required this.languageCode, this.scriptCode, this.countryCode, required this.build}); // ignore: unused_element

	@override final String languageCode;
	@override final String? scriptCode;
	@override final String? countryCode;
	@override final TranslationBuilder<AppLocale, Translations> build;

	/// Gets current instance managed by [LocaleSettings].
	Translations get translations => LocaleSettings.instance.translationMap[this]!;
}

/// Method A: Simple
///
/// No rebuild after locale change.
/// Translation happens during initialization of the widget (call of t).
/// Configurable via 'translate_var'.
///
/// Usage:
/// String a = t.someKey.anotherKey;
/// String b = t['someKey.anotherKey']; // Only for edge cases!
Translations get t => LocaleSettings.instance.currentTranslations;

/// Method B: Advanced
///
/// All widgets using this method will trigger a rebuild when locale changes.
/// Use this if you have e.g. a settings page where the user can select the locale during runtime.
///
/// Step 1:
/// wrap your App with
/// TranslationProvider(
/// 	child: MyApp()
/// );
///
/// Step 2:
/// final t = Translations.of(context); // Get t variable.
/// String a = t.someKey.anotherKey; // Use t variable.
/// String b = t['someKey.anotherKey']; // Only for edge cases!
class TranslationProvider extends BaseTranslationProvider<AppLocale, Translations> {
	TranslationProvider({required super.child}) : super(settings: LocaleSettings.instance);

	static InheritedLocaleData<AppLocale, Translations> of(BuildContext context) => InheritedLocaleData.of<AppLocale, Translations>(context);
}

/// Method B shorthand via [BuildContext] extension method.
/// Configurable via 'translate_var'.
///
/// Usage (e.g. in a widget's build method):
/// context.t.someKey.anotherKey
extension BuildContextTranslationsExtension on BuildContext {
	Translations get t => TranslationProvider.of(this).translations;
}

/// Manages all translation instances and the current locale
class LocaleSettings extends BaseFlutterLocaleSettings<AppLocale, Translations> {
	LocaleSettings._() : super(utils: AppLocaleUtils.instance);

	static final instance = LocaleSettings._();

	// static aliases (checkout base methods for documentation)
	static AppLocale get currentLocale => instance.currentLocale;
	static Stream<AppLocale> getLocaleStream() => instance.getLocaleStream();
	static AppLocale setLocale(AppLocale locale, {bool? listenToDeviceLocale = false}) => instance.setLocale(locale, listenToDeviceLocale: listenToDeviceLocale);
	static AppLocale setLocaleRaw(String rawLocale, {bool? listenToDeviceLocale = false}) => instance.setLocaleRaw(rawLocale, listenToDeviceLocale: listenToDeviceLocale);
	static AppLocale useDeviceLocale() => instance.useDeviceLocale();
	@Deprecated('Use [AppLocaleUtils.supportedLocales]') static List<Locale> get supportedLocales => instance.supportedLocales;
	@Deprecated('Use [AppLocaleUtils.supportedLocalesRaw]') static List<String> get supportedLocalesRaw => instance.supportedLocalesRaw;
	static void setPluralResolver({String? language, AppLocale? locale, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver}) => instance.setPluralResolver(
		language: language,
		locale: locale,
		cardinalResolver: cardinalResolver,
		ordinalResolver: ordinalResolver,
	);
}

/// Provides utility functions without any side effects.
class AppLocaleUtils extends BaseAppLocaleUtils<AppLocale, Translations> {
	AppLocaleUtils._() : super(baseLocale: _baseLocale, locales: AppLocale.values);

	static final instance = AppLocaleUtils._();

	// static aliases (checkout base methods for documentation)
	static AppLocale parse(String rawLocale) => instance.parse(rawLocale);
	static AppLocale parseLocaleParts({required String languageCode, String? scriptCode, String? countryCode}) => instance.parseLocaleParts(languageCode: languageCode, scriptCode: scriptCode, countryCode: countryCode);
	static AppLocale findDeviceLocale() => instance.findDeviceLocale();
	static List<Locale> get supportedLocales => instance.supportedLocales;
	static List<String> get supportedLocalesRaw => instance.supportedLocalesRaw;
}

// translations

// Path: <root>
class Translations implements BaseTranslations<AppLocale, Translations> {
	/// Returns the current translations of the given [context].
	///
	/// Usage:
	/// final t = Translations.of(context);
	static Translations of(BuildContext context) => InheritedLocaleData.of<AppLocale, Translations>(context).translations;

	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	Translations.build({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = TranslationMetadata(
		    locale: AppLocale.en,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <en>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	dynamic operator[](String key) => $meta.getTranslation(key);

	late final Translations _root = this; // ignore: unused_field

	// Translations
	String get done => 'Done!';
	String get position => 'Position';
	String get report_a_sell => 'Report a sell';
	String get save => 'Save';
	String get asset => 'Asset';
	String get market_asset => 'Market asset';
	String get assets => 'Assets';
	String get date => 'Date';
	String get value => 'Value';
	String get quantity => 'Quantity';
	String get note => 'Note';
	String get position_deleted => 'Position deleted!';
	String get add_category => 'Add category';
	String get add_category_message => 'Create a new category for your assets, for example "Liquidity", "Bank accounts", "Expected taxes" ...';
	String get name => 'Name';
	String get create_allocation_chart => 'Create allocation chart';
	String get create_allocation_chart_name_message => 'Choose a name for this chart';
	String get create_allocation_chart_select => 'Select the categories or assets you want to add to the pie chart';
	String get category => 'Category';
	String get categories => 'Categories';
	String get add_position => 'Add position';
	String get add => 'Add';
	String get add_selection_subtitle => 'Select which kind of asset you want to add:';
	String get add_selection_market_title => 'Market Investment (ETF/Stock/Crypto)';
	String get add_selection_market_subtitle => 'Add your investments in the stock market.\nTheir value will be automatically calculated day by day';
	String get add_selection_manual_title => 'Manual Asset or Liability';
	String get add_selection_manual_subtitle => 'Add your asset or liability that are part of the net worth.\nExample of assets are house, car, cash, valuable collections, watches, ...';
	String get deleted => 'Deleted!';
	String get delete => 'Delete';
	String get delete_confirmation_asset => 'Are you sure you want to delete this element?\nAll its values will be deleted.';
	String get delete_confirmation_category => 'Are you sure you want to delete this category?\nAll its asset and positions will be deleted.';
	String get delete_confirmation_category_short => 'Are you sure you want to delete this category?';
	String get change_category => 'Change category';
	String get current_value => 'Current value';
	String get investment_info => 'Investment info';
	String get value_lowercase => 'value';
	String get invested => 'Invested';
	String get avg_purchase_price => 'Avg. purchase price';
	String get history => 'History';
	String get select_currency => 'Select currency';
	String get search => 'Search';
	String get asset_visible_again_message => 'Do you want to make <asset> visible again?';
	String get hidde_asset => 'Hidden assets';
	String get hidde_asset_empty => 'You don\'t have any hidden asset';
	String get suggest_feature => 'Suggest feature';
	String get report_a_problem => 'Report a problem';
	String get contact_us => 'Contact us';
	String get firebase_feedback_message => 'Message has been sent.\nThank you for contacting us!';
	String get send => 'Send';
	String get your_email => 'Your email';
	String get message => 'Message';
	String get asset_allocation => 'Asset allocation';
	String get select => 'Select';
	String get total => 'Total';
	String get edit_name => 'Edit name';
	String get hide => 'Hide';
	String get hide_message => 'Are you sure you want to hide this element?\nYou can restore it from Settings page.';
	String get home_empty => 'You have not registered any assets yet.\n\nAdd your assets with the button below or import a backup file.';
	String get your_net_worth => 'Your net worth';
	String get home_disclaimer => 'Prices are updated to the closing value of the previous day.\nThere may be a difference between the actual value and the one displayed in the app.';
	String get import_dialog_title => 'Please select an output file:';
	String get import_successful => 'The file has been saved successfully!';
	String get import_disclaimer => 'Are you sure you want to import this file?\nAll current data will be overwritten';
	String get import_file_not_supported => 'The selected file is not correct. Please select a .mdb file';
	String get import_error => 'An error occurred, please try again';
	String get import_export => 'Import/Export';
	String get import_title => 'Import';
	String get import_subtitle => 'Select the .mdb file you generated via the Export feature to restore the data';
	String get export_title => 'Export';
	String get export_subtitle => 'Export your data and save wherever you want. You can use the file to restore data if you install the app from scratch';
	String get delete_chart_message => 'Are you sure you want to delete this chart?';
	String get insights_empty => 'You have not registered any assets yet.\n\nAdd your assets in the Home to have the insights.';
	String get allocation => 'Allocation';
	String get monthly_gain_loss => 'Monthly Gains/Losses';
	String get delete_cat_error => 'This category contains some assets. Only empty categories can be removed. Please, remove the assets from the Home.';
	String get empty_categories => 'You don\'t have any categories with assets';
	String get onboarding_1_title => 'Why should you track your net worth?';
	String get onboarding_1_subtitle => 'Tracking net worth provides a clear snapshot of your overall financial health. It helps you to:\n1. Understand your true financial position\n2. Set and monitor progress toward financial goals\n3. Identify areas for improvement in saving or investing\n4. Plan more effectively for retirement.';
	String get onboarding_2_title => 'Keep track of your net worth easily';
	String get onboarding_2_subtitle => 'Add your assets, liabilities and investments to know the value of your net worth in real time.';
	String get onboarding_3_title => 'Monitor the performance of your investments';
	String get onboarding_3_subtitle => 'Keep track of your stock or ETF investments with interactive charts and valuable KPIs.';
	String get onboarding_4_title => 'Get valuable insights';
	String get onboarding_4_subtitle => 'View valuable insights into the status and performance of your net worth.';
	String get onboarding_5_title => 'How should you use the app?';
	String get onboarding_5_subtitle => 'Periodically remember to open the app and update the value of your assets, for example at the end every month.';
	String get onboarding_6_title => 'You data will not be shared to anyone';
	String get onboarding_6_subtitle => 'Your data are stored inside the phone and they are not sent to any server.\nIf you want, you can share/backup your data with the "Export" function.';
	String get sold_for => 'sold for';
	String get note_tax => 'From <asset> selling\n\nnGross value: <grossValue>\nTax percentage applied: <taxPercentage>%';
	String get sell_position => 'Sell position';
	String get confirm_sell => 'Confirm sell';
	String get position_sold => 'Position sold!';
	String get sell_date => 'Sell date';
	String get sell_quantity => 'Quantity to sell (max <qt>)';
	String get sell_add_asset_value => 'Add position value to an other asset?';
	String get sell_add_asset_value_message => 'You can select to which asset the value of the position should be added, for example a bank account.?';
	String get sell_apply_tax => 'Apply tax?';
	String get sell_apply_tax_message => 'Enter the percentage of taxes you will pay based on the country in which you are tax resident.';
	String get tax_placeholder => 'Tax (%)';
	String get sell_tax_add_liability => 'Add tax value to a liability?';
	String get main_currency_changed => 'Main currency has been changed!';
	String get settings => 'Settings';
	String get main_currency => 'Main currency';
	String get assets_categories => 'Assets/Categories';
	String get hidden_asset => 'Hidden assets';
	String get manage_categories => 'Manage categories';
	String get feedback => 'Feedback';
	String get soon_available => 'Soon available';
	String get app_version => 'App version:';
	String get settings_disclaimer => 'DISCLAIMER\nThe app is still in the first release phase and all the sections are accessible.\nIn the future some sections or new functionalities may be accessible only with a Premium account.';
	String get soon_available_message => 'This is what we are currently working on:';
	List<String> get soon_available_task => [
		'Automatic backup',
		'Home widgets for iPhone/Android',
		'You suggestions',
		'Bug fixes, of course :)',
	];
	String get ticker => 'Ticker';
	String get create_new_category => '+ Create new category';
	String get create_new_asset_liability => '+ Create new asset/liability';
	String get gain_losses_empty => 'Not enough data to plot the chart.\n\nProbably you don\'t have data from the last month to evaluate gains or losses';
	String get building_chart => 'Building the chart...';
	String get line_graph_empty => 'Not enough data to plot the chart';
	String get delete_confirmation_default => 'Are you sure you want to delete this?';
	String get yes => 'Yes';
	String get no => 'No';
	String get choose_an_option => 'Choose an option';
	String get just_a_moment => 'Just a moment...';
	String get offline_message => 'It seems that you are offline.\nTo have updated values, please turn on mobile data or Wi-Fi and reopen the app.';
	String get home => 'Home';
	String get insights => 'Insights';
	String get bank_accounts => 'Bank accounts';
	String get vehicles => 'Vehicles';
	String get real_estate => 'Real estate / House';
	String get debts => 'Debts';
	String get watches => 'Watches';
	String get other => 'Other';
	String get commodities => 'Commodities';
	String get stocks => 'Stocks';
	String get filed_mandatory => 'This field is mandatory';
	String get filed_number_is_invalid => 'Please insert a valid number';
	String get asset_liability => 'Asset/Liability';
	String get add_position_question => 'Do you want to give a value to this asset?';
	String get add_asset_subtitle => 'Add a new asset or liability. After saving it, you can add its value.';
	String get add_asset_disclaimer => 'If you want to add investments, choose "Market Investment (ETF/Stock/Crypto)" from the previous screen. In this way, they will be tracked automatically.';
	String get stock_split_message_position => 'The position is influenced by a stock splits:\n\nEntered quantity is <qt> → Quantity after split is <qtSplit>\n\nDo you want to use the quantity after split?';
	String get stock_split_message_positions => 'The following positions are influenced by a stock splits:\n\n<message>\n\nDo you want to use the quantity after split?';
	String get stock_split_message_single => '• <date>: Entered quantity: <qt> → Quantity after split: <qtSplit>';
	String get ticker_or_name => 'Name or ticker';
	String get ticker_search_subtitle => 'Search by name, ticker or ISIN:';
	String get no_result_found => 'No result found';
	String get confirm_order => 'Confirm order';
	String get reorder => 'Reorder';
	String get what_is_a_share_split => 'What is a share split?';
	String get what_is_a_share_split_content => 'A stock split increases the number of shares in a company. For example, after a 2-for-1 split, each investor will own double the number of shares, and each share will be worth half as much.\n\nA company may split its stock when the market price per share is so high that it becomes unwieldy when traded. One of the reasons is that a very high share price may deter small investors from buying the shares. Stock splits are usually initiated after a large run up in share price.';
}

// Path: <root>
class _StringsIt implements Translations {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	_StringsIt.build({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = TranslationMetadata(
		    locale: AppLocale.it,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <it>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	@override dynamic operator[](String key) => $meta.getTranslation(key);

	@override late final _StringsIt _root = this; // ignore: unused_field

	// Translations
	@override String get done => 'Fatto!';
	@override String get position => 'Posizione';
	@override String get report_a_sell => 'Registra una vendita';
	@override String get save => 'Salva';
	@override String get asset => 'Asset';
	@override String get market_asset => 'Asset di mercato';
	@override String get assets => 'Assets';
	@override String get date => 'Data';
	@override String get value => 'Valore';
	@override String get quantity => 'Quantità';
	@override String get note => 'Nota';
	@override String get position_deleted => 'Posizione eliminata!';
	@override String get add_category => 'Aggiungi categoria';
	@override String get add_category_message => 'Crea una nuova categoria per i tuoi assets, ad esempio "Liquidità", "Conti bancari", "Tasse previste" ...';
	@override String get name => 'Nome';
	@override String get create_allocation_chart => 'Crea grafico di allocazione';
	@override String get create_allocation_chart_name_message => 'Scegli un nome per questo grafico';
	@override String get create_allocation_chart_select => 'Seleziona le categorie o i assets che vuoi aggiungere al grafico a torta';
	@override String get category => 'Categoria';
	@override String get categories => 'Categorie';
	@override String get add_position => 'Aggiungi posizione';
	@override String get add => 'Aggiungi';
	@override String get add_selection_subtitle => 'Seleziona il tipo di asset che vuoi aggiungere:';
	@override String get add_selection_market_title => 'Investimento di mercato (ETF/Stock/Crypto)';
	@override String get add_selection_market_subtitle => 'Aggiungi i tuoi investimenti nel mercato azionario.\nIl loro valore sarà calcolato automaticamente giorno per giorno';
	@override String get add_selection_manual_title => 'Asset o Passività Manuale';
	@override String get add_selection_manual_subtitle => 'Aggiungi il tuo asset o passività che fa parte del patrimonio.\nEsempi di assets sono la casa, l\'auto, conti bancari, collezioni di valore, orologi, ...';
	@override String get deleted => 'Eliminato!';
	@override String get delete => 'Elimina';
	@override String get delete_confirmation_asset => 'Sei sicuro di voler eliminare questo elemento?\nTutti i suoi valori saranno eliminati.';
	@override String get delete_confirmation_category => 'Sei sicuro di voler eliminare questa categoria?\nTutti i suoi assets e posizioni saranno eliminati.';
	@override String get delete_confirmation_category_short => 'Sei sicuro di voler eliminare questa categoria?';
	@override String get change_category => 'Cambia categoria';
	@override String get current_value => 'Valore attuale';
	@override String get investment_info => 'Informazioni sull\'investimento';
	@override String get value_lowercase => 'valore';
	@override String get invested => 'Investito';
	@override String get avg_purchase_price => 'Prezzo medio di acquisto';
	@override String get history => 'Cronologia';
	@override String get select_currency => 'Seleziona valuta';
	@override String get search => 'Cerca';
	@override String get asset_visible_again_message => 'Vuoi rendere <asset> nuovamente visibile?';
	@override String get hidde_asset => 'Asset nascosti';
	@override String get hidde_asset_empty => 'Non hai nessun asset nascosto';
	@override String get suggest_feature => 'Suggerisci una funzionalità';
	@override String get report_a_problem => 'Segnala un problema';
	@override String get contact_us => 'Contattaci';
	@override String get firebase_feedback_message => 'Il messaggio è stato inviato.\nGrazie per averci contattato!';
	@override String get send => 'Invia';
	@override String get your_email => 'La tua email';
	@override String get message => 'Messaggio';
	@override String get asset_allocation => 'Allocazione degli asset';
	@override String get select => 'Seleziona';
	@override String get total => 'Totale';
	@override String get edit_name => 'Modifica nome';
	@override String get hide => 'Nascondi';
	@override String get hide_message => 'Sei sicuro di voler nascondere questo elemento?\nPuoi ripristinarlo dalla pagina Impostazioni.';
	@override String get home_empty => 'Non hai ancora registrato alcun asset.\n\nAggiungi i tuoi assets con il pulsante in basso o importa un file di backup.';
	@override String get your_net_worth => 'Il tuo patrimonio';
	@override String get home_disclaimer => 'I prezzi sono aggiornati al valore di chiusura del giorno precedente.\nPotrebbe esserci una differenza tra il valore effettivo e quello visualizzato nell\'app.';
	@override String get import_dialog_title => 'Seleziona un file di output:';
	@override String get import_successful => 'Il file è stato salvato con successo!';
	@override String get import_disclaimer => 'Sei sicuro di voler importare questo file?\nTutti i dati attuali saranno sovrascritti';
	@override String get import_file_not_supported => 'Il file selezionato non è corretto. Seleziona un file .mdb';
	@override String get import_error => 'Si è verificato un errore, riprova';
	@override String get import_export => 'Importa/Esporta';
	@override String get import_title => 'Importa';
	@override String get import_subtitle => 'Seleziona il file .mdb che hai generato tramite la funzione Esporta per ripristinare i dati';
	@override String get export_title => 'Esporta';
	@override String get export_subtitle => 'Esporta i tuoi dati e salvali dove vuoi. Puoi usare il file per ripristinare i dati se installi l\'app da zero';
	@override String get delete_chart_message => 'Sei sicuro di voler eliminare questo grafico?';
	@override String get insights_empty => 'Non hai ancora registrato alcun asset.\n\nAggiungi i tuoi assets nella Home per avere degli approfondimenti.';
	@override String get allocation => 'Allocazione';
	@override String get monthly_gain_loss => 'Guadagni/Perdite Mensili';
	@override String get delete_cat_error => 'Questa categoria contiene degli assets. Solo le categorie vuote possono essere rimosse. Per favore, rimuovi gli assets dalla Home.';
	@override String get empty_categories => 'Non hai nessuna categoria con asset';
	@override String get onboarding_1_title => 'Perché dovresti tracciare il tuo patrimonio?';
	@override String get onboarding_1_subtitle => 'Tracciare il patrimonio fornisce una chiara istantanea della tua salute finanziaria generale. Ti aiuta a:\n1. Comprendere la tua vera posizione finanziaria\n2. Impostare e monitorare i progressi verso gli obiettivi finanziari\n3. Identificare le aree di miglioramento nel risparmio o nell\'investimento\n4. Pianificare più efficacemente per la pensione.';
	@override String get onboarding_2_title => 'Tieni traccia del tuo patrimonio facilmente';
	@override String get onboarding_2_subtitle => 'Aggiungi i tuoi assets, passività e investimenti per conoscere il valore del tuo patrimonio in tempo reale.';
	@override String get onboarding_3_title => 'Monitora le prestazioni dei tuoi investimenti';
	@override String get onboarding_3_subtitle => 'Tieni traccia dei tuoi investimenti in azioni o ETF con grafici interattivi e KPI preziosi.';
	@override String get onboarding_4_title => 'Ottieni informazioni preziose';
	@override String get onboarding_4_subtitle => 'Visualizza informazioni preziose sullo stato e le prestazioni del tuo patrimonio.';
	@override String get onboarding_5_title => 'Come dovresti usare l\'app?';
	@override String get onboarding_5_subtitle => 'Ricordati periodicamente di aprire l\'app e aggiornare il valore dei tuoi assets, ad esempio alla fine di ogni mese.';
	@override String get onboarding_6_title => 'I tuoi dati non saranno condivisi con nessuno';
	@override String get onboarding_6_subtitle => 'I tuoi dati sono memorizzati all\'interno del telefono e non vengono inviati a nessun server.\nSe vuoi, puoi condividere/fare un backup dei tuoi dati con la funzione "Esporta".';
	@override String get sold_for => 'venduto per';
	@override String get note_tax => 'Dalla vendita di <asset>\n\nValore lordo: <grossValue>\nPercentuale di tassa applicata: <taxPercentage>%';
	@override String get sell_position => 'Vendi posizione';
	@override String get confirm_sell => 'Conferma vendita';
	@override String get position_sold => 'Posizione venduta!';
	@override String get sell_date => 'Data di vendita';
	@override String get sell_quantity => 'Quantità da vendere (max <qt>)';
	@override String get sell_add_asset_value => 'Aggiungere il valore della posizione ad un altro asset?';
	@override String get sell_add_asset_value_message => 'Selezionare a quale asset il valore della posizione dovrebbe essere aggiunto, ad esempio un conto bancario.';
	@override String get sell_apply_tax => 'Applicare la tassa?';
	@override String get sell_apply_tax_message => 'Inserisci la percentuale di tassa che pagherai in base al paese in cui hai la residenza fiscale.';
	@override String get tax_placeholder => 'Tassa (%)';
	@override String get sell_tax_add_liability => 'Aggiungere il valore della tassa a una passività?';
	@override String get main_currency_changed => 'La valuta principale è stata cambiata!';
	@override String get settings => 'Impostazioni';
	@override String get main_currency => 'Valuta principale';
	@override String get assets_categories => 'Assets/Categorie';
	@override String get hidden_asset => 'Assets nascosti';
	@override String get manage_categories => 'Gestisci categorie';
	@override String get feedback => 'Feedback';
	@override String get soon_available => 'Presto disponibile';
	@override String get app_version => 'Versione dell\'app:';
	@override String get settings_disclaimer => 'DISCLAIMER\nL\'app è ancora nella prima fase di rilascio e tutte le sezioni sono accessibili.\nIn futuro alcune sezioni o nuove funzionalità potrebbero essere accessibili solo con un account Premium.';
	@override String get soon_available_message => 'Ecco su cosa stiamo lavorando attualmente:';
	@override List<String> get soon_available_task => [
		'Backup automatico',
		'Widget per la home di iPhone/Android',
		'I vostri suggerimenti',
		'Correzione di bug, ovviamente :)',
	];
	@override String get ticker => 'Ticker';
	@override String get create_new_category => '+ Crea nuova categoria';
	@override String get create_new_asset_liability => '+ Crea nuovo asset/passività';
	@override String get gain_losses_empty => 'Dati insufficienti per tracciare il grafico.\n\nProbabilmente non hai dati dell\'ultimo mese per valutare guadagni o perdite';
	@override String get building_chart => 'Creazione del grafico in corso...';
	@override String get line_graph_empty => 'Dati insufficienti per tracciare il grafico';
	@override String get delete_confirmation_default => 'Sei sicuro di voler eliminare questo?';
	@override String get yes => 'Sì';
	@override String get no => 'No';
	@override String get choose_an_option => 'Scegli un\'opzione';
	@override String get just_a_moment => 'Solo un momento...';
	@override String get offline_message => 'Sembra che tu sia offline.\nPer avere valori aggiornati, attiva i dati mobili o il Wi-Fi e riapri l\'app.';
	@override String get home => 'Home';
	@override String get insights => 'Approfondimenti';
	@override String get bank_accounts => 'Conti bancari';
	@override String get vehicles => 'Veicoli';
	@override String get real_estate => 'Immobili / Casa';
	@override String get debts => 'Debiti';
	@override String get watches => 'Orologi';
	@override String get other => 'Altro';
	@override String get commodities => 'Materie prime';
	@override String get stocks => 'Stocks';
	@override String get filed_mandatory => 'Questo campo è obbligatorio';
	@override String get filed_number_is_invalid => 'Inserisci un numero valido';
	@override String get asset_liability => 'Asset/Passività';
	@override String get add_position_question => 'Vuoi assegnare un valore a questo asset?';
	@override String get add_asset_subtitle => 'Aggiungi un nuovo asset o passività. Dopo averlo salvato, potrai aggiungere il suo valore.';
	@override String get add_asset_disclaimer => 'Se vuoi aggiungere investimenti, scegli "Investimento di mercato (ETF/Stocks/Cripto)" dalla schermata precedente. In questo modo, saranno tracciati automaticamente.';
	@override String get stock_split_message_position => 'La posizione è influenzata da uno split azionario:\n\nQuantità inserita <qt> → Quantita dopo lo split <qtSplit>\n\nVuoi utilizzare la quantità dopo lo split?';
	@override String get stock_split_message_positions => 'Le seguenti posizioni sono influenzate da uno split azionario:\n\n<message>\n\nVuoi utilizzare la quantità dopo lo split?';
	@override String get stock_split_message_single => '• <date>: Quantità inserita: <qt> → Quantita dopo lo split: <qtSplit>';
	@override String get ticker_or_name => 'Nome o ticker';
	@override String get ticker_search_subtitle => 'Cerca per nome, ticker o ISIN:';
	@override String get no_result_found => 'Nessun risultato trovato';
	@override String get confirm_order => 'Conferma ordine';
	@override String get reorder => 'Riordina';
	@override String get what_is_a_share_split => 'Che cos\'è uno split azionario?';
	@override String get what_is_a_share_split_content => 'Un frazionamento azionario aumenta il numero di azioni di una società. Ad esempio, dopo un frazionamento 2 a 1, ogni investitore possiederà un numero doppio di azioni e ogni azione varrà la metà.\n\nUn\'azienda può dividere le proprie azioni quando il prezzo di mercato per azione è così alto che diventa ingombrante quando viene scambiato. Una delle ragioni è che un prezzo molto alto può scoraggiare i piccoli investitori dall\'acquistare le azioni. I frazionamenti azionari vengono solitamente avviati dopo una forte crescita del prezzo delle azioni.';
}

/// Flat map(s) containing all translations.
/// Only for edge cases! For simple maps, use the map function of this library.

extension on Translations {
	dynamic _flatMapFunction(String path) {
		switch (path) {
			case 'done': return 'Done!';
			case 'position': return 'Position';
			case 'report_a_sell': return 'Report a sell';
			case 'save': return 'Save';
			case 'asset': return 'Asset';
			case 'market_asset': return 'Market asset';
			case 'assets': return 'Assets';
			case 'date': return 'Date';
			case 'value': return 'Value';
			case 'quantity': return 'Quantity';
			case 'note': return 'Note';
			case 'position_deleted': return 'Position deleted!';
			case 'add_category': return 'Add category';
			case 'add_category_message': return 'Create a new category for your assets, for example "Liquidity", "Bank accounts", "Expected taxes" ...';
			case 'name': return 'Name';
			case 'create_allocation_chart': return 'Create allocation chart';
			case 'create_allocation_chart_name_message': return 'Choose a name for this chart';
			case 'create_allocation_chart_select': return 'Select the categories or assets you want to add to the pie chart';
			case 'category': return 'Category';
			case 'categories': return 'Categories';
			case 'add_position': return 'Add position';
			case 'add': return 'Add';
			case 'add_selection_subtitle': return 'Select which kind of asset you want to add:';
			case 'add_selection_market_title': return 'Market Investment (ETF/Stock/Crypto)';
			case 'add_selection_market_subtitle': return 'Add your investments in the stock market.\nTheir value will be automatically calculated day by day';
			case 'add_selection_manual_title': return 'Manual Asset or Liability';
			case 'add_selection_manual_subtitle': return 'Add your asset or liability that are part of the net worth.\nExample of assets are house, car, cash, valuable collections, watches, ...';
			case 'deleted': return 'Deleted!';
			case 'delete': return 'Delete';
			case 'delete_confirmation_asset': return 'Are you sure you want to delete this element?\nAll its values will be deleted.';
			case 'delete_confirmation_category': return 'Are you sure you want to delete this category?\nAll its asset and positions will be deleted.';
			case 'delete_confirmation_category_short': return 'Are you sure you want to delete this category?';
			case 'change_category': return 'Change category';
			case 'current_value': return 'Current value';
			case 'investment_info': return 'Investment info';
			case 'value_lowercase': return 'value';
			case 'invested': return 'Invested';
			case 'avg_purchase_price': return 'Avg. purchase price';
			case 'history': return 'History';
			case 'select_currency': return 'Select currency';
			case 'search': return 'Search';
			case 'asset_visible_again_message': return 'Do you want to make <asset> visible again?';
			case 'hidde_asset': return 'Hidden assets';
			case 'hidde_asset_empty': return 'You don\'t have any hidden asset';
			case 'suggest_feature': return 'Suggest feature';
			case 'report_a_problem': return 'Report a problem';
			case 'contact_us': return 'Contact us';
			case 'firebase_feedback_message': return 'Message has been sent.\nThank you for contacting us!';
			case 'send': return 'Send';
			case 'your_email': return 'Your email';
			case 'message': return 'Message';
			case 'asset_allocation': return 'Asset allocation';
			case 'select': return 'Select';
			case 'total': return 'Total';
			case 'edit_name': return 'Edit name';
			case 'hide': return 'Hide';
			case 'hide_message': return 'Are you sure you want to hide this element?\nYou can restore it from Settings page.';
			case 'home_empty': return 'You have not registered any assets yet.\n\nAdd your assets with the button below or import a backup file.';
			case 'your_net_worth': return 'Your net worth';
			case 'home_disclaimer': return 'Prices are updated to the closing value of the previous day.\nThere may be a difference between the actual value and the one displayed in the app.';
			case 'import_dialog_title': return 'Please select an output file:';
			case 'import_successful': return 'The file has been saved successfully!';
			case 'import_disclaimer': return 'Are you sure you want to import this file?\nAll current data will be overwritten';
			case 'import_file_not_supported': return 'The selected file is not correct. Please select a .mdb file';
			case 'import_error': return 'An error occurred, please try again';
			case 'import_export': return 'Import/Export';
			case 'import_title': return 'Import';
			case 'import_subtitle': return 'Select the .mdb file you generated via the Export feature to restore the data';
			case 'export_title': return 'Export';
			case 'export_subtitle': return 'Export your data and save wherever you want. You can use the file to restore data if you install the app from scratch';
			case 'delete_chart_message': return 'Are you sure you want to delete this chart?';
			case 'insights_empty': return 'You have not registered any assets yet.\n\nAdd your assets in the Home to have the insights.';
			case 'allocation': return 'Allocation';
			case 'monthly_gain_loss': return 'Monthly Gains/Losses';
			case 'delete_cat_error': return 'This category contains some assets. Only empty categories can be removed. Please, remove the assets from the Home.';
			case 'empty_categories': return 'You don\'t have any categories with assets';
			case 'onboarding_1_title': return 'Why should you track your net worth?';
			case 'onboarding_1_subtitle': return 'Tracking net worth provides a clear snapshot of your overall financial health. It helps you to:\n1. Understand your true financial position\n2. Set and monitor progress toward financial goals\n3. Identify areas for improvement in saving or investing\n4. Plan more effectively for retirement.';
			case 'onboarding_2_title': return 'Keep track of your net worth easily';
			case 'onboarding_2_subtitle': return 'Add your assets, liabilities and investments to know the value of your net worth in real time.';
			case 'onboarding_3_title': return 'Monitor the performance of your investments';
			case 'onboarding_3_subtitle': return 'Keep track of your stock or ETF investments with interactive charts and valuable KPIs.';
			case 'onboarding_4_title': return 'Get valuable insights';
			case 'onboarding_4_subtitle': return 'View valuable insights into the status and performance of your net worth.';
			case 'onboarding_5_title': return 'How should you use the app?';
			case 'onboarding_5_subtitle': return 'Periodically remember to open the app and update the value of your assets, for example at the end every month.';
			case 'onboarding_6_title': return 'You data will not be shared to anyone';
			case 'onboarding_6_subtitle': return 'Your data are stored inside the phone and they are not sent to any server.\nIf you want, you can share/backup your data with the "Export" function.';
			case 'sold_for': return 'sold for';
			case 'note_tax': return 'From <asset> selling\n\nnGross value: <grossValue>\nTax percentage applied: <taxPercentage>%';
			case 'sell_position': return 'Sell position';
			case 'confirm_sell': return 'Confirm sell';
			case 'position_sold': return 'Position sold!';
			case 'sell_date': return 'Sell date';
			case 'sell_quantity': return 'Quantity to sell (max <qt>)';
			case 'sell_add_asset_value': return 'Add position value to an other asset?';
			case 'sell_add_asset_value_message': return 'You can select to which asset the value of the position should be added, for example a bank account.?';
			case 'sell_apply_tax': return 'Apply tax?';
			case 'sell_apply_tax_message': return 'Enter the percentage of taxes you will pay based on the country in which you are tax resident.';
			case 'tax_placeholder': return 'Tax (%)';
			case 'sell_tax_add_liability': return 'Add tax value to a liability?';
			case 'main_currency_changed': return 'Main currency has been changed!';
			case 'settings': return 'Settings';
			case 'main_currency': return 'Main currency';
			case 'assets_categories': return 'Assets/Categories';
			case 'hidden_asset': return 'Hidden assets';
			case 'manage_categories': return 'Manage categories';
			case 'feedback': return 'Feedback';
			case 'soon_available': return 'Soon available';
			case 'app_version': return 'App version:';
			case 'settings_disclaimer': return 'DISCLAIMER\nThe app is still in the first release phase and all the sections are accessible.\nIn the future some sections or new functionalities may be accessible only with a Premium account.';
			case 'soon_available_message': return 'This is what we are currently working on:';
			case 'soon_available_task.0': return 'Automatic backup';
			case 'soon_available_task.1': return 'Home widgets for iPhone/Android';
			case 'soon_available_task.2': return 'You suggestions';
			case 'soon_available_task.3': return 'Bug fixes, of course :)';
			case 'ticker': return 'Ticker';
			case 'create_new_category': return '+ Create new category';
			case 'create_new_asset_liability': return '+ Create new asset/liability';
			case 'gain_losses_empty': return 'Not enough data to plot the chart.\n\nProbably you don\'t have data from the last month to evaluate gains or losses';
			case 'building_chart': return 'Building the chart...';
			case 'line_graph_empty': return 'Not enough data to plot the chart';
			case 'delete_confirmation_default': return 'Are you sure you want to delete this?';
			case 'yes': return 'Yes';
			case 'no': return 'No';
			case 'choose_an_option': return 'Choose an option';
			case 'just_a_moment': return 'Just a moment...';
			case 'offline_message': return 'It seems that you are offline.\nTo have updated values, please turn on mobile data or Wi-Fi and reopen the app.';
			case 'home': return 'Home';
			case 'insights': return 'Insights';
			case 'bank_accounts': return 'Bank accounts';
			case 'vehicles': return 'Vehicles';
			case 'real_estate': return 'Real estate / House';
			case 'debts': return 'Debts';
			case 'watches': return 'Watches';
			case 'other': return 'Other';
			case 'commodities': return 'Commodities';
			case 'stocks': return 'Stocks';
			case 'filed_mandatory': return 'This field is mandatory';
			case 'filed_number_is_invalid': return 'Please insert a valid number';
			case 'asset_liability': return 'Asset/Liability';
			case 'add_position_question': return 'Do you want to give a value to this asset?';
			case 'add_asset_subtitle': return 'Add a new asset or liability. After saving it, you can add its value.';
			case 'add_asset_disclaimer': return 'If you want to add investments, choose "Market Investment (ETF/Stock/Crypto)" from the previous screen. In this way, they will be tracked automatically.';
			case 'stock_split_message_position': return 'The position is influenced by a stock splits:\n\nEntered quantity is <qt> → Quantity after split is <qtSplit>\n\nDo you want to use the quantity after split?';
			case 'stock_split_message_positions': return 'The following positions are influenced by a stock splits:\n\n<message>\n\nDo you want to use the quantity after split?';
			case 'stock_split_message_single': return '• <date>: Entered quantity: <qt> → Quantity after split: <qtSplit>';
			case 'ticker_or_name': return 'Name or ticker';
			case 'ticker_search_subtitle': return 'Search by name, ticker or ISIN:';
			case 'no_result_found': return 'No result found';
			case 'confirm_order': return 'Confirm order';
			case 'reorder': return 'Reorder';
			case 'what_is_a_share_split': return 'What is a share split?';
			case 'what_is_a_share_split_content': return 'A stock split increases the number of shares in a company. For example, after a 2-for-1 split, each investor will own double the number of shares, and each share will be worth half as much.\n\nA company may split its stock when the market price per share is so high that it becomes unwieldy when traded. One of the reasons is that a very high share price may deter small investors from buying the shares. Stock splits are usually initiated after a large run up in share price.';
			default: return null;
		}
	}
}

extension on _StringsIt {
	dynamic _flatMapFunction(String path) {
		switch (path) {
			case 'done': return 'Fatto!';
			case 'position': return 'Posizione';
			case 'report_a_sell': return 'Registra una vendita';
			case 'save': return 'Salva';
			case 'asset': return 'Asset';
			case 'market_asset': return 'Asset di mercato';
			case 'assets': return 'Assets';
			case 'date': return 'Data';
			case 'value': return 'Valore';
			case 'quantity': return 'Quantità';
			case 'note': return 'Nota';
			case 'position_deleted': return 'Posizione eliminata!';
			case 'add_category': return 'Aggiungi categoria';
			case 'add_category_message': return 'Crea una nuova categoria per i tuoi assets, ad esempio "Liquidità", "Conti bancari", "Tasse previste" ...';
			case 'name': return 'Nome';
			case 'create_allocation_chart': return 'Crea grafico di allocazione';
			case 'create_allocation_chart_name_message': return 'Scegli un nome per questo grafico';
			case 'create_allocation_chart_select': return 'Seleziona le categorie o i assets che vuoi aggiungere al grafico a torta';
			case 'category': return 'Categoria';
			case 'categories': return 'Categorie';
			case 'add_position': return 'Aggiungi posizione';
			case 'add': return 'Aggiungi';
			case 'add_selection_subtitle': return 'Seleziona il tipo di asset che vuoi aggiungere:';
			case 'add_selection_market_title': return 'Investimento di mercato (ETF/Stock/Crypto)';
			case 'add_selection_market_subtitle': return 'Aggiungi i tuoi investimenti nel mercato azionario.\nIl loro valore sarà calcolato automaticamente giorno per giorno';
			case 'add_selection_manual_title': return 'Asset o Passività Manuale';
			case 'add_selection_manual_subtitle': return 'Aggiungi il tuo asset o passività che fa parte del patrimonio.\nEsempi di assets sono la casa, l\'auto, conti bancari, collezioni di valore, orologi, ...';
			case 'deleted': return 'Eliminato!';
			case 'delete': return 'Elimina';
			case 'delete_confirmation_asset': return 'Sei sicuro di voler eliminare questo elemento?\nTutti i suoi valori saranno eliminati.';
			case 'delete_confirmation_category': return 'Sei sicuro di voler eliminare questa categoria?\nTutti i suoi assets e posizioni saranno eliminati.';
			case 'delete_confirmation_category_short': return 'Sei sicuro di voler eliminare questa categoria?';
			case 'change_category': return 'Cambia categoria';
			case 'current_value': return 'Valore attuale';
			case 'investment_info': return 'Informazioni sull\'investimento';
			case 'value_lowercase': return 'valore';
			case 'invested': return 'Investito';
			case 'avg_purchase_price': return 'Prezzo medio di acquisto';
			case 'history': return 'Cronologia';
			case 'select_currency': return 'Seleziona valuta';
			case 'search': return 'Cerca';
			case 'asset_visible_again_message': return 'Vuoi rendere <asset> nuovamente visibile?';
			case 'hidde_asset': return 'Asset nascosti';
			case 'hidde_asset_empty': return 'Non hai nessun asset nascosto';
			case 'suggest_feature': return 'Suggerisci una funzionalità';
			case 'report_a_problem': return 'Segnala un problema';
			case 'contact_us': return 'Contattaci';
			case 'firebase_feedback_message': return 'Il messaggio è stato inviato.\nGrazie per averci contattato!';
			case 'send': return 'Invia';
			case 'your_email': return 'La tua email';
			case 'message': return 'Messaggio';
			case 'asset_allocation': return 'Allocazione degli asset';
			case 'select': return 'Seleziona';
			case 'total': return 'Totale';
			case 'edit_name': return 'Modifica nome';
			case 'hide': return 'Nascondi';
			case 'hide_message': return 'Sei sicuro di voler nascondere questo elemento?\nPuoi ripristinarlo dalla pagina Impostazioni.';
			case 'home_empty': return 'Non hai ancora registrato alcun asset.\n\nAggiungi i tuoi assets con il pulsante in basso o importa un file di backup.';
			case 'your_net_worth': return 'Il tuo patrimonio';
			case 'home_disclaimer': return 'I prezzi sono aggiornati al valore di chiusura del giorno precedente.\nPotrebbe esserci una differenza tra il valore effettivo e quello visualizzato nell\'app.';
			case 'import_dialog_title': return 'Seleziona un file di output:';
			case 'import_successful': return 'Il file è stato salvato con successo!';
			case 'import_disclaimer': return 'Sei sicuro di voler importare questo file?\nTutti i dati attuali saranno sovrascritti';
			case 'import_file_not_supported': return 'Il file selezionato non è corretto. Seleziona un file .mdb';
			case 'import_error': return 'Si è verificato un errore, riprova';
			case 'import_export': return 'Importa/Esporta';
			case 'import_title': return 'Importa';
			case 'import_subtitle': return 'Seleziona il file .mdb che hai generato tramite la funzione Esporta per ripristinare i dati';
			case 'export_title': return 'Esporta';
			case 'export_subtitle': return 'Esporta i tuoi dati e salvali dove vuoi. Puoi usare il file per ripristinare i dati se installi l\'app da zero';
			case 'delete_chart_message': return 'Sei sicuro di voler eliminare questo grafico?';
			case 'insights_empty': return 'Non hai ancora registrato alcun asset.\n\nAggiungi i tuoi assets nella Home per avere degli approfondimenti.';
			case 'allocation': return 'Allocazione';
			case 'monthly_gain_loss': return 'Guadagni/Perdite Mensili';
			case 'delete_cat_error': return 'Questa categoria contiene degli assets. Solo le categorie vuote possono essere rimosse. Per favore, rimuovi gli assets dalla Home.';
			case 'empty_categories': return 'Non hai nessuna categoria con asset';
			case 'onboarding_1_title': return 'Perché dovresti tracciare il tuo patrimonio?';
			case 'onboarding_1_subtitle': return 'Tracciare il patrimonio fornisce una chiara istantanea della tua salute finanziaria generale. Ti aiuta a:\n1. Comprendere la tua vera posizione finanziaria\n2. Impostare e monitorare i progressi verso gli obiettivi finanziari\n3. Identificare le aree di miglioramento nel risparmio o nell\'investimento\n4. Pianificare più efficacemente per la pensione.';
			case 'onboarding_2_title': return 'Tieni traccia del tuo patrimonio facilmente';
			case 'onboarding_2_subtitle': return 'Aggiungi i tuoi assets, passività e investimenti per conoscere il valore del tuo patrimonio in tempo reale.';
			case 'onboarding_3_title': return 'Monitora le prestazioni dei tuoi investimenti';
			case 'onboarding_3_subtitle': return 'Tieni traccia dei tuoi investimenti in azioni o ETF con grafici interattivi e KPI preziosi.';
			case 'onboarding_4_title': return 'Ottieni informazioni preziose';
			case 'onboarding_4_subtitle': return 'Visualizza informazioni preziose sullo stato e le prestazioni del tuo patrimonio.';
			case 'onboarding_5_title': return 'Come dovresti usare l\'app?';
			case 'onboarding_5_subtitle': return 'Ricordati periodicamente di aprire l\'app e aggiornare il valore dei tuoi assets, ad esempio alla fine di ogni mese.';
			case 'onboarding_6_title': return 'I tuoi dati non saranno condivisi con nessuno';
			case 'onboarding_6_subtitle': return 'I tuoi dati sono memorizzati all\'interno del telefono e non vengono inviati a nessun server.\nSe vuoi, puoi condividere/fare un backup dei tuoi dati con la funzione "Esporta".';
			case 'sold_for': return 'venduto per';
			case 'note_tax': return 'Dalla vendita di <asset>\n\nValore lordo: <grossValue>\nPercentuale di tassa applicata: <taxPercentage>%';
			case 'sell_position': return 'Vendi posizione';
			case 'confirm_sell': return 'Conferma vendita';
			case 'position_sold': return 'Posizione venduta!';
			case 'sell_date': return 'Data di vendita';
			case 'sell_quantity': return 'Quantità da vendere (max <qt>)';
			case 'sell_add_asset_value': return 'Aggiungere il valore della posizione ad un altro asset?';
			case 'sell_add_asset_value_message': return 'Selezionare a quale asset il valore della posizione dovrebbe essere aggiunto, ad esempio un conto bancario.';
			case 'sell_apply_tax': return 'Applicare la tassa?';
			case 'sell_apply_tax_message': return 'Inserisci la percentuale di tassa che pagherai in base al paese in cui hai la residenza fiscale.';
			case 'tax_placeholder': return 'Tassa (%)';
			case 'sell_tax_add_liability': return 'Aggiungere il valore della tassa a una passività?';
			case 'main_currency_changed': return 'La valuta principale è stata cambiata!';
			case 'settings': return 'Impostazioni';
			case 'main_currency': return 'Valuta principale';
			case 'assets_categories': return 'Assets/Categorie';
			case 'hidden_asset': return 'Assets nascosti';
			case 'manage_categories': return 'Gestisci categorie';
			case 'feedback': return 'Feedback';
			case 'soon_available': return 'Presto disponibile';
			case 'app_version': return 'Versione dell\'app:';
			case 'settings_disclaimer': return 'DISCLAIMER\nL\'app è ancora nella prima fase di rilascio e tutte le sezioni sono accessibili.\nIn futuro alcune sezioni o nuove funzionalità potrebbero essere accessibili solo con un account Premium.';
			case 'soon_available_message': return 'Ecco su cosa stiamo lavorando attualmente:';
			case 'soon_available_task.0': return 'Backup automatico';
			case 'soon_available_task.1': return 'Widget per la home di iPhone/Android';
			case 'soon_available_task.2': return 'I vostri suggerimenti';
			case 'soon_available_task.3': return 'Correzione di bug, ovviamente :)';
			case 'ticker': return 'Ticker';
			case 'create_new_category': return '+ Crea nuova categoria';
			case 'create_new_asset_liability': return '+ Crea nuovo asset/passività';
			case 'gain_losses_empty': return 'Dati insufficienti per tracciare il grafico.\n\nProbabilmente non hai dati dell\'ultimo mese per valutare guadagni o perdite';
			case 'building_chart': return 'Creazione del grafico in corso...';
			case 'line_graph_empty': return 'Dati insufficienti per tracciare il grafico';
			case 'delete_confirmation_default': return 'Sei sicuro di voler eliminare questo?';
			case 'yes': return 'Sì';
			case 'no': return 'No';
			case 'choose_an_option': return 'Scegli un\'opzione';
			case 'just_a_moment': return 'Solo un momento...';
			case 'offline_message': return 'Sembra che tu sia offline.\nPer avere valori aggiornati, attiva i dati mobili o il Wi-Fi e riapri l\'app.';
			case 'home': return 'Home';
			case 'insights': return 'Approfondimenti';
			case 'bank_accounts': return 'Conti bancari';
			case 'vehicles': return 'Veicoli';
			case 'real_estate': return 'Immobili / Casa';
			case 'debts': return 'Debiti';
			case 'watches': return 'Orologi';
			case 'other': return 'Altro';
			case 'commodities': return 'Materie prime';
			case 'stocks': return 'Stocks';
			case 'filed_mandatory': return 'Questo campo è obbligatorio';
			case 'filed_number_is_invalid': return 'Inserisci un numero valido';
			case 'asset_liability': return 'Asset/Passività';
			case 'add_position_question': return 'Vuoi assegnare un valore a questo asset?';
			case 'add_asset_subtitle': return 'Aggiungi un nuovo asset o passività. Dopo averlo salvato, potrai aggiungere il suo valore.';
			case 'add_asset_disclaimer': return 'Se vuoi aggiungere investimenti, scegli "Investimento di mercato (ETF/Stocks/Cripto)" dalla schermata precedente. In questo modo, saranno tracciati automaticamente.';
			case 'stock_split_message_position': return 'La posizione è influenzata da uno split azionario:\n\nQuantità inserita <qt> → Quantita dopo lo split <qtSplit>\n\nVuoi utilizzare la quantità dopo lo split?';
			case 'stock_split_message_positions': return 'Le seguenti posizioni sono influenzate da uno split azionario:\n\n<message>\n\nVuoi utilizzare la quantità dopo lo split?';
			case 'stock_split_message_single': return '• <date>: Quantità inserita: <qt> → Quantita dopo lo split: <qtSplit>';
			case 'ticker_or_name': return 'Nome o ticker';
			case 'ticker_search_subtitle': return 'Cerca per nome, ticker o ISIN:';
			case 'no_result_found': return 'Nessun risultato trovato';
			case 'confirm_order': return 'Conferma ordine';
			case 'reorder': return 'Riordina';
			case 'what_is_a_share_split': return 'Che cos\'è uno split azionario?';
			case 'what_is_a_share_split_content': return 'Un frazionamento azionario aumenta il numero di azioni di una società. Ad esempio, dopo un frazionamento 2 a 1, ogni investitore possiederà un numero doppio di azioni e ogni azione varrà la metà.\n\nUn\'azienda può dividere le proprie azioni quando il prezzo di mercato per azione è così alto che diventa ingombrante quando viene scambiato. Una delle ragioni è che un prezzo molto alto può scoraggiare i piccoli investitori dall\'acquistare le azioni. I frazionamenti azionari vengono solitamente avviati dopo una forte crescita del prezzo delle azioni.';
			default: return null;
		}
	}
}
