import 'package:flutter/material.dart';
import 'package:greenbook/models/products.dart';
import 'package:greenbook/pages/chat_list.dart';
import 'package:greenbook/pages/chat_page.dart';

class ProductDetailsPage extends StatefulWidget {
  const ProductDetailsPage({super.key});

  @override
  _ProductDetailsPageState createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  late Products product;
  late int checkIfYouOwn;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)!.settings.arguments as List;
    product = args[0] as Products; // Extract the product from arg[0]
    checkIfYouOwn = args[1] as int; // Extract checkIfYouOwn from arg[1]
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Product Image
            Container(
              width: 300, // Make the image square
              height: 300,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: product.image != null && product.image!.id != null
                      ? NetworkImage(
                          'http://192.168.1.84:8081/api/images/${product.image!.id}')
                      : const NetworkImage(
                          'http://192.168.1.84:8081/api/images/19'),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            // Product Details
            Text(
              product.productName ?? 'Product Name',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              "Quality: ${product.productQuality ?? 'Unknown'}",
              style: const TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              "\$${product.productPrice?.toStringAsFixed(2) ?? '0.00'}",
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFF6F00), // Saffron color
              ),
            ),
            const SizedBox(height: 16.0),
            Text(
              product.productDescription ?? 'No description available.',
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16.0),
            // Conditionally show "Chat with Seller" button
            if (checkIfYouOwn == 0) ...[
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    print(product.sellerId!);
                    accessChatWithProfile(context, product.sellerId!);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF6F00), // Saffron color
                  ),
                  child: const Text('Chat with Seller'),
                ),
              ),
              const SizedBox(height: 16.0),
            ],
          ],
        ),
      ),
    );
  }
}
