// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'AppDatabase.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$AppDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$AppDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  TransactionDAO? _transactionDAOInstance;

  ProductDAO? _productDAOInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 2,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `TransactionEntity` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `product` TEXT NOT NULL, `date` TEXT NOT NULL, `price` REAL NOT NULL, `qt` REAL NOT NULL, `currencyTransaction` TEXT NOT NULL, FOREIGN KEY (`product`) REFERENCES `ProductEntity` (`ticker`) ON UPDATE NO ACTION ON DELETE NO ACTION)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `ProductEntity` (`ticker` TEXT NOT NULL, `name` TEXT NOT NULL, `type` TEXT NOT NULL, `currency` TEXT NOT NULL, `lastPrice` REAL NOT NULL, `lastPriceOnMainCurrency` REAL NOT NULL, `isin` TEXT, `annualTer` REAL, PRIMARY KEY (`ticker`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  TransactionDAO get transactionDAO {
    return _transactionDAOInstance ??=
        _$TransactionDAO(database, changeListener);
  }

  @override
  ProductDAO get productDAO {
    return _productDAOInstance ??= _$ProductDAO(database, changeListener);
  }
}

class _$TransactionDAO extends TransactionDAO {
  _$TransactionDAO(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _transactionEntityInsertionAdapter = InsertionAdapter(
            database,
            'TransactionEntity',
            (TransactionEntity item) => <String, Object?>{
                  'id': item.id,
                  'product': item.product,
                  'date': item.date,
                  'price': item.price,
                  'qt': item.qt,
                  'currencyTransaction': item.currencyTransaction
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<TransactionEntity> _transactionEntityInsertionAdapter;

  @override
  Future<List<TransactionEntity>> findAllTransactions() async {
    return _queryAdapter.queryList('SELECT * FROM TransactionEntity',
        mapper: (Map<String, Object?> row) => TransactionEntity(
            row['date'] as String,
            row['price'] as double,
            row['qt'] as double,
            row['currencyTransaction'] as String,
            row['product'] as String));
  }

  @override
  Future<List<TransactionEntity>?> findAllTransactionByProduct(
      String product) async {
    return _queryAdapter.queryList(
        'SELECT * FROM TransactionEntity WHERE product = ?1',
        mapper: (Map<String, Object?> row) => TransactionEntity(
            row['date'] as String,
            row['price'] as double,
            row['qt'] as double,
            row['currencyTransaction'] as String,
            row['product'] as String),
        arguments: [product]);
  }

  @override
  Future<void> insertTransaction(TransactionEntity transaction) async {
    await _transactionEntityInsertionAdapter.insert(
        transaction, OnConflictStrategy.abort);
  }
}

class _$ProductDAO extends ProductDAO {
  _$ProductDAO(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _productEntityInsertionAdapter = InsertionAdapter(
            database,
            'ProductEntity',
            (ProductEntity item) => <String, Object?>{
                  'ticker': item.ticker,
                  'name': item.name,
                  'type': item.type,
                  'currency': item.currency,
                  'lastPrice': item.lastPrice,
                  'lastPriceOnMainCurrency': item.lastPriceOnMainCurrency,
                  'isin': item.isin,
                  'annualTer': item.annualTer
                }),
        _productEntityUpdateAdapter = UpdateAdapter(
            database,
            'ProductEntity',
            ['ticker'],
            (ProductEntity item) => <String, Object?>{
                  'ticker': item.ticker,
                  'name': item.name,
                  'type': item.type,
                  'currency': item.currency,
                  'lastPrice': item.lastPrice,
                  'lastPriceOnMainCurrency': item.lastPriceOnMainCurrency,
                  'isin': item.isin,
                  'annualTer': item.annualTer
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<ProductEntity> _productEntityInsertionAdapter;

  final UpdateAdapter<ProductEntity> _productEntityUpdateAdapter;

  @override
  Future<List<ProductEntity>> findAllProducts() async {
    return _queryAdapter.queryList('SELECT * FROM ProductEntity',
        mapper: (Map<String, Object?> row) => ProductEntity(
            row['name'] as String,
            row['ticker'] as String,
            row['type'] as String,
            row['currency'] as String,
            row['lastPrice'] as double,
            row['lastPriceOnMainCurrency'] as double,
            isin: row['isin'] as String?,
            annualTer: row['annualTer'] as double?));
  }

  @override
  Future<ProductEntity?> findProductById(String ticker) async {
    return _queryAdapter.query('SELECT * FROM ProductEntity WHERE ticker = ?1',
        mapper: (Map<String, Object?> row) => ProductEntity(
            row['name'] as String,
            row['ticker'] as String,
            row['type'] as String,
            row['currency'] as String,
            row['lastPrice'] as double,
            row['lastPriceOnMainCurrency'] as double,
            isin: row['isin'] as String?,
            annualTer: row['annualTer'] as double?),
        arguments: [ticker]);
  }

  @override
  Future<void> insertProduct(ProductEntity products) async {
    await _productEntityInsertionAdapter.insert(
        products, OnConflictStrategy.ignore);
  }

  @override
  Future<void> updateProduct(ProductEntity products) async {
    await _productEntityUpdateAdapter.update(
        products, OnConflictStrategy.abort);
  }
}
