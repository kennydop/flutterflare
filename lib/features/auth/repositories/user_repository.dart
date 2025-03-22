import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterflare/features/auth/models/user_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutterflare/core/logger/logger.dart';

part 'user_repository.g.dart';

@Riverpod(keepAlive: true)
FirebaseFirestore firestore(FirestoreRef ref) {
  return FirebaseFirestore.instance;
}

class UserRepository {
  final FirebaseFirestore _firestore;
  static const String collection = 'users';

  UserRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  /// Save user data to Firestore
  Future<void> saveUser(UserModel user) async {
    try {
      await _firestore
          .collection(collection)
          .doc(user.uid)
          .set(user.toJson(), SetOptions(merge: true));
    } catch (e) {
      logger.e('Error saving user to Firestore: $e');
      rethrow;
    }
  }

  /// Get user data from Firestore by user ID
  Future<UserModel?> getUser(String uid) async {
    try {
      final docSnapshot =
          await _firestore.collection(collection).doc(uid).get();
      if (docSnapshot.exists && docSnapshot.data() != null) {
        return UserModel.fromJson(docSnapshot.data()!);
      }
      return null;
    } catch (e) {
      logger.e('Error getting user from Firestore: $e');
      rethrow;
    }
  }

  /// Stream user data changes from Firestore
  Stream<UserModel?> userStream(String uid) {
    return _firestore.collection(collection).doc(uid).snapshots().map((
      snapshot,
    ) {
      if (snapshot.exists && snapshot.data() != null) {
        return UserModel.fromJson(snapshot.data()!);
      }
      return null;
    });
  }

  /// Update user data in Firestore
  Future<void> updateUser(String uid, Map<String, dynamic> data) async {
    try {
      await _firestore.collection(collection).doc(uid).update(data);
    } catch (e) {
      logger.e('Error updating user in Firestore: $e');
      rethrow;
    }
  }
}

@Riverpod(keepAlive: true)
UserRepository userRepository(UserRepositoryRef ref) {
  final firestore = ref.watch(firestoreProvider);
  return UserRepository(firestore: firestore);
}
