import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:greenbook/models/UserProfile.dart';
import 'package:greenbook/models/chat.dart';
import 'package:greenbook/models/message.dart';
import 'package:greenbook/utils/Services/auth_services.dart';
import 'package:greenbook/utils/utils.dart';

class DatabaseService {
  final GetIt _getIt = GetIt.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  CollectionReference<UserProfile>? _userCollection;
  CollectionReference<Chat>? _chatCollection;

  late AuthService authService;
  
  DatabaseService() {
    authService = _getIt.get<AuthService>();
    _setUpCollectionReference();
  }

  void _setUpCollectionReference() {
    _userCollection = _firebaseFirestore
        .collection('users')
        .withConverter<UserProfile>(
            fromFirestore: (snapshots, _) =>
                UserProfile.fromJson(snapshots.data()!),
            toFirestore: (userProfile, _) => userProfile.toJson());
    _chatCollection = _firebaseFirestore
        .collection("chats")
        .withConverter<Chat>(
            fromFirestore: (snapshots, _) => Chat.fromJson(snapshots.data()!),
            toFirestore: (chat, _) => chat.toJson());
  }

  Future<void> createUserProfile({required UserProfile userProfile}) async {
    try {
      await _userCollection?.doc(userProfile.uid).set(userProfile);
    } catch (e) {
      // Handle or log the error
      print('Error creating user profile: $e');
    }
  }

  Stream<QuerySnapshot<UserProfile>> userProfiles() {
    return _userCollection
        ?.where("uid", isNotEqualTo: authService.user!.uid)
        .snapshots() as Stream<QuerySnapshot<UserProfile>>;
  }

  Future<bool> checkChatIdExists(String uid1, String uid2) async {
    try {
      String chatId = generateChatId(uid1: uid1, uid2: uid2);
      final result = await _chatCollection?.doc(chatId).get();
      return result?.exists ?? false;
    } catch (e) {
      // Handle or log the error
      print('Error checking chat ID existence: $e');
      return false;
    }
  }

  Future<void> createNewChat(String uid1, String uid2) async {
    try {
      String chatId = generateChatId(uid1: uid1, uid2: uid2);
      final docRef = _chatCollection!.doc(chatId);
      final chat = Chat(id: chatId, participants: [uid1, uid2], messages: []);
      await docRef.set(chat);
    } catch (e) {
      // Handle or log the error
      print('Error creating new chat: $e');
    }
  }

  Future<void> sendChatMessage(
    String uid1,
    String uid2,
    Message message,
  ) async {
    if (message.content == null || message.content!.isEmpty) {
      // Handle the error or provide a default message
      return;
    }

    try {
      String chatId = generateChatId(uid1: uid1, uid2: uid2);
      final docRef = _chatCollection!.doc(chatId);
      await docRef.update({
        "messages": FieldValue.arrayUnion([message.toJson()]),
      });
    } catch (e) {
      // Handle or log the error
      print('Error sending chat message: $e');
    }
  }

  Stream<DocumentSnapshot<Chat>> getChatData(String uid1, String uid2) {
    try {
      String chatId = generateChatId(uid1: uid1, uid2: uid2);
      return _chatCollection?.doc(chatId).snapshots()
          as Stream<DocumentSnapshot<Chat>>;
    } catch (e) {
      // Handle or log the error
      print('Error getting chat data: $e');
      // Return an empty stream or handle appropriately
      return Stream.empty();
    }
  }

  Future<UserProfile?> getUserProfileByUid(String uid) async {
    try {
      final docSnapshot = await _userCollection?.doc(uid).get();
      return docSnapshot?.data();
    } catch (e) {
      // Handle or log the error
      print('Error getting user profile by UID: $e');
      return null;
    }
  }
}
