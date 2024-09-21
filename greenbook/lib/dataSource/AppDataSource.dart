import 'dart:io';

import 'package:greenbook/dataSource/data_source.dart';
import 'package:greenbook/models/app_user.dart';
import 'package:greenbook/models/auth_response_model.dart';
import 'package:greenbook/models/pool.dart';
import 'package:greenbook/models/products.dart';
import 'package:greenbook/models/profile.dart';
import 'package:greenbook/models/response_model.dart';
import 'package:greenbook/models/seller.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class Appdatasource extends DataSource {
  final String baseUrl = 'http://yardsailbuild.us-east-1.elasticbeanstalk.com';

  Map<String, String> get header => {'Content-Type': 'application/json'};

  @override
  Future<ResponseModel> addFavoriteProduct(String productId, String userId) {
    // TODO: implement addFavoriteProduct
    throw UnimplementedError();
  }

  @override
  Future<ResponseModel> addProduct(Products product) async {
    final uri = Uri.parse('http://10.0.2.2:8081/api/products/add');

    try {
      final request = http.MultipartRequest('POST', uri)
        ..fields['productName'] = product.productName!
        ..fields['sellerId'] = 'Hello'
        ..fields['quality'] = product.productQuality!
        ..fields['productDescription'] = product.productDescription!
        ..fields['productType'] = product.productType!
        ..fields['price'] = product.productPrice.toString();

      if (product.image != null) {
        final file = await http.MultipartFile.fromPath(
          'file',
          product.image!
              .url!, // Ensure the image property in Products has the path
          contentType:
              MediaType('image', 'jpeg'), // Set appropriate content type
        );
        request.files.add(file);
      }

      final response = await request.send();

      if (response.statusCode == 200) {
        return ResponseModel(
          // responseStatus: ResponseStatus.success, // Use appropriate enum value
          statusCode: response.statusCode,
          message: 'Product added successfully',
          object: {}, // You can include any additional data if needed
        );
      } else {
        return ResponseModel(
          //   responseStatus: ResponseStatus.failure, // Use appropriate enum value
          statusCode: response.statusCode,
          message: 'Failed to add product',
          object: {}, // You can include any additional data if needed
        );
      }
    } catch (e) {
      return ResponseModel(
        // responseStatus: ResponseStatus.error, // Use appropriate enum value
        statusCode:
            500, // Internal server error or any other default error code
        message: 'Error: $e',
        object: {}, // You can include any additional data if needed
      );
    }
  }

  Future<ResponseModel> addPool(Pool pool) async {
    final uri =
        Uri.parse('${baseUrl}pools/add'); // Adjust the endpoint URL as needed

    try {
      final request = http.MultipartRequest('POST', uri)
        ..fields['poolName'] = pool.poolName
        ..fields['poolPin'] = pool.poolPin
        ..fields['poolDescription'] = pool.poolDescription;

      if (pool.sellersList != null) {
        final sellersJson = pool.sellersList!.map((seller) {
          return jsonEncode({
            'sellerId': seller.sellerId,
            'sellerName': seller.sellerName,
            'sellerMobile': seller.sellerMobile,
            'sellerEmail': seller.sellerEmail,
          });
        }).toList();

        request.fields['sellersList'] = jsonEncode(sellersJson);
      }

      final response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        return ResponseModel(
          statusCode: response.statusCode,
          message: 'Pool added successfully',
          object: jsonDecode(responseBody),
        );
      } else {
        final responseBody = await response.stream.bytesToString();
        return ResponseModel(
          statusCode: response.statusCode,
          message: 'Failed to add pool',
          object: jsonDecode(responseBody),
        );
      }
    } catch (e) {
      return ResponseModel(
        statusCode:
            500, // Internal server error or any other default error code
        message: 'Error: $e',
        object: {},
      );
    }
  }

  @override
  Future<ResponseModel> deleteProduct(String productId) {
    // TODO: implement deleteProduct
    throw UnimplementedError();
  }

  @override
  Future<List<Products>> getAllProducts() {
    // TODO: implement getAllProducts
    throw UnimplementedError();
  }

  @override
  Future<List<Products>> getFavoriteProducts(String userId) {
    // TODO: implement getFavoriteProducts
    throw UnimplementedError();
  }

  @override
  Future<Profile?> getLogin(String userName) {
    // TODO: implement getLogin
    throw UnimplementedError();
  }

  @override
  Future<Pool?> getPool(String poolName, String pin) {
    // TODO: implement getPool
    throw UnimplementedError();
  }

  @override
  Future<List<Products>> getPoolList(String poolName) {
    // TODO: implement getPoolList
    throw UnimplementedError();
  }

  @override
  Future<Products?> getProductById(String productId) {
    // TODO: implement getProductById
    throw UnimplementedError();
  }

  @override
  Future<List<Products>> getProductsByCategory(String category) {
    // TODO: implement getProductsByCategory
    throw UnimplementedError();
  }

  @override
  Future<List<Products>> getProductsBySeller(String sellerId) {
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
  Future<ResponseModel> updateProduct(Products product) {
    // TODO: implement updateProduct
    throw UnimplementedError();
  }

  @override
  Future<ResponseModel> addUser(Seller seller) {
    // TODO: implement addUser
    throw UnimplementedError();
  }

  Future<bool> checkPoolExistence(String poolName, String poolPin) async {
    final uri =
        Uri.parse('$baseUrl/pools/check?poolName=$poolName&poolPin=$poolPin');
    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data as bool;
      } else {
        throw Exception('Failed to check pool existence');
      }
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }

  Future<List<Products>> fetchProductsByPoolId(int poolId) async {
    final response =
        await http.get(Uri.parse('$baseUrl/pools/$poolId/getallproducts'));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Products.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  Future<ResponseModel> addSellerToPool(String poolName, Seller seller) async {
    final uri = Uri.parse('$baseUrl/$poolName/sellers');

    try {
      // Convert the seller object to JSON
      final body = jsonEncode(seller.toJson());

      // Make the POST request
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      // Process the response
      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        return ResponseModel(
          statusCode: response.statusCode,
          message: 'Seller added to pool successfully',
          object: responseBody,
        );
      } else {
        return ResponseModel(
          statusCode: response.statusCode,
          message: 'Failed to add seller to pool',
          object: jsonDecode(response.body),
        );
      }
    } catch (e) {
      return ResponseModel(
        statusCode:
            500, // Internal server error or any other default error code
        message: 'Error: $e',
        object: {},
      );
    }
  }

  @override
  Future<List<Products>> getProductsBySellerId(String sellerId) {
    // TODO: implement getProductsBySellerId
    throw UnimplementedError();
  }

  @override
  Future<Seller?> getUser(String sellerUid) {
    // TODO: implement getUser
    throw UnimplementedError();
  }

  @override
  Future<Seller> getUserbyUid(String sellerUid) {
    // TODO: implement getUserbyUid
    throw UnimplementedError();
  }
}
