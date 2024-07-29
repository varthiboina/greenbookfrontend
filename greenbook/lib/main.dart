import 'package:flutter/material.dart';
import 'package:greenbook/pages/admin_dashboard.dart';
import 'package:greenbook/pages/admin_login_page.dart';
import 'package:greenbook/pages/login_page.dart';
import 'package:greenbook/pages/pool_inventory.dart';
import 'package:greenbook/pages/pool_page.dart';
import 'package:greenbook/pages/profile_page.dart';
import 'package:greenbook/provider/app_data_provider.dart';
import 'package:greenbook/utils/constants.dart';
import 'package:provider/provider.dart';
import 'package:greenbook/utils/utils.dart';
import 'package:google_fonts/google_fonts.dart';

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
      title: 'Greenbook',
      theme: ThemeData(
        primaryColor: Colors.white,
        scaffoldBackgroundColor: Color(0xFFFFF8E1), // light saffron color
        textTheme: GoogleFonts.robotoTextTheme(
          Theme.of(context).textTheme,
        ).apply(
          bodyColor: Colors.black,
          displayColor: Colors.black,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFFFFF8E1), // light saffron color
          iconTheme: IconThemeData(color: Colors.black),
          titleTextStyle: GoogleFonts.roboto(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.black,
            backgroundColor: Color(0xFFFFE082),
            textStyle: GoogleFonts.roboto(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      home: const LoginPage(),
      routes: {
        homePageName: (context) => const LoginPage(),
        poolPageName: (context) => const PoolPage(),
        poolInventoryName: (context) => const PoolInventory(),
        adminLoginName: (context) => const AdminLoginPage(),
        adminDashboard: (context) => const AdminDashboard(),
        profilePageName: (context) => const ProfilePage()
      },
    );
  }
}
