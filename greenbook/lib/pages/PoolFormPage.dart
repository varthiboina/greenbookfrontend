import 'package:flutter/material.dart';
import 'package:greenbook/dataSource/AppDataSource.dart';
import 'package:greenbook/dataSource/yoyo_data_source.dart';
import 'package:greenbook/models/pool.dart';
import 'package:greenbook/models/products.dart';
import 'package:greenbook/dataSource/data_source.dart';
import 'package:greenbook/models/response_model.dart';
import 'package:greenbook/provider/app_data_provider.dart';
import 'package:provider/provider.dart';

class PoolFormPage extends StatefulWidget {
  @override
  _PoolFormPageState createState() => _PoolFormPageState();
}

class _PoolFormPageState extends State<PoolFormPage> {
  final _formKey = GlobalKey<FormState>();
  String poolName = '';
  String poolPin = '';
  String poolDescription = '';

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      Pool newPool = Pool(
        poolName: poolName,
        poolPin: poolPin,
        poolDescription: poolDescription,
        sellersList: [], // If you want to add sellers later, start with an empty list
      );

      // Send the Pool object to the backend
       final dataSource = Provider.of<AppDataProvider>(
                                    context,
                                    listen: false);
      ResponseModel response = await dataSource.addPool(newPool);

      if (response.statusCode == 200) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Pool created successfully!'),
          backgroundColor: Colors.green,
        ));
        // Optionally, navigate back or clear the form
        Navigator.pop(context);
      } else {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to create pool: ${response.message}'),
          backgroundColor: Colors.red,
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create a Pool'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Pool Name'),
                onSaved: (value) => poolName = value!,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a pool name';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Pool Pin'),
                onSaved: (value) => poolPin = value!,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a pool pin';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Pool Description'),
                onSaved: (value) => poolDescription = value!,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a pool description';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Create Pool'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
