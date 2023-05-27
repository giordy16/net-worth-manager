import 'package:floor/floor.dart';
import 'dart:async';
import 'package:sqflite/sqflite.dart' as sqflite;

import 'package:net_worth_manager/data/ProductEntity.dart';
import 'package:net_worth_manager/data/TransactionEntity.dart';
import 'package:net_worth_manager/domain/database/dao/ProductDAO.dart';
import 'package:net_worth_manager/domain/database/dao/TransactionDAO.dart';

part 'AppDatabase.g.dart';

@Database(version: 2, entities: [TransactionEntity, ProductEntity])
abstract class AppDatabase extends FloorDatabase {
  TransactionDAO get transactionDAO;
  ProductDAO get productDAO;
}