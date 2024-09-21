import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:greenbook/pages/chat_list.dart';
import 'package:greenbook/pages/chat_page.dart';
import 'package:greenbook/pages/login_page.dart';
import 'package:greenbook/provider/app_data_provider.dart';
import 'package:greenbook/utils/Services/auth_services.dart';
import 'package:greenbook/utils/constants.dart';
import 'package:provider/provider.dart';

class HomePageDrawer extends StatelessWidget {
  HomePageDrawer({super.key});
  final AuthService _authService = GetIt.instance<AuthService>();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Color(0xFFFFE082), // Creamy white color
            ),
            child: Text(
              'Menu',
              style: TextStyle(
                color: Colors.black,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.storage),
            title: Text('Pools'),
            onTap: () {
              Navigator.pushNamed(context, poolPageName);
            },
          ),
          ListTile(
            leading: Icon(Icons.chat),
            title: Text('Chat'),
            onTap: () {
              Navigator.pushNamed(context, chatPageName);
            },
          ),
          ListTile(
            leading: Icon(Icons.shopping_basket),
            title: Text('Your Products'),
            onTap: () async {
              int checkIfYouOwn = 1;
              print(_authService.user!.uid);
              final dataSource =
                  Provider.of<AppDataProvider>(context, listen: false);
              final products = await dataSource
                  .getProductsBySellerId(_authService.user!.uid);
              Navigator.pushNamed(context, poolInventoryName,
                  arguments: [products, checkIfYouOwn, "None"]);
            },
          ),
          ListTile(
            leading: Icon(Icons.support_agent),
            title: Text('Support Line'),
            onTap: () {
              //   accessChatWithProfile(context, 'Y3BRI21n1oPkx0GW0pcku2hLmNV2');
              //   Navigator.pushNamed(contextspecific-uid-here, supportPageName);
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: () async {
              bool result = await _authService.logout();
              if (result) {
                Navigator.pop(context);
                Navigator.pushNamed(context, homePageName);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Logged Out'),
                    duration: Duration(seconds: 2),
                  ),
                );
              } else {}
            },
          ),
        ],
      ),
    );
  }
}
