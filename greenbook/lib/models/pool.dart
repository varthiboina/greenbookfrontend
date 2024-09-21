import 'package:greenbook/models/products.dart';
import 'package:greenbook/models/seller.dart';

class Pool {
  int? poolId;
  String poolName;
  String poolPin;
  String poolDescription;
  List<Seller>? sellersList;

  Pool({
    this.poolId,
    required this.poolName,
    required this.poolPin,
    required this.poolDescription,
    this.sellersList,
  });
}
