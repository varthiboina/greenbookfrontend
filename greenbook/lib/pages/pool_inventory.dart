import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:greenbook/models/products.dart';
import 'package:greenbook/pages/AddProductPage.dart';
import 'package:greenbook/pages/productDetailsPage.dart';
import 'package:greenbook/utils/Services/auth_services.dart';
import 'package:greenbook/utils/Services/database_service.dart';
import 'package:greenbook/utils/constants.dart';
import 'package:provider/provider.dart';
import 'package:greenbook/provider/app_data_provider.dart';

class PoolInventory extends StatefulWidget {
  const PoolInventory({super.key});

  @override
  State<PoolInventory> createState() => _PoolInventoryState();
}

class _PoolInventoryState extends State<PoolInventory> {
  late List<Products> products;
  late int checkIfYouOwn;
  late String poolName;
  final GetIt _getIt = GetIt.instance;
  late AuthService _authService;
  late DatabaseService _databaseService;

  @override
  void initState() {
    super.initState();
    _authService = _getIt.get<AuthService>();
    _databaseService = _getIt.get<DatabaseService>();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final argList = ModalRoute.of(context)!.settings.arguments as List;
    Iterable<Products> items = argList[0];
    products = items.toList();

    checkIfYouOwn = argList[1];
    poolName = argList[2];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pool Inventory'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(
                context,
                addProductPage,
                arguments: [products, checkIfYouOwn, poolName],
              );
            },
          ),
        ],
      ),
      body: products.isEmpty
          ? const Center(child: Text('No products available'))
          : GridView.builder(
              padding: const EdgeInsets.all(8.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 2 / 3,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return PoolInventoryView(
                    products: product,
                    checkIfYouOwn: checkIfYouOwn,
                    poolName: poolName);
              },
            ),
    );
  }
}

class PoolInventoryView extends StatelessWidget {
  final Products products;
  final String poolName;
  final int checkIfYouOwn;

  const PoolInventoryView({
    super.key,
    required this.products,
    required this.checkIfYouOwn,
    required this.poolName,
  });

  @override
  Widget build(BuildContext context) {
    // Print the image ID if it's not null
    if (products.image != null && products.image!.id != null) {
      print('Product Image ID: ${products.image!.id}');
    }

    return InkWell(
      onTap: () => Navigator.pushNamed(
        context,
        productDetailsPage,
        arguments: [products, checkIfYouOwn, poolName],
      ),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
          side: const BorderSide(
              color: Color(0xFFFF6F00), width: 2), // Saffron border
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: products.image != null &&
                              products.image!.id != null
                          ? NetworkImage(
                              'http://192.168.1.84:8081/api/images/${products.image!.id}')
                          : const NetworkImage(
                              'http://192.168.1.84:8081/api/images/19'),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                products.productName ?? "Default name",
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                products.productQuality ?? "Default quality",
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
              Text(
                products.productPrice != null
                    ? "\$${products.productPrice!.toStringAsFixed(2)}"
                    : "N/A",
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFF6F00)), // Saffron color
              ),
              Text(
                "Seller",
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
