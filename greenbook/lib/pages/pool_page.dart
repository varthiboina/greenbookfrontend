import 'package:flutter/material.dart';
import 'package:greenbook/models/profile.dart';
import 'package:greenbook/provider/app_data_provider.dart';
import 'package:greenbook/utils/constants.dart';
import 'package:provider/provider.dart';

class PoolPage extends StatefulWidget {
  const PoolPage({super.key});

  @override
  State<PoolPage> createState() => _PoolPageState();
}

class _PoolPageState extends State<PoolPage> {
  final _formKey = GlobalKey<FormState>();
  String _poolName = '';
  String _pin = '';
  bool _isButtonEnabled = true;

  void _enableButton() {
    setState(() {
      _isButtonEnabled = true;
    });
  }

  void _disableButton() {
    setState(() {
      _isButtonEnabled = false;
    });
    Future.delayed(const Duration(seconds: 4), _enableButton);
  }

  @override
  Widget build(BuildContext context) {
    final argList = ModalRoute.of(context)!.settings.arguments as List;
    final Profile profile = argList[0];

    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome, ${profile.profileName}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Pool Name',
                ),
                onSaved: (value) {
                  _poolName = value ?? '';
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the pool name';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Pin',
                ),
                keyboardType: TextInputType.number,
                onSaved: (value) {
                  _pin = value ?? '';
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the pin';
                  }
                  if (value.length != 4) {
                    return 'Pin must be 4 digits';
                  }
                  if (!RegExp(r'^\d+$').hasMatch(value)) {
                    return 'Pin must be numeric';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isButtonEnabled
                    ? () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          _disableButton();
                          Provider.of<AppDataProvider>(context, listen: false)
                              .getPool(_poolName, _pin)
                              .then((pool) {
                            if (pool != null) {
                              Navigator.pushNamed(
                                context,
                                poolInventoryName, // Ensure poolInventoryName is defined
                                arguments: [
                                  pool
                                ], // Pass the pool object or needed arguments
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Processing Data')),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Pool not found')),
                              );
                            }
                          });
                        }
                      }
                    : null,
                child: const Text('Enter'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
