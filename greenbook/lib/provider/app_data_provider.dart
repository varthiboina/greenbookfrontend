import 'package:flutter/material.dart';
import 'package:greenbook/dataSource/data_source.dart';
import 'package:greenbook/dataSource/dummy_data_source.dart';

import 'package:greenbook/models/pool.dart';
import 'package:greenbook/models/products.dart';
import 'package:greenbook/models/profile.dart';

class AppDataProvider extends ChangeNotifier {
  final DataSource _dataSource = DummyDataSource();
  Future<Profile?> getLogin(String userName) {
    return _dataSource.getLogin(userName);
  }

  Future<Pool?> getPool(String poolName, String pin) {
    return _dataSource.getPool(poolName, pin);
  }

  Future<List<Products>> getPoolList(String poolName) {
    return _dataSource.getPoolList(poolName);
  }
}
