import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:greenbook/drawer/main_drawer.dart';
import 'package:greenbook/provider/app_data_provider.dart';
import 'package:greenbook/utils/Services/auth_services.dart';
import 'package:greenbook/utils/constants.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GetIt _getIt = GetIt.instance;
  String? username, password;
  final _formKey = GlobalKey<FormState>();

  bool _isButtonEnabled = true;

  late AuthService _authService;
  void initState() {
    super.initState();
    _authService = _getIt.get<AuthService>();
  }

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
      drawer: const MainDrawer(),
      appBar: AppBar(
        title: const Text('Login Page'),
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
                  labelText: "User Name",
                  hintText: "User Name",
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
                  labelText: "Password",
                  hintText: "Password",
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
                    ? () async {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          _disableButton();
                          bool result =
                              await _authService.login(username!, password!);
                          Provider.of<AppDataProvider>(context, listen: false)
                              .getLogin(username!)
                              .then((user) {
                            if (result) {
                              Navigator.pushNamed(context, poolPageName,
                                  arguments: [
                                    user,
                                  ]);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Incorrect Credentials '),
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
