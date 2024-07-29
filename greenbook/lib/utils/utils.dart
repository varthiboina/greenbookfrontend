import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';
import 'package:greenbook/utils/Services/auth_services.dart';
import 'package:greenbook/firebase_options.dart';

Future<void> setUpFirebase() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}

Future<void> registerService() async {
  final GetIt getIt = GetIt.instance;
  getIt.registerSingleton(AuthService());
}
