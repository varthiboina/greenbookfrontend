import 'package:greenbook/models/seller.dart';

class TempDBSeller {
  // Sample data for sellers
  static List<Seller> sellers = [
    Seller(
      sellerId: 'abc',
      sellerName: 'John Doe',
      sellerMobile: '123-456-7890',
      sellerEmail: 'john.doe@example.com',
    ),
    Seller(
      sellerId: 'abc',
      sellerName: 'Jane Smith',
      sellerMobile: '987-654-3210',
      sellerEmail: 'jane.smith@example.com',
    ),
  ];
}
