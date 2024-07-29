import 'package:greenbook/dataSource/data_source.dart';
import 'package:greenbook/models/products.dart';
import 'package:greenbook/models/tempbdpool.dart';
import 'package:greenbook/models/app_user.dart';
import 'package:greenbook/models/auth_response_model.dart';
import 'package:greenbook/models/pool.dart';
import 'package:greenbook/models/products.dart' as products;
import 'package:greenbook/models/profile.dart';
import 'package:greenbook/models/response_model.dart';
import 'package:greenbook/models/tempdb_profiles.dart';

class DummyDataSource extends DataSource {
  @override
  Future<ResponseModel> addFavoriteProduct(String productId, String userId) {
    // TODO: implement addFavoriteProduct
    throw UnimplementedError();
  }

  @override
  Future<ResponseModel> addProduct(products.Products product) {
    // TODO: implement addProduct
    throw UnimplementedError();
  }

  @override
  Future<ResponseModel> deleteProduct(String productId) {
    // TODO: implement deleteProduct
    throw UnimplementedError();
  }

  @override
  Future<List<products.Products>> getAllProducts() {
    // TODO: implement getAllProducts
    throw UnimplementedError();
  }

  @override
  Future<List<products.Products>> getFavoriteProducts(String userId) {
    // TODO: implement getFavoriteProducts
    throw UnimplementedError();
  }

  @override
  Future<products.Products?> getProductById(String productId) {
    // TODO: implement getProductById
    throw UnimplementedError();
  }

  @override
  Future<List<products.Products>> getProductsByCategory(String category) {
    // TODO: implement getProductsByCategory
    throw UnimplementedError();
  }

  @override
  Future<List<products.Products>> getProductsBySeller(String sellerId) {
    // TODO: implement getProductsBySeller
    throw UnimplementedError();
  }

  @override
  Future<AuthResponseModel?> login(AppUser user) {
    // TODO: implement login
    throw UnimplementedError();
  }

  @override
  Future<ResponseModel> removeFavoriteProduct(String productId, String userId) {
    // TODO: implement removeFavoriteProduct
    throw UnimplementedError();
  }

  @override
  Future<ResponseModel> updateProduct(products.Products product) {
    // TODO: implement updateProduct
    throw UnimplementedError();
  }

  @override
  Future<Profile?> getLogin(String userName) async {
    try {
      final user = TempDBProfile.profiles
          .firstWhere((element) => element.profileName == userName);
      return user;
    } on StateError {
      return null;
    }
  }

  @override
  Future<Pool?> getPool(String poolName, String pin) async {
    try {
      final poolData = TempDBPools.pools.firstWhere(
          (element) => element.poolName == poolName && element.poolPin == pin);
      return poolData;
    } on StateError {
      return null;
    }
  }

  @override
  Future<List<Products>> getPoolList(String poolName) async {
    List<Products> allProducts = [];
    for (var pool
        in TempDBPools.pools.where((element) => element.poolName == poolName)) {
      allProducts.addAll(pool.poolitems);
    }
    return allProducts;
  }
}
