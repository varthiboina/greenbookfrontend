import 'package:flutter/material.dart';
import 'package:greenbook/models/pool.dart';
import 'package:greenbook/models/products.dart';
import 'package:greenbook/models/seller.dart';
import 'package:greenbook/provider/app_data_provider.dart';
import 'package:provider/provider.dart';

class PoolInventory extends StatefulWidget {
  const PoolInventory({super.key});

  @override
  State<PoolInventory> createState() => _PoolInventoryState();
}

class _PoolInventoryState extends State<PoolInventory> {
  @override
  Widget build(BuildContext context) {
    final argList = ModalRoute.of(context)!.settings.arguments as List;
    final Pool poolList = argList[0];
    final provider = Provider.of<AppDataProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pool Inventory'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          Center(child: Text('Items on ${poolList.poolName}')),
          Consumer<AppDataProvider>(
            builder: (context, value, _) => FutureBuilder<List<Products>>(
              future: provider.getPoolList(poolList.poolName),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final productList = snapshot.data!;
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 3 / 2,
                    ),
                    itemCount: productList.length,
                    itemBuilder: (context, index) {
                      final product = productList[index];
                      return PoolInventoryView(
                        seller: product.sellerData,
                        products: product,
                      );
                    },
                  );
                }
                if (snapshot.hasError) {
                  return const Text("Something went wrong");
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
          ),
        ],
      ),
    );
  }
}

class PoolInventoryView extends StatelessWidget {
  final Seller seller;
  final Products products;
  const PoolInventoryView({
    super.key,
    required this.seller,
    required this.products,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.pushNamed(
        context,
        '/productDetails', // Change this to your product details route
        arguments: [seller, products],
      ),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                title: Text(products.productName),
                subtitle: Text(products.productQuality),
                trailing: Text("\$${products.productPrice.toStringAsFixed(2)}"),
              ),
              Text(
                'Seller: ${seller.sellerName}',
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
