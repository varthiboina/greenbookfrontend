import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:greenbook/provider/app_data_provider.dart';
import 'package:greenbook/utils/Services/auth_services.dart';
import 'package:greenbook/utils/Services/database_service.dart';
import 'package:greenbook/utils/constants.dart';
import 'package:provider/provider.dart';
import 'package:greenbook/models/products.dart';
import 'package:greenbook/models/ImageData.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path/path.dart' as path;

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _formKey = GlobalKey<FormState>();
  String? _sellerId;
  String? _productName;
  String? _productDescription;
  String? _productQuality;
  double? _productPrice;
  String? _poolName;
  File? _image;
  final GetIt _getIt = GetIt.instance;
  late AuthService _authService;
  late DatabaseService _databaseService;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final argList = ModalRoute.of(context)!.settings.arguments as List;
    _poolName = argList[2];
  }

  @override
  void initState() {
    super.initState();
    _authService = _getIt.get<AuthService>();
    _databaseService = _getIt.get<DatabaseService>();
  }

  final picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        final product = Products(
          sellerId: _authService.user?.uid ?? "", // Ensure sellerId is not null
          productName:
              _productName ?? "Unnamed Product", // Provide a default name
          poolName: _poolName ?? "Unknown Pool", // Provide a default pool name
          productDescription: _productDescription ?? "No description provided",
          productQuality: _productQuality ?? "No quality information",
          productPrice: _productPrice ?? 0.0, // Provide a default price
          image: _image != null
              ? ImageData(
                  name: path.basename(_image!.path), // Extracting the file name
                  type: 'image/jpg', // Set the MIME type
                  url: _image!.path, // Set the path of the image file
                )
              : null,
        );

        final provider = Provider.of<AppDataProvider>(context, listen: false);
        final response = await provider.addProduct(product);

        if (response.responseStatus == ResponseStatus.SUCCESS) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Product added successfully')),
          );
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content:
                    Text('Failed to add the product: ${response.message}')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Product Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a product name';
                  }
                  return null;
                },
                onSaved: (value) {
                  _productName = value;
                },
              ),
              TextFormField(
                decoration:
                    const InputDecoration(labelText: 'Product Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a product description';
                  }
                  return null;
                },
                onSaved: (value) {
                  _productDescription = value;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Product Quality'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter product quality';
                  }
                  return null;
                },
                onSaved: (value) {
                  _productQuality = value;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Product Price'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a product price';
                  }
                  return null;
                },
                onSaved: (value) {
                  _productPrice = double.tryParse(value!);
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  _image == null
                      ? const Text('No image selected.')
                      : Image.file(
                          _image!,
                          height: 100,
                          width: 100,
                        ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: _pickImage,
                    child: const Text('Pick Image'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
