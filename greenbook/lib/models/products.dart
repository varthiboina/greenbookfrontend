import 'package:greenbook/models/seller.dart';

class Products {
  int? productId;
  Seller sellerData;
  String productName;
  String productType;
  String productDescription;
  String productQuality;
  double productPrice;

  Products(
      {this.productId,
      required this.sellerData,
      required this.productName,
      required this.productType,
      required this.productDescription,
      required this.productQuality,
      required this.productPrice});
}
