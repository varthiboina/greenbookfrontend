import 'package:greenbook/models/products.dart';
import 'package:greenbook/models/tempdb_seller.dart';

class TempDB {
  // Sample data for products
  static List<Products> products = [
    Products(
      productId: 1,
      sellerData: TempDBSeller.sellers[0],
      productName: 'Smartphone',
      productType: 'Electronics',
      productDescription: 'High-end smartphone with great features.',
      productQuality: 'New',
      productPrice: 799.99,
    ),
    Products(
      productId: 2,
      sellerData: TempDBSeller.sellers[0],
      productName: 'Laptop',
      productType: 'Electronics',
      productDescription: 'Powerful laptop for work and gaming.',
      productQuality: 'Used',
      productPrice: 1499.99,
    ),
    Products(
      productId: 3,
      sellerData: TempDBSeller.sellers[1],
      productName: 'Furniture Set',
      productType: 'Furniture',
      productDescription: 'Modern furniture set for living room.',
      productQuality: 'Refurbished',
      productPrice: 999.99,
    ),
  ];
}
