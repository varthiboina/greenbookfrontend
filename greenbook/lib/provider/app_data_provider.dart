import 'package:flutter/material.dart';
import 'package:greenbook/dataSource/AppDataSource.dart';
import 'package:greenbook/dataSource/data_source.dart';
import 'package:greenbook/dataSource/yoyo_data_source.dart';
import 'package:greenbook/models/app_user.dart';
import 'package:greenbook/models/auth_response_model.dart';

import 'package:greenbook/models/pool.dart';
import 'package:greenbook/models/products.dart';
import 'package:greenbook/models/profile.dart';
import 'package:greenbook/models/response_model.dart';
import 'package:greenbook/models/seller.dart';

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

  Future<AuthResponseModel?> login(AppUser user) async {
    return null;
  }

  Future<ResponseModel> addProduct(Products product) async {
    return _dataSource.addProduct(product);
  }

  Future<ResponseModel> addUser(Seller seller) async {
    return _dataSource.addUser(seller);
  }

  Future<bool> checkPoolExistence(String poolName, String poolPin) {
    return _dataSource.checkPoolExistence(poolName, poolPin);
  }

  Future<List<Products>> getProductsBySellerId(String sellerId) {
    return _dataSource.getProductsBySellerId(sellerId);
  }

  Future<ResponseModel> addSellerToPool(String poolName, Seller seller) {
    return _dataSource.addSellerToPool(poolName, seller);
  }

  Future<Seller?> getUserbyUid(String sellerUid) {
    return _dataSource.getUserbyUid(sellerUid);
  }

  Future<ResponseModel> addPool(Pool pool) {
    return _dataSource.addPool(pool);
  }
}
