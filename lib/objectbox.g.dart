// GENERATED CODE - DO NOT MODIFY BY HAND
// This code was generated by ObjectBox. To update it run the generator again:
// With a Flutter package, run `flutter pub run build_runner build`.
// With a Dart package, run `dart run build_runner build`.
// See also https://docs.objectbox.io/getting-started#generate-objectbox-code

// ignore_for_file: camel_case_types, depend_on_referenced_packages
// coverage:ignore-file

import 'dart:typed_data';

import 'package:flat_buffers/flat_buffers.dart' as fb;
import 'package:objectbox/internal.dart'
    as obx_int; // generated code can access "internal" functionality
import 'package:objectbox/objectbox.dart' as obx;
import 'package:objectbox_flutter_libs/objectbox_flutter_libs.dart';

import 'models/obox/asset_category_obox.dart';
import 'models/obox/asset_history_time_value.dart';
import 'models/obox/asset_obox.dart';
import 'models/obox/asset_time_value_obox.dart';
import 'models/obox/currency_obox.dart';
import 'models/obox/custom_pie_obox.dart';
import 'models/obox/main_currency_forex_change.dart';
import 'models/obox/market_info_obox.dart';
import 'models/obox/net_worth_history.dart';
import 'models/obox/settings_obox.dart';

export 'package:objectbox/objectbox.dart'; // so that callers only have to import this file

final _entities = <obx_int.ModelEntity>[
  obx_int.ModelEntity(
      id: const obx_int.IdUid(1, 1818913365485819735),
      name: 'Asset',
      lastPropertyId: const obx_int.IdUid(6, 7615707338049223920),
      flags: 0,
      properties: <obx_int.ModelProperty>[
        obx_int.ModelProperty(
            id: const obx_int.IdUid(1, 5307316892656884516),
            name: 'id',
            type: 6,
            flags: 1),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(2, 3596191412182231493),
            name: 'name',
            type: 9,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(3, 7426140264771789943),
            name: 'categoryId',
            type: 11,
            flags: 520,
            indexId: const obx_int.IdUid(1, 6281323168732556384),
            relationTarget: 'AssetCategory'),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(4, 633051065447076762),
            name: 'marketInfoId',
            type: 11,
            flags: 520,
            indexId: const obx_int.IdUid(2, 5195916543361874140),
            relationTarget: 'MarketInfo'),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(6, 7615707338049223920),
            name: 'excludeFromNW',
            type: 1,
            flags: 0)
      ],
      relations: <obx_int.ModelRelation>[
        obx_int.ModelRelation(
            id: const obx_int.IdUid(1, 5888901543308030772),
            name: 'timeValues',
            targetId: const obx_int.IdUid(3, 1310094772467892797))
      ],
      backlinks: <obx_int.ModelBacklink>[]),
  obx_int.ModelEntity(
      id: const obx_int.IdUid(2, 4698624914262505470),
      name: 'AssetCategory',
      lastPropertyId: const obx_int.IdUid(3, 1481975311493388480),
      flags: 0,
      properties: <obx_int.ModelProperty>[
        obx_int.ModelProperty(
            id: const obx_int.IdUid(1, 3847787241977257517),
            name: 'id',
            type: 6,
            flags: 1),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(2, 1767101139129790305),
            name: 'name',
            type: 9,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(3, 1481975311493388480),
            name: 'userCanSelect',
            type: 1,
            flags: 0)
      ],
      relations: <obx_int.ModelRelation>[],
      backlinks: <obx_int.ModelBacklink>[]),
  obx_int.ModelEntity(
      id: const obx_int.IdUid(3, 1310094772467892797),
      name: 'AssetTimeValue',
      lastPropertyId: const obx_int.IdUid(5, 3193434996408047750),
      flags: 0,
      properties: <obx_int.ModelProperty>[
        obx_int.ModelProperty(
            id: const obx_int.IdUid(1, 865135241090715348),
            name: 'id',
            type: 6,
            flags: 1),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(2, 8471838922893245555),
            name: 'date',
            type: 10,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(3, 5413860551275972220),
            name: 'value',
            type: 8,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(4, 8729528574984440007),
            name: 'quantity',
            type: 8,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(5, 3193434996408047750),
            name: 'currencyId',
            type: 11,
            flags: 520,
            indexId: const obx_int.IdUid(4, 2434188033820685796),
            relationTarget: 'Currency')
      ],
      relations: <obx_int.ModelRelation>[],
      backlinks: <obx_int.ModelBacklink>[]),
  obx_int.ModelEntity(
      id: const obx_int.IdUid(4, 7344502799727715203),
      name: 'Currency',
      lastPropertyId: const obx_int.IdUid(3, 5520729220967382353),
      flags: 0,
      properties: <obx_int.ModelProperty>[
        obx_int.ModelProperty(
            id: const obx_int.IdUid(1, 9107060263226612733),
            name: 'id',
            type: 6,
            flags: 1),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(2, 4768579693216962491),
            name: 'symbol',
            type: 9,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(3, 5520729220967382353),
            name: 'name',
            type: 9,
            flags: 0)
      ],
      relations: <obx_int.ModelRelation>[],
      backlinks: <obx_int.ModelBacklink>[]),
  obx_int.ModelEntity(
      id: const obx_int.IdUid(6, 2549230891191389848),
      name: 'Settings',
      lastPropertyId: const obx_int.IdUid(6, 8785216237688213096),
      flags: 0,
      properties: <obx_int.ModelProperty>[
        obx_int.ModelProperty(
            id: const obx_int.IdUid(1, 4383666370127515872),
            name: 'id',
            type: 6,
            flags: 1),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(2, 6578063487016878583),
            name: 'defaultCurrencyId',
            type: 11,
            flags: 520,
            indexId: const obx_int.IdUid(3, 5774481709415715408),
            relationTarget: 'Currency'),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(3, 2509006704211905136),
            name: 'startDateGainGraph',
            type: 10,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(4, 4815485716240959814),
            name: 'endDateGainGraph',
            type: 10,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(5, 4316953084599786943),
            name: 'homeGraphIndex',
            type: 6,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(6, 8785216237688213096),
            name: 'showTutorial',
            type: 1,
            flags: 0)
      ],
      relations: <obx_int.ModelRelation>[],
      backlinks: <obx_int.ModelBacklink>[]),
  obx_int.ModelEntity(
      id: const obx_int.IdUid(7, 8021363571026158853),
      name: 'MarketInfo',
      lastPropertyId: const obx_int.IdUid(9, 1088568014202407642),
      flags: 0,
      properties: <obx_int.ModelProperty>[
        obx_int.ModelProperty(
            id: const obx_int.IdUid(1, 5450897663482903483),
            name: 'id',
            type: 6,
            flags: 1),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(2, 9140830800705593354),
            name: 'symbol',
            type: 9,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(3, 9093576918626851731),
            name: 'name',
            type: 9,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(4, 3300257355063995305),
            name: 'type',
            type: 9,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(5, 5272922002615589220),
            name: 'currency',
            type: 9,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(6, 8463851427896342938),
            name: 'region',
            type: 9,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(9, 1088568014202407642),
            name: 'dateLastPriceFetch',
            type: 10,
            flags: 0)
      ],
      relations: <obx_int.ModelRelation>[],
      backlinks: <obx_int.ModelBacklink>[]),
  obx_int.ModelEntity(
      id: const obx_int.IdUid(8, 7487394912198200723),
      name: 'AssetHistoryTimeValue',
      lastPropertyId: const obx_int.IdUid(4, 7977442837461885490),
      flags: 0,
      properties: <obx_int.ModelProperty>[
        obx_int.ModelProperty(
            id: const obx_int.IdUid(1, 5024789284389560285),
            name: 'id',
            type: 6,
            flags: 1),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(2, 358327693471256779),
            name: 'date',
            type: 10,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(3, 7780162268411866185),
            name: 'value',
            type: 8,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(4, 7977442837461885490),
            name: 'assetName',
            type: 9,
            flags: 0)
      ],
      relations: <obx_int.ModelRelation>[],
      backlinks: <obx_int.ModelBacklink>[]),
  obx_int.ModelEntity(
      id: const obx_int.IdUid(10, 5867538031110432434),
      name: 'CurrencyForexChange',
      lastPropertyId: const obx_int.IdUid(5, 5432596696048017419),
      flags: 0,
      properties: <obx_int.ModelProperty>[
        obx_int.ModelProperty(
            id: const obx_int.IdUid(1, 4740523890644035246),
            name: 'id',
            type: 6,
            flags: 1),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(2, 1266780386572025578),
            name: 'name',
            type: 9,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(3, 887083226809787831),
            name: 'date',
            type: 10,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(4, 5781970473616038762),
            name: 'change',
            type: 8,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(5, 5432596696048017419),
            name: 'lastFetchDate',
            type: 10,
            flags: 0)
      ],
      relations: <obx_int.ModelRelation>[],
      backlinks: <obx_int.ModelBacklink>[]),
  obx_int.ModelEntity(
      id: const obx_int.IdUid(11, 2306986170839656647),
      name: 'NetWorthHistory',
      lastPropertyId: const obx_int.IdUid(3, 8622513153300181257),
      flags: 0,
      properties: <obx_int.ModelProperty>[
        obx_int.ModelProperty(
            id: const obx_int.IdUid(1, 1371879321094481246),
            name: 'id',
            type: 6,
            flags: 1),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(2, 8137044112376677082),
            name: 'date',
            type: 10,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(3, 8622513153300181257),
            name: 'value',
            type: 8,
            flags: 0)
      ],
      relations: <obx_int.ModelRelation>[],
      backlinks: <obx_int.ModelBacklink>[]),
  obx_int.ModelEntity(
      id: const obx_int.IdUid(12, 5903921347179551314),
      name: 'CustomPie',
      lastPropertyId: const obx_int.IdUid(2, 7357382118388860697),
      flags: 0,
      properties: <obx_int.ModelProperty>[
        obx_int.ModelProperty(
            id: const obx_int.IdUid(1, 4205562783063258404),
            name: 'id',
            type: 6,
            flags: 1),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(2, 7357382118388860697),
            name: 'name',
            type: 9,
            flags: 0)
      ],
      relations: <obx_int.ModelRelation>[
        obx_int.ModelRelation(
            id: const obx_int.IdUid(3, 9064630919078014490),
            name: 'assets',
            targetId: const obx_int.IdUid(1, 1818913365485819735)),
        obx_int.ModelRelation(
            id: const obx_int.IdUid(4, 2940534397388135956),
            name: 'categories',
            targetId: const obx_int.IdUid(2, 4698624914262505470))
      ],
      backlinks: <obx_int.ModelBacklink>[])
];

/// Shortcut for [Store.new] that passes [getObjectBoxModel] and for Flutter
/// apps by default a [directory] using `defaultStoreDirectory()` from the
/// ObjectBox Flutter library.
///
/// Note: for desktop apps it is recommended to specify a unique [directory].
///
/// See [Store.new] for an explanation of all parameters.
///
/// For Flutter apps, also calls `loadObjectBoxLibraryAndroidCompat()` from
/// the ObjectBox Flutter library to fix loading the native ObjectBox library
/// on Android 6 and older.
Future<obx.Store> openStore(
    {String? directory,
    int? maxDBSizeInKB,
    int? maxDataSizeInKB,
    int? fileMode,
    int? maxReaders,
    bool queriesCaseSensitiveDefault = true,
    String? macosApplicationGroup}) async {
  await loadObjectBoxLibraryAndroidCompat();
  return obx.Store(getObjectBoxModel(),
      directory: directory ?? (await defaultStoreDirectory()).path,
      maxDBSizeInKB: maxDBSizeInKB,
      maxDataSizeInKB: maxDataSizeInKB,
      fileMode: fileMode,
      maxReaders: maxReaders,
      queriesCaseSensitiveDefault: queriesCaseSensitiveDefault,
      macosApplicationGroup: macosApplicationGroup);
}

/// Returns the ObjectBox model definition for this project for use with
/// [Store.new].
obx_int.ModelDefinition getObjectBoxModel() {
  final model = obx_int.ModelInfo(
      entities: _entities,
      lastEntityId: const obx_int.IdUid(12, 5903921347179551314),
      lastIndexId: const obx_int.IdUid(4, 2434188033820685796),
      lastRelationId: const obx_int.IdUid(4, 2940534397388135956),
      lastSequenceId: const obx_int.IdUid(0, 0),
      retiredEntityUids: const [2599935032832553010, 5400605241944609287],
      retiredIndexUids: const [],
      retiredPropertyUids: const [
        6464543030038332834,
        7104168504643419610,
        6233702783877267062,
        3847910549491861168,
        7984061082260616687,
        1873420031035488607,
        5560563163274612759,
        7494022986936963048,
        8125039645251255593,
        3509591852082565968,
        5451300475036688041,
        8954571008166053623,
        9168322847315820519
      ],
      retiredRelationUids: const [4132757054122527006],
      modelVersion: 5,
      modelVersionParserMinimum: 5,
      version: 1);

  final bindings = <Type, obx_int.EntityDefinition>{
    Asset: obx_int.EntityDefinition<Asset>(
        model: _entities[0],
        toOneRelations: (Asset object) => [object.category, object.marketInfo],
        toManyRelations: (Asset object) =>
            {obx_int.RelInfo<Asset>.toMany(1, object.id): object.timeValues},
        getId: (Asset object) => object.id,
        setId: (Asset object, int id) {
          object.id = id;
        },
        objectToFB: (Asset object, fb.Builder fbb) {
          final nameOffset = fbb.writeString(object.name);
          fbb.startTable(7);
          fbb.addInt64(0, object.id);
          fbb.addOffset(1, nameOffset);
          fbb.addInt64(2, object.category.targetId);
          fbb.addInt64(3, object.marketInfo.targetId);
          fbb.addBool(5, object.excludeFromNW);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (obx.Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);
          final nameParam = const fb.StringReader(asciiOptimization: true)
              .vTableGet(buffer, rootOffset, 6, '');
          final object = Asset(nameParam)
            ..id = const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0)
            ..excludeFromNW =
                const fb.BoolReader().vTableGetNullable(buffer, rootOffset, 14);
          object.category.targetId =
              const fb.Int64Reader().vTableGet(buffer, rootOffset, 8, 0);
          object.category.attach(store);
          object.marketInfo.targetId =
              const fb.Int64Reader().vTableGet(buffer, rootOffset, 10, 0);
          object.marketInfo.attach(store);
          obx_int.InternalToManyAccess.setRelInfo<Asset>(object.timeValues,
              store, obx_int.RelInfo<Asset>.toMany(1, object.id));
          return object;
        }),
    AssetCategory: obx_int.EntityDefinition<AssetCategory>(
        model: _entities[1],
        toOneRelations: (AssetCategory object) => [],
        toManyRelations: (AssetCategory object) => {},
        getId: (AssetCategory object) => object.id,
        setId: (AssetCategory object, int id) {
          object.id = id;
        },
        objectToFB: (AssetCategory object, fb.Builder fbb) {
          final nameOffset = fbb.writeString(object.name);
          fbb.startTable(4);
          fbb.addInt64(0, object.id);
          fbb.addOffset(1, nameOffset);
          fbb.addBool(2, object.userCanSelect);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (obx.Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);
          final nameParam = const fb.StringReader(asciiOptimization: true)
              .vTableGet(buffer, rootOffset, 6, '');
          final userCanSelectParam =
              const fb.BoolReader().vTableGet(buffer, rootOffset, 8, false);
          final object = AssetCategory(nameParam,
              userCanSelect: userCanSelectParam)
            ..id = const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0);

          return object;
        }),
    AssetTimeValue: obx_int.EntityDefinition<AssetTimeValue>(
        model: _entities[2],
        toOneRelations: (AssetTimeValue object) => [object.currency],
        toManyRelations: (AssetTimeValue object) => {},
        getId: (AssetTimeValue object) => object.id,
        setId: (AssetTimeValue object, int id) {
          object.id = id;
        },
        objectToFB: (AssetTimeValue object, fb.Builder fbb) {
          fbb.startTable(6);
          fbb.addInt64(0, object.id);
          fbb.addInt64(1, object.date.millisecondsSinceEpoch);
          fbb.addFloat64(2, object.value);
          fbb.addFloat64(3, object.quantity);
          fbb.addInt64(4, object.currency.targetId);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (obx.Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);
          final idParam =
              const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0);
          final dateParam = DateTime.fromMillisecondsSinceEpoch(
              const fb.Int64Reader().vTableGet(buffer, rootOffset, 6, 0));
          final valueParam =
              const fb.Float64Reader().vTableGet(buffer, rootOffset, 8, 0);
          final quantityParam =
              const fb.Float64Reader().vTableGet(buffer, rootOffset, 10, 0);
          final object = AssetTimeValue(
              id: idParam,
              date: dateParam,
              value: valueParam,
              quantity: quantityParam);
          object.currency.targetId =
              const fb.Int64Reader().vTableGet(buffer, rootOffset, 12, 0);
          object.currency.attach(store);
          return object;
        }),
    Currency: obx_int.EntityDefinition<Currency>(
        model: _entities[3],
        toOneRelations: (Currency object) => [],
        toManyRelations: (Currency object) => {},
        getId: (Currency object) => object.id,
        setId: (Currency object, int id) {
          object.id = id;
        },
        objectToFB: (Currency object, fb.Builder fbb) {
          final symbolOffset = fbb.writeString(object.symbol);
          final nameOffset = fbb.writeString(object.name);
          fbb.startTable(4);
          fbb.addInt64(0, object.id);
          fbb.addOffset(1, symbolOffset);
          fbb.addOffset(2, nameOffset);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (obx.Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);
          final symbolParam = const fb.StringReader(asciiOptimization: true)
              .vTableGet(buffer, rootOffset, 6, '');
          final nameParam = const fb.StringReader(asciiOptimization: true)
              .vTableGet(buffer, rootOffset, 8, '');
          final object = Currency(symbolParam, nameParam)
            ..id = const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0);

          return object;
        }),
    Settings: obx_int.EntityDefinition<Settings>(
        model: _entities[4],
        toOneRelations: (Settings object) => [object.defaultCurrency],
        toManyRelations: (Settings object) => {},
        getId: (Settings object) => object.id,
        setId: (Settings object, int id) {
          object.id = id;
        },
        objectToFB: (Settings object, fb.Builder fbb) {
          fbb.startTable(7);
          fbb.addInt64(0, object.id);
          fbb.addInt64(1, object.defaultCurrency.targetId);
          fbb.addInt64(2, object.startDateGainGraph?.millisecondsSinceEpoch);
          fbb.addInt64(3, object.endDateGainGraph?.millisecondsSinceEpoch);
          fbb.addInt64(4, object.homeGraphIndex);
          fbb.addBool(5, object.showTutorial);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (obx.Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);
          final startDateGainGraphValue =
              const fb.Int64Reader().vTableGetNullable(buffer, rootOffset, 8);
          final endDateGainGraphValue =
              const fb.Int64Reader().vTableGetNullable(buffer, rootOffset, 10);
          final showTutorialParam =
              const fb.BoolReader().vTableGetNullable(buffer, rootOffset, 14);
          final object = Settings(showTutorial: showTutorialParam)
            ..id = const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0)
            ..startDateGainGraph = startDateGainGraphValue == null
                ? null
                : DateTime.fromMillisecondsSinceEpoch(startDateGainGraphValue)
            ..endDateGainGraph = endDateGainGraphValue == null
                ? null
                : DateTime.fromMillisecondsSinceEpoch(endDateGainGraphValue)
            ..homeGraphIndex = const fb.Int64Reader()
                .vTableGetNullable(buffer, rootOffset, 12);
          object.defaultCurrency.targetId =
              const fb.Int64Reader().vTableGet(buffer, rootOffset, 6, 0);
          object.defaultCurrency.attach(store);
          return object;
        }),
    MarketInfo: obx_int.EntityDefinition<MarketInfo>(
        model: _entities[5],
        toOneRelations: (MarketInfo object) => [],
        toManyRelations: (MarketInfo object) => {},
        getId: (MarketInfo object) => object.id,
        setId: (MarketInfo object, int id) {
          object.id = id;
        },
        objectToFB: (MarketInfo object, fb.Builder fbb) {
          final symbolOffset = fbb.writeString(object.symbol);
          final nameOffset = fbb.writeString(object.name);
          final typeOffset = fbb.writeString(object.type);
          final currencyOffset = fbb.writeString(object.currency);
          final regionOffset = fbb.writeString(object.region);
          fbb.startTable(10);
          fbb.addInt64(0, object.id ?? 0);
          fbb.addOffset(1, symbolOffset);
          fbb.addOffset(2, nameOffset);
          fbb.addOffset(3, typeOffset);
          fbb.addOffset(4, currencyOffset);
          fbb.addOffset(5, regionOffset);
          fbb.addInt64(8, object.dateLastPriceFetch?.millisecondsSinceEpoch);
          fbb.finish(fbb.endTable());
          return object.id ?? 0;
        },
        objectFromFB: (obx.Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);
          final dateLastPriceFetchValue =
              const fb.Int64Reader().vTableGetNullable(buffer, rootOffset, 20);
          final symbolParam = const fb.StringReader(asciiOptimization: true)
              .vTableGet(buffer, rootOffset, 6, '');
          final nameParam = const fb.StringReader(asciiOptimization: true)
              .vTableGet(buffer, rootOffset, 8, '');
          final typeParam = const fb.StringReader(asciiOptimization: true)
              .vTableGet(buffer, rootOffset, 10, '');
          final currencyParam = const fb.StringReader(asciiOptimization: true)
              .vTableGet(buffer, rootOffset, 12, '');
          final regionParam = const fb.StringReader(asciiOptimization: true)
              .vTableGet(buffer, rootOffset, 14, '');
          final object = MarketInfo(
              symbolParam, nameParam, typeParam, currencyParam, regionParam)
            ..id =
                const fb.Int64Reader().vTableGetNullable(buffer, rootOffset, 4)
            ..dateLastPriceFetch = dateLastPriceFetchValue == null
                ? null
                : DateTime.fromMillisecondsSinceEpoch(dateLastPriceFetchValue);

          return object;
        }),
    AssetHistoryTimeValue: obx_int.EntityDefinition<AssetHistoryTimeValue>(
        model: _entities[6],
        toOneRelations: (AssetHistoryTimeValue object) => [],
        toManyRelations: (AssetHistoryTimeValue object) => {},
        getId: (AssetHistoryTimeValue object) => object.id,
        setId: (AssetHistoryTimeValue object, int id) {
          object.id = id;
        },
        objectToFB: (AssetHistoryTimeValue object, fb.Builder fbb) {
          final assetNameOffset = fbb.writeString(object.assetName);
          fbb.startTable(5);
          fbb.addInt64(0, object.id ?? 0);
          fbb.addInt64(1, object.date.millisecondsSinceEpoch);
          fbb.addFloat64(2, object.value);
          fbb.addOffset(3, assetNameOffset);
          fbb.finish(fbb.endTable());
          return object.id ?? 0;
        },
        objectFromFB: (obx.Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);
          final dateParam = DateTime.fromMillisecondsSinceEpoch(
              const fb.Int64Reader().vTableGet(buffer, rootOffset, 6, 0));
          final valueParam =
              const fb.Float64Reader().vTableGet(buffer, rootOffset, 8, 0);
          final assetNameParam = const fb.StringReader(asciiOptimization: true)
              .vTableGet(buffer, rootOffset, 10, '');
          final object = AssetHistoryTimeValue(
              dateParam, valueParam, assetNameParam)
            ..id =
                const fb.Int64Reader().vTableGetNullable(buffer, rootOffset, 4);

          return object;
        }),
    CurrencyForexChange: obx_int.EntityDefinition<CurrencyForexChange>(
        model: _entities[7],
        toOneRelations: (CurrencyForexChange object) => [],
        toManyRelations: (CurrencyForexChange object) => {},
        getId: (CurrencyForexChange object) => object.id,
        setId: (CurrencyForexChange object, int id) {
          object.id = id;
        },
        objectToFB: (CurrencyForexChange object, fb.Builder fbb) {
          final nameOffset = fbb.writeString(object.name);
          fbb.startTable(6);
          fbb.addInt64(0, object.id);
          fbb.addOffset(1, nameOffset);
          fbb.addInt64(2, object.date.millisecondsSinceEpoch);
          fbb.addFloat64(3, object.change);
          fbb.addInt64(4, object.lastFetchDate.millisecondsSinceEpoch);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (obx.Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);
          final nameParam = const fb.StringReader(asciiOptimization: true)
              .vTableGet(buffer, rootOffset, 6, '');
          final dateParam = DateTime.fromMillisecondsSinceEpoch(
              const fb.Int64Reader().vTableGet(buffer, rootOffset, 8, 0));
          final changeParam =
              const fb.Float64Reader().vTableGet(buffer, rootOffset, 10, 0);
          final lastFetchDateParam = DateTime.fromMillisecondsSinceEpoch(
              const fb.Int64Reader().vTableGet(buffer, rootOffset, 12, 0));
          final object = CurrencyForexChange(
              nameParam, dateParam, changeParam, lastFetchDateParam)
            ..id = const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0);

          return object;
        }),
    NetWorthHistory: obx_int.EntityDefinition<NetWorthHistory>(
        model: _entities[8],
        toOneRelations: (NetWorthHistory object) => [],
        toManyRelations: (NetWorthHistory object) => {},
        getId: (NetWorthHistory object) => object.id,
        setId: (NetWorthHistory object, int id) {
          object.id = id;
        },
        objectToFB: (NetWorthHistory object, fb.Builder fbb) {
          fbb.startTable(4);
          fbb.addInt64(0, object.id ?? 0);
          fbb.addInt64(1, object.date.millisecondsSinceEpoch);
          fbb.addFloat64(2, object.value);
          fbb.finish(fbb.endTable());
          return object.id ?? 0;
        },
        objectFromFB: (obx.Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);
          final dateParam = DateTime.fromMillisecondsSinceEpoch(
              const fb.Int64Reader().vTableGet(buffer, rootOffset, 6, 0));
          final valueParam =
              const fb.Float64Reader().vTableGet(buffer, rootOffset, 8, 0);
          final object = NetWorthHistory(dateParam, valueParam)
            ..id =
                const fb.Int64Reader().vTableGetNullable(buffer, rootOffset, 4);

          return object;
        }),
    CustomPie: obx_int.EntityDefinition<CustomPie>(
        model: _entities[9],
        toOneRelations: (CustomPie object) => [],
        toManyRelations: (CustomPie object) => {
              obx_int.RelInfo<CustomPie>.toMany(3, object.id): object.assets,
              obx_int.RelInfo<CustomPie>.toMany(4, object.id): object.categories
            },
        getId: (CustomPie object) => object.id,
        setId: (CustomPie object, int id) {
          object.id = id;
        },
        objectToFB: (CustomPie object, fb.Builder fbb) {
          final nameOffset = fbb.writeString(object.name);
          fbb.startTable(3);
          fbb.addInt64(0, object.id);
          fbb.addOffset(1, nameOffset);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (obx.Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);
          final nameParam = const fb.StringReader(asciiOptimization: true)
              .vTableGet(buffer, rootOffset, 6, '');
          final object = CustomPie(nameParam)
            ..id = const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0);
          obx_int.InternalToManyAccess.setRelInfo<CustomPie>(object.assets,
              store, obx_int.RelInfo<CustomPie>.toMany(3, object.id));
          obx_int.InternalToManyAccess.setRelInfo<CustomPie>(object.categories,
              store, obx_int.RelInfo<CustomPie>.toMany(4, object.id));
          return object;
        })
  };

  return obx_int.ModelDefinition(model, bindings);
}

/// [Asset] entity fields to define ObjectBox queries.
class Asset_ {
  /// see [Asset.id]
  static final id = obx.QueryIntegerProperty<Asset>(_entities[0].properties[0]);

  /// see [Asset.name]
  static final name =
      obx.QueryStringProperty<Asset>(_entities[0].properties[1]);

  /// see [Asset.category]
  static final category =
      obx.QueryRelationToOne<Asset, AssetCategory>(_entities[0].properties[2]);

  /// see [Asset.marketInfo]
  static final marketInfo =
      obx.QueryRelationToOne<Asset, MarketInfo>(_entities[0].properties[3]);

  /// see [Asset.excludeFromNW]
  static final excludeFromNW =
      obx.QueryBooleanProperty<Asset>(_entities[0].properties[4]);

  /// see [Asset.timeValues]
  static final timeValues =
      obx.QueryRelationToMany<Asset, AssetTimeValue>(_entities[0].relations[0]);
}

/// [AssetCategory] entity fields to define ObjectBox queries.
class AssetCategory_ {
  /// see [AssetCategory.id]
  static final id =
      obx.QueryIntegerProperty<AssetCategory>(_entities[1].properties[0]);

  /// see [AssetCategory.name]
  static final name =
      obx.QueryStringProperty<AssetCategory>(_entities[1].properties[1]);

  /// see [AssetCategory.userCanSelect]
  static final userCanSelect =
      obx.QueryBooleanProperty<AssetCategory>(_entities[1].properties[2]);
}

/// [AssetTimeValue] entity fields to define ObjectBox queries.
class AssetTimeValue_ {
  /// see [AssetTimeValue.id]
  static final id =
      obx.QueryIntegerProperty<AssetTimeValue>(_entities[2].properties[0]);

  /// see [AssetTimeValue.date]
  static final date =
      obx.QueryDateProperty<AssetTimeValue>(_entities[2].properties[1]);

  /// see [AssetTimeValue.value]
  static final value =
      obx.QueryDoubleProperty<AssetTimeValue>(_entities[2].properties[2]);

  /// see [AssetTimeValue.quantity]
  static final quantity =
      obx.QueryDoubleProperty<AssetTimeValue>(_entities[2].properties[3]);

  /// see [AssetTimeValue.currency]
  static final currency = obx.QueryRelationToOne<AssetTimeValue, Currency>(
      _entities[2].properties[4]);
}

/// [Currency] entity fields to define ObjectBox queries.
class Currency_ {
  /// see [Currency.id]
  static final id =
      obx.QueryIntegerProperty<Currency>(_entities[3].properties[0]);

  /// see [Currency.symbol]
  static final symbol =
      obx.QueryStringProperty<Currency>(_entities[3].properties[1]);

  /// see [Currency.name]
  static final name =
      obx.QueryStringProperty<Currency>(_entities[3].properties[2]);
}

/// [Settings] entity fields to define ObjectBox queries.
class Settings_ {
  /// see [Settings.id]
  static final id =
      obx.QueryIntegerProperty<Settings>(_entities[4].properties[0]);

  /// see [Settings.defaultCurrency]
  static final defaultCurrency =
      obx.QueryRelationToOne<Settings, Currency>(_entities[4].properties[1]);

  /// see [Settings.startDateGainGraph]
  static final startDateGainGraph =
      obx.QueryDateProperty<Settings>(_entities[4].properties[2]);

  /// see [Settings.endDateGainGraph]
  static final endDateGainGraph =
      obx.QueryDateProperty<Settings>(_entities[4].properties[3]);

  /// see [Settings.homeGraphIndex]
  static final homeGraphIndex =
      obx.QueryIntegerProperty<Settings>(_entities[4].properties[4]);

  /// see [Settings.showTutorial]
  static final showTutorial =
      obx.QueryBooleanProperty<Settings>(_entities[4].properties[5]);
}

/// [MarketInfo] entity fields to define ObjectBox queries.
class MarketInfo_ {
  /// see [MarketInfo.id]
  static final id =
      obx.QueryIntegerProperty<MarketInfo>(_entities[5].properties[0]);

  /// see [MarketInfo.symbol]
  static final symbol =
      obx.QueryStringProperty<MarketInfo>(_entities[5].properties[1]);

  /// see [MarketInfo.name]
  static final name =
      obx.QueryStringProperty<MarketInfo>(_entities[5].properties[2]);

  /// see [MarketInfo.type]
  static final type =
      obx.QueryStringProperty<MarketInfo>(_entities[5].properties[3]);

  /// see [MarketInfo.currency]
  static final currency =
      obx.QueryStringProperty<MarketInfo>(_entities[5].properties[4]);

  /// see [MarketInfo.region]
  static final region =
      obx.QueryStringProperty<MarketInfo>(_entities[5].properties[5]);

  /// see [MarketInfo.dateLastPriceFetch]
  static final dateLastPriceFetch =
      obx.QueryDateProperty<MarketInfo>(_entities[5].properties[6]);
}

/// [AssetHistoryTimeValue] entity fields to define ObjectBox queries.
class AssetHistoryTimeValue_ {
  /// see [AssetHistoryTimeValue.id]
  static final id = obx.QueryIntegerProperty<AssetHistoryTimeValue>(
      _entities[6].properties[0]);

  /// see [AssetHistoryTimeValue.date]
  static final date =
      obx.QueryDateProperty<AssetHistoryTimeValue>(_entities[6].properties[1]);

  /// see [AssetHistoryTimeValue.value]
  static final value = obx.QueryDoubleProperty<AssetHistoryTimeValue>(
      _entities[6].properties[2]);

  /// see [AssetHistoryTimeValue.assetName]
  static final assetName = obx.QueryStringProperty<AssetHistoryTimeValue>(
      _entities[6].properties[3]);
}

/// [CurrencyForexChange] entity fields to define ObjectBox queries.
class CurrencyForexChange_ {
  /// see [CurrencyForexChange.id]
  static final id =
      obx.QueryIntegerProperty<CurrencyForexChange>(_entities[7].properties[0]);

  /// see [CurrencyForexChange.name]
  static final name =
      obx.QueryStringProperty<CurrencyForexChange>(_entities[7].properties[1]);

  /// see [CurrencyForexChange.date]
  static final date =
      obx.QueryDateProperty<CurrencyForexChange>(_entities[7].properties[2]);

  /// see [CurrencyForexChange.change]
  static final change =
      obx.QueryDoubleProperty<CurrencyForexChange>(_entities[7].properties[3]);

  /// see [CurrencyForexChange.lastFetchDate]
  static final lastFetchDate =
      obx.QueryDateProperty<CurrencyForexChange>(_entities[7].properties[4]);
}

/// [NetWorthHistory] entity fields to define ObjectBox queries.
class NetWorthHistory_ {
  /// see [NetWorthHistory.id]
  static final id =
      obx.QueryIntegerProperty<NetWorthHistory>(_entities[8].properties[0]);

  /// see [NetWorthHistory.date]
  static final date =
      obx.QueryDateProperty<NetWorthHistory>(_entities[8].properties[1]);

  /// see [NetWorthHistory.value]
  static final value =
      obx.QueryDoubleProperty<NetWorthHistory>(_entities[8].properties[2]);
}

/// [CustomPie] entity fields to define ObjectBox queries.
class CustomPie_ {
  /// see [CustomPie.id]
  static final id =
      obx.QueryIntegerProperty<CustomPie>(_entities[9].properties[0]);

  /// see [CustomPie.name]
  static final name =
      obx.QueryStringProperty<CustomPie>(_entities[9].properties[1]);

  /// see [CustomPie.assets]
  static final assets =
      obx.QueryRelationToMany<CustomPie, Asset>(_entities[9].relations[0]);

  /// see [CustomPie.categories]
  static final categories = obx.QueryRelationToMany<CustomPie, AssetCategory>(
      _entities[9].relations[1]);
}
