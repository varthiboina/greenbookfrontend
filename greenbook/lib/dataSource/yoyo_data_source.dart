import 'dart:convert';

import 'package:greenbook/dataSource/data_source.dart';
import 'package:greenbook/models/products.dart';
import 'package:greenbook/models/seller.dart';
import 'package:greenbook/models/tempbdpool.dart';
import 'package:greenbook/models/app_user.dart';
import 'package:greenbook/models/auth_response_model.dart';
import 'package:greenbook/models/pool.dart';
import 'package:greenbook/models/products.dart' as products;
import 'package:greenbook/models/profile.dart';
import 'package:greenbook/models/response_model.dart';
import 'package:greenbook/models/tempdb_profiles.dart';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart'; // Ensure this is added

class DummyDataSource extends DataSource {
  final String baseUrl = 'http://yardsailbuild.us-east-1.elasticbeanstalk.com/api';

  Map<String, String> get header => {'Content-Type': 'application/json'};

  Future<ResponseModel> addPool(Pool pool) async {
    final uri =
        Uri.parse('$baseUrl/pools/add'); // Adjust the endpoint URL as needed

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
          object: {},
        );
      } else {
        final responseBody = await response.stream.bytesToString();
        return ResponseModel(
          statusCode: response.statusCode,
          message: 'Failed to add pool',
          object: {},
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

  Future<ResponseModel> addProduct(Products product) async {
    final uri = Uri.parse('$baseUrl/products/add');

    try {
      final request = http.MultipartRequest('POST', uri)
        ..fields['productName'] = product.productName!
        ..fields['quality'] = product.productQuality!
        ..fields['productDescription'] = product.productDescription!
        ..fields['sellerId'] = product.sellerId!
        ..fields['poolName'] = product.poolName!
        ..fields['price'] = product.productPrice.toString();

      // Get the MIME type

      if (product.image != null) {
        final mimeType = lookupMimeType(product.image!.url!);
        product.image!.type = mimeType ?? 'application/octet-stream';
        final file = await http.MultipartFile.fromPath(
          'file',
          product.image!.url!,
          contentType: MediaType.parse(product.image!.type),
        );
        request.files.add(file);
      }

      final response = await request.send();

      if (response.statusCode == 200) {
        return ResponseModel(
          statusCode: response.statusCode,
          message: 'Product added successfully',
          object: {},
        );
      } else {
        return ResponseModel(
          statusCode: response.statusCode,
          message: 'Failed to add product',
          object: {},
        );
      }
    } catch (e) {
      return ResponseModel(
        statusCode: 500,
        message: 'Error: $e',
        object: {},
      );
    }
  }

  @override
  Future<ResponseModel> addFavoriteProduct(String productId, String userId) {
    // TODO: implement addFavoriteProduct
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
  Future<List<Products>> getProductsBySellerId(String sellerId) async {
    final uri = Uri.parse('$baseUrl/products/seller/$sellerId');

    try {
      final response = await http.get(uri).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Products.fromJson(json)).toList();
      } else {
        print('Failed to load products: ${response.statusCode}');
        throw Exception('Failed to load products');
      }
    } on http.ClientException catch (e) {
      print('ClientException: $e');
      throw Exception('Network error: $e');
    } on FormatException catch (e) {
      print('FormatException: $e');
      throw Exception('Error parsing data: $e');
    } on Exception catch (e) {
      print('Exception: $e');

      throw Exception('Error fetching products: $e');
    }
  }

  Future<List<Products>> getPoolList(String poolName) async {
    final uri = Uri.parse('$baseUrl/products/pool/$poolName');

    try {
      final response = await http.get(uri).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Products.fromJson(json)).toList();
      } else {
        print('Failed to load products: ${response.statusCode}');
        throw Exception('Failed to load products');
      }
    } on http.ClientException catch (e) {
      print('ClientException: $e');
      throw Exception('Network error: $e');
    } on FormatException catch (e) {
      print('FormatException: $e');
      throw Exception('Error parsing data: $e');
    } on Exception catch (e) {
      print('Exception: $e');
      throw Exception('Error fetching products: $e');
    }
  }

  @override
  Future<ResponseModel> addUser(Seller seller) async {
    final uri =
        Uri.parse('$baseUrl/seller/add'); // Adjust the URL to your API endpoint

    try {
      // Create a multipart request
      final request = http.MultipartRequest('POST', uri)
        ..fields['sellerId'] = seller.sellerId!
        ..fields['sellerName'] = seller.sellerName
        ..fields['email'] = seller.sellerEmail!;

      // Send the request
      final response = await request.send();

      // Process the response
      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final data = jsonDecode(responseBody);

        // Assuming ResponseModel has a constructor that takes status code, message, and data
        return ResponseModel(
          statusCode: response.statusCode,
          message: 'Seller added successfully',
          object: {},
        );
      } else {
        return ResponseModel(
          statusCode: response.statusCode,
          message: 'Failed to add seller',
          object: {},
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
  Future<ResponseModel> addSellerToPool(String poolName, Seller seller) async {
    final uri = Uri.parse('$baseUrl/pools/$poolName/sellers');

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
  Future<bool> checkPoolExistence(String poolName, String poolPin) async {
    final uri =
        Uri.parse('$baseUrl/pools/check?poolName=$poolName&poolPin=$poolPin');
    final response = await http.get(uri);
    try {
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

  @override
  Future<Seller> getUserbyUid(String sellerUid) async {
    final response =
        await http.get(Uri.parse('$baseUrl/seller/uid/$sellerUid'));

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return Seller.fromJson(json);
    } else {
      throw Exception('Failed to load seller');
    }
  }

  //@override
  //Future<List<Products>> getPoolList(String poolName) async {
  //List<Products> allProducts = [];
  //for (var pool
  //  in TempDBPools.pools.where((element) => element.poolName == poolName)) {
  //allProducts.addAll(pool.poolitems!);
  // }
  // return allProducts;
  //}
}
