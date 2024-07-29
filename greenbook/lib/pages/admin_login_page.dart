import 'package:flutter/material.dart';
import 'package:greenbook/provider/app_data_provider.dart';
import 'package:greenbook/utils/constants.dart';
import 'package:provider/provider.dart';

class AdminLoginPage extends StatefulWidget {
  const AdminLoginPage({super.key});

  @override
  State<AdminLoginPage> createState() => _AdminLoginPageState();
}

class _AdminLoginPageState extends State<AdminLoginPage> {
  String? username, password;
  final _formKey = GlobalKey<FormState>();
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
        title: const Text('Admin Login Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "Admin Username",
                  hintText: "Admin Username",
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your username';
                  }
                  return null;
                },
                onSaved: (value) {
                  username = value;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "Admin Password",
                  hintText: "Admin Password",
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
                onSaved: (value) {
                  password = value;
                },
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _isButtonEnabled
                    ? () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          _disableButton();
                          Provider.of<AppDataProvider>(context, listen: false)
                              .getLogin(username!)
                              .then((user) {
                            if (user != null && user.password == password) {
                              Navigator.pushNamed(context, adminDashboard,
                                  arguments: [user]);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Incorrect Credentials'),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            }
                          });
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please fill in all fields.'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        }
                      }
                    : null,
                child: const Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
