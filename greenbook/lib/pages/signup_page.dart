import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:greenbook/dataSource/AppDataSource.dart';
import 'package:greenbook/dataSource/yoyo_data_source.dart';
import 'package:greenbook/models/UserProfile.dart';
import 'package:greenbook/models/response_model.dart';
import 'package:greenbook/models/seller.dart';
import 'package:greenbook/utils/Services/MediaService.dart';
import 'package:greenbook/utils/Services/auth_services.dart';
import 'package:greenbook/utils/Services/database_service.dart';
import 'package:greenbook/utils/Services/storage_service.dart';
import 'package:greenbook/utils/constants.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final GetIt _getIt = GetIt.instance;
  File? selectedImage;
  final _formKey = GlobalKey<FormState>();
  String? _email, _username, _password, _confirmPassword;
  bool _isButtonEnabled = true;
  bool isLoading = false;

  late MediaService _mediaService;
  late AuthService _authService;
  late StorageService _storageService;
  late DatabaseService _databaseService;

  @override
  void initState() {
    super.initState();
    _mediaService = _getIt.get<MediaService>();
    _authService = _getIt.get<AuthService>();
    _storageService = _getIt.get<StorageService>();
    _databaseService = _getIt.get<DatabaseService>();
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

  bool _isPasswordStrong(String password) {
    return password.length >= 8 &&
        RegExp(r'[A-Z]').hasMatch(password) &&
        RegExp(r'[a-z]').hasMatch(password) &&
        RegExp(r'[0-9]').hasMatch(password) &&
        RegExp(r'[!@#\$&*~]').hasMatch(password);
  }

  Future<void> _handleSignUp() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      _disableButton();
      setState(() {
        isLoading = true;
      });

      DummyDataSource dataSource = DummyDataSource();

      try {
        bool result = await _authService.signUp(_email!, _password!);

        if (result) {
          //  String? _imagepath = await _storageService.uploadUserpfp(
          //    file: selectedImage!, uid: _authService.user!.uid);
          await _databaseService.createUserProfile(
            userProfile: UserProfile(
              uid: _authService.user!.uid,
              name: _username,
              pfpURL: null,
            ),
          );
          Seller seller = new Seller(
              sellerName: _username.toString(),
              sellerEmail: _email.toString(),
              sellerId: _authService.user!.uid);
          ResponseModel response = await dataSource.addUser(seller);

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('User Created')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Sign up failed. Please try again.')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An error occurred: $e')),
        );
      } finally {
        setState(() {
          isLoading = false;
        });
        _enableButton();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Let\'s Get Started',
          style: GoogleFonts.roboto(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF4CAF50), // Green color
          ),
        ),
        backgroundColor: const Color(0xFFFFE082), // Creamy white color
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : _signUpPart(),
    );
  }

  Widget _signUpPart() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _pfpSelectionField(),
            const Padding(
              padding: EdgeInsets.all(10),
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Email',
                labelStyle: TextStyle(color: const Color(0xFFFF6F00)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onSaved: (value) {
                _email = value;
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                  return 'Please enter a valid email';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Username',
                labelStyle: TextStyle(color: const Color(0xFFFF6F00)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onSaved: (value) {
                _username = value;
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your username';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Password',
                labelStyle: TextStyle(color: const Color(0xFFFF6F00)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              obscureText: true,
              onChanged: (value) {
                _password = value;
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                }
                if (!_isPasswordStrong(value)) {
                  return 'Password must be at least 8 characters long, contain an uppercase letter, a lowercase letter, a number, and a special character';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Confirm Password',
                labelStyle: TextStyle(color: const Color(0xFFFF6F00)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              obscureText: true,
              onChanged: (value) {
                _confirmPassword = value;
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please confirm your password';
                }
                if (value != _password) {
                  return 'Passwords do not match';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isButtonEnabled ? _handleSignUp : null,
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                backgroundColor: const Color(0xFFFF6F00), // Light saffron color
              ),
              child: Text(
                'Sign Up',
                style: GoogleFonts.roboto(fontSize: 16, color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, homePageName);
              },
              child: Text(
                'Already have an account? Login',
                style: GoogleFonts.roboto(
                    fontSize: 16,
                    color: const Color(0xFFFF6F00)), // Light saffron color
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _pfpSelectionField() {
    return GestureDetector(
      onTap: () async {
        File? file = await _mediaService.getImageFromGallery();
        if (file != null) {
          setState(() {
            selectedImage = file;
          });
        }
      },
      child: CircleAvatar(
        radius: MediaQuery.of(context).size.width * 0.15,
        backgroundImage: selectedImage != null
            ? FileImage(selectedImage!)
            : const NetworkImage('https://picsum.photos/250?image=9')
                as ImageProvider,
      ),
    );
  }
}
