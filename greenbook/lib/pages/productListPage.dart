import 'package:flutter/material.dart';
import 'package:greenbook/models/products.dart';
import 'package:greenbook/utils/constants.dart';

class ProductListPage extends StatefulWidget {
  final image = const NetworkImage('https://picsum.photos/250?image=9');
  @override
  _ProductListPageState createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  late Future<List<Products>> products;

  @override
  void initState() {
    super.initState();
    // products = ProductService().fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Products'),
      ),
      body: FutureBuilder<List<Products>>(
        future: products,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No products available'));
          } else {
            return ListView(
              children: [
                ...snapshot.data!
                    .map((product) => InkWell(
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.pushNamed(context, homePageName);
                          },
                          child: Card(
                            margin: EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Image.network(
                                    'https://picsum.photos/250?image=9',
                                    height: 150,
                                    fit: BoxFit.cover),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'productname',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Text('decription'),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text('20',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                          ),
                        ))
                    .toList(),
                InkWell(
                  onTap: () {
                    // Handle add product tap
                    Navigator.pushNamed(
                      context,
                      homePageName,
                    );
                  },
                  child: Card(
                    margin: EdgeInsets.all(8.0),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Icon(Icons.add, size: 50),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
