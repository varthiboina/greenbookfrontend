import 'package:flutter/material.dart';
import 'package:greenbook/utils/constants.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          Container(
            height: 200,
            color: Colors.grey,
          ),
          ListTile(
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, adminLoginName);
            },
            leading: const Icon(Icons.login_outlined),
            title: const Text('Admin Login'),
          ),
          ListTile(
            onTap: () {
              // Add functionality here
            },
            leading: const Icon(Icons.star),
            title: const Text('Get Premium'),
          ),
        ],
      ),
    );
  }
}
