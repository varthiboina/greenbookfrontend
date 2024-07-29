import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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

  @override
  void initState() {
    super.initState();
    _authService = _getIt.get<AuthService>();
  }

  void _enableButton() {
    setState(() {
      _isButtonEnabled = true;
    });
  }

  Future<bool> logout() async {
    bool result = await _authService.logout();
    return result;
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
        backgroundColor: Color.fromARGB(255, 227, 213, 106), // creamy white
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Yard',
                      style: GoogleFonts.roboto(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF4CAF50), // green color
                      ),
                    ),
                    TextSpan(
                      text: 'Sail',
                      style: GoogleFonts.roboto(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFFFF6F00), // light saffron color
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  labelText: "User Name",
                  hintText: "User Name",
                  border: OutlineInputBorder(),
                  labelStyle: TextStyle(
                      color: const Color(0xFFFF6F00)), // light saffron
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
                decoration: InputDecoration(
                  labelText: "Password",
                  hintText: "Password",
                  border: OutlineInputBorder(),
                  labelStyle: TextStyle(
                      color: const Color(0xFFFF6F00)), // light saffron
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
                              Navigator.pushNamed(context, profilePageName,
                                  arguments: [user]);
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
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  backgroundColor: const Color(0xFFFF6F00), // light saffron
                ),
                child: Text(
                  'Login',
                  style: GoogleFonts.roboto(fontSize: 16, color: Colors.white),
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  // Handle navigation to sign-up page
                },
                child: Text(
                  'Are you new? Sign up',
                  style: GoogleFonts.roboto(
                      fontSize: 16,
                      color: const Color(0xFFFF6F00)), // light saffron
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
