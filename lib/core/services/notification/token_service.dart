import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutterflare/core/logger/logger.dart';
import 'package:flutterflare/features/auth/repositories/user_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'token_service.g.dart';

// Provider for TokenService
@Riverpod(keepAlive: true)
TokenService tokenService(TokenServiceRef ref) {
  return TokenService();
}

// Service responsible for managing device tokens
class TokenService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Updates the FCM token in Firestore for the current user
  Future<void> updateToken(String? token) async {
    if (token == null || token.isEmpty) {
      logger.w('Token is null or empty, not updating');
      return;
    }

    final User? currentUser = _auth.currentUser;
    if (currentUser == null) {
      logger.w('No user is logged in, not updating token');
      return;
    }

    try {
      // Store the token in the user's document
      await _firestore
          .collection(UserRepository.collection)
          .doc(currentUser.uid)
          .update({
            'fcmTokens': FieldValue.arrayUnion([token]),
            'lastTokenUpdate': DateTime.now().toIso8601String(),
            'deviceInfo': _getDeviceInfo(),
          });

      logger.i('FCM token updated for user: ${currentUser.uid}');
    } catch (e) {
      logger.e('Failed to update FCM token: $e');
    }
  }

  // Removes a token from Firestore
  Future<void> removeToken(String? token) async {
    if (token == null || token.isEmpty) {
      logger.w('Token is null or empty, not removing');
      return;
    }

    final User? currentUser = _auth.currentUser;
    if (currentUser == null) {
      logger.w('No user is logged in, not removing token');
      return;
    }

    try {
      // Remove the token from the user's document
      await _firestore
          .collection(UserRepository.collection)
          .doc(currentUser.uid)
          .update({
            'fcmTokens': FieldValue.arrayRemove([token]),
            'lastTokenUpdate': DateTime.now().toIso8601String(),
          });

      logger.i('FCM token removed for user: ${currentUser.uid}');
    } catch (e) {
      logger.e('Failed to remove FCM token: $e');
    }
  }

  // Get basic device info for tracking tokens
  Map<String, dynamic> _getDeviceInfo() {
    return {
      'platform': defaultTargetPlatform.name,
      'isWeb': kIsWeb,
      'timestamp': DateTime.now().toIso8601String(),
    };
  }
}
