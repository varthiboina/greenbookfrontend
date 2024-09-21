import 'dart:convert';
import 'package:greenbook/models/products.dart';

class Seller {
  String? sellerId;
  String sellerName;
  String? sellerMobile;
  String? sellerEmail;
  List<Products>? productsList;

  Seller({
    this.sellerId,
    required this.sellerName,
    this.sellerMobile,
    this.sellerEmail,
    this.productsList,
  });

  // Convert a Seller instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'sellerUid': sellerId,
      'sellerName': sellerName,
      'mobile': sellerMobile,
      'email': sellerEmail,
      'productsList': productsList?.map((product) => product.toJson()).toList(),
    };
  }

  // Convert a JSON map to a Seller instance
  factory Seller.fromJson(Map<String, dynamic> json) {
    return Seller(
      sellerId: json['sellerId'],
      sellerName: json['sellerName'],
      sellerMobile: json['sellerMobile'],
      sellerEmail: json['email'],
      productsList: (json['productsList'] as List<dynamic>?)
          ?.map((item) => Products.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}
