import 'package:greenbook/models/app_user.dart';
import 'package:greenbook/models/auth_response_model.dart';
import 'package:greenbook/models/pool.dart';
import 'package:greenbook/models/profile.dart';
import 'package:greenbook/models/response_model.dart';
import 'package:greenbook/models/products.dart';
import 'package:greenbook/models/seller.dart';

abstract class DataSource {
  Future<Profile?> getLogin(String userName);
  Future<Pool?> getPool(String poolName, String pin);
  Future<List<Products>> getPoolList(String poolName);
  Future<AuthResponseModel?> login(AppUser user);
  Future<ResponseModel> addUser(Seller seller);
  Future<ResponseModel> addSellerToPool(String poolName, Seller seller);
  Future<ResponseModel> addProduct(Products product);
  Future<List<Products>> getAllProducts();
  Future<ResponseModel> addPool(Pool pool);
  Future<Seller> getUserbyUid(String sellerUid);
  Future<Products?> getProductById(String productId);
  Future<List<Products>> getProductsBySellerId(String sellerId);
  Future<ResponseModel> updateProduct(Products product);
  Future<ResponseModel> deleteProduct(String productId);
  Future<List<Products>> getProductsByCategory(String category);
  Future<List<Products>> getProductsBySeller(String sellerId);
  Future<ResponseModel> addFavoriteProduct(String productId, String userId);
  Future<List<Products>> getFavoriteProducts(String userId);
  Future<ResponseModel> removeFavoriteProduct(String productId, String userId);

  Future<bool> checkPoolExistence(String poolName, String poolPin);
}
