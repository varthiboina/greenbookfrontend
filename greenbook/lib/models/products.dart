import 'package:greenbook/models/ImageData.dart';

class Products {
  int? productId; // Change to int? if productId in JSON is an integer
  String? sellerId;
  String? poolName;
  String? productName;
  String? productType;
  String? productDescription;
  String? productQuality;
  double? productPrice;
  ImageData? image;

  Products({
    this.productId,
    this.sellerId,
    this.poolName,
    this.productName,
    this.productType,
    this.productDescription,
    this.productQuality,
    this.productPrice,
    this.image,
  });

  factory Products.fromJson(Map<String, dynamic> json) {
    return Products(
      productId: json['productId'] is int
          ? json['productId']
          : int.tryParse(json['productId'].toString() ?? '0'),
      sellerId: json['sellerUid'],
      poolName: json['poolName'],
      productName: json['productName'],
      productType: json['productType'],
      productDescription: json['productDescription'],
      productQuality: json['quality'],
      productPrice: (json['price'] as num?)?.toDouble(),
      image: json['image'] != null ? ImageData.fromJson(json['image']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId, // Convert to int if needed
      'sellerUid': sellerId,
      'poolName': poolName,
      'productName': productName,
      'productType': productType,
      'productDescription': productDescription,
      'productQuality': productQuality,
      'productPrice': productPrice,
      'image': image?.toJson(),
    };
  }
}
