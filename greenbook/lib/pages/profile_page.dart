import 'package:flutter/material.dart';
import 'package:greenbook/drawer/home_page_drawer.dart';
import 'package:greenbook/drawer/main_drawer.dart'; // Import the drawer

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: HomePageDrawer(),
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: Center(
        child: Text(
          'Welcome',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
}
