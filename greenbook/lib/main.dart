import 'package:flutter/material.dart';
import 'package:greenbook/pages/admin_dashboard.dart';
import 'package:greenbook/pages/admin_login_page.dart';
import 'package:greenbook/pages/login_page.dart';
import 'package:greenbook/pages/pool_inventory.dart';
import 'package:greenbook/pages/pool_page.dart';
import 'package:greenbook/provider/app_data_provider.dart';
import 'package:greenbook/utils/constants.dart';
import 'package:provider/provider.dart';
import 'package:greenbook/utils/utils.dart';

void main() async {
  await setUp();
  runApp(
    ChangeNotifierProvider(
      create: (context) => AppDataProvider(),
      child: const MyApp(),
    ),
  );
}

Future<void> setUp() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setUpFirebase();
  await registerService();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.lightGreen,
        brightness: Brightness.dark,
      ),
      home: const LoginPage(),
      routes: {
        homePageName: (context) => const LoginPage(),
        poolPageName: (context) => const PoolPage(),
        poolInventoryName: (context) => const PoolInventory(),
        adminLoginName: (context) => const AdminLoginPage(),
        adminDashboard: (context) => const AdminDashboard(),
      },
    );
  }
}
