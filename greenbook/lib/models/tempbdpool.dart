// File: temp_db_pools.dart
import 'package:greenbook/models/products.dart'; // Replace with your actual import path for Products class
import 'package:greenbook/models/pool.dart';
import 'package:greenbook/models/tempdb_seller.dart'; // Replace with your actual import path for Pool class

class TempDBPools {
  // Sample data for pools
  static List<Pool> pools = [
    Pool(
      poolId: 1,
      poolName: 'Pool1',
      poolPin: '1234',
      poolitems: [
        Products(
          productId: 1,
          sellerData: TempDBSeller.sellers
              .firstWhere((element) => element.sellerName == 'John Doe'),
          productName: 'Product1',
          productType: 'Type1',
          productDescription: 'Description of Product1',
          productQuality: 'High',
          productPrice: 10.0,
        ),
        Products(
          productId: 2,
          sellerData: TempDBSeller.sellers
              .firstWhere((element) => element.sellerName == 'John Doe'),
          productName: 'Product2',
          productType: 'Type2',
          productDescription: 'Description of Product2',
          productQuality: 'Medium',
          productPrice: 20.0,
        ),
      ],
    ),
    Pool(
      poolId: 2,
      poolName: 'Pool2',
      poolPin: '5678',
      poolitems: [
        Products(
          productId: 3,
          sellerData: TempDBSeller.sellers
              .firstWhere((element) => element.sellerName == 'John Doe'),
          productName: 'Product3',
          productType: 'Type3',
          productDescription: 'Description of Product3',
          productQuality: 'Low',
          productPrice: 30.0,
        ),
        Products(
          productId: 4,
          sellerData: TempDBSeller.sellers
              .firstWhere((element) => element.sellerName == 'John Doe'),
          productName: 'Product4',
          productType: 'Type4',
          productDescription: 'Description of Product4',
          productQuality: 'High',
          productPrice: 40.0,
        ),
      ],
    ),
  ];
}
