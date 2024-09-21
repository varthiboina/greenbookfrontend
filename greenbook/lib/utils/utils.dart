import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';
import 'package:greenbook/utils/Services/MediaService.dart';
import 'package:greenbook/utils/Services/auth_services.dart';
import 'package:greenbook/firebase_options.dart';
import 'package:greenbook/utils/Services/database_service.dart';
import 'package:greenbook/utils/Services/storage_service.dart';

Future<void> setUpFirebase() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}

Future<void> registerService() async {
  final GetIt getIt = GetIt.instance;
  getIt.registerSingleton<AuthService>(AuthService());
  getIt.registerSingleton<MediaService>(MediaService());
  getIt.registerSingleton<StorageService>(StorageService());
  getIt.registerSingleton<DatabaseService>(DatabaseService());
}

String generateChatId({required uid1, required uid2}) {
  List uids = [uid1, uid2];
  uids.sort();
  String chatId = uids.fold("", (id, uid) => "$id$uid");
  return chatId;
}
