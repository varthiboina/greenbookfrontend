import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:greenbook/provider/app_data_provider.dart';
import 'package:greenbook/utils/constants.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Select Pool',
          style: GoogleFonts.roboto(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF4CAF50), // Green color
          ),
        ),
        backgroundColor: const Color(0xFFFFE082), // Creamy white color
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Enter Pool Details',
                  style: GoogleFonts.roboto(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFFFF6F00), // Light saffron color
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Pool Name',
                    labelStyle: TextStyle(color: const Color(0xFFFF6F00)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
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
                const SizedBox(height: 16),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Pin',
                    labelStyle: TextStyle(color: const Color(0xFFFF6F00)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
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
                                  poolInventoryName,
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
                                  const SnackBar(
                                      content: Text('Pool not found')),
                                );
                              }
                            });
                          }
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    backgroundColor:
                        const Color(0xFFFF6F00), // Light saffron color
                  ),
                  child: Text(
                    'Enter',
                    style:
                        GoogleFonts.roboto(fontSize: 16, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
