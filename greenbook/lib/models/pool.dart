import 'package:greenbook/models/products.dart';

class Pool {
  int? poolId;
  String poolName;
  String poolPin;
  List<Products> poolitems;

  Pool({
    this.poolId,
    required this.poolName,
    required this.poolPin,
    required this.poolitems,
  });
}
