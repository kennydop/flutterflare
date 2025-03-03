import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutterflare/core/constants/app_strings.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutterflare/core/exceptions/app_exception.dart';
import 'package:flutterflare/features/auth/models/user_model.dart';
import 'package:google_sign_in/google_sign_in.dart';

part 'auth_repository.g.dart';

@Riverpod(keepAlive: true)
FirebaseAuth firebaseAuth(FirebaseAuthRef ref) {
  return FirebaseAuth.instance;
}

class AuthRepository {
  final FirebaseAuth _auth;

  AuthRepository({FirebaseAuth? auth}) : _auth = auth ?? FirebaseAuth.instance;

  Stream<UserModel?> authStateChanges() {
    return _auth.authStateChanges().map((user) {
      return user != null ? UserModel.fromFirebaseUser(user) : null;
    });
  }

  Future<UserModel> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user == null) {
        throw AuthException(AppStrings.signInFailed);
      }

      return UserModel.fromFirebaseUser(userCredential.user!);
    } on FirebaseAuthException catch (e) {
      throw AuthException(_getErrorMessage(e.code));
    } catch (e) {
      throw AuthException(AppStrings.unexpectedErrorOccurred);
    }
  }

  Future<UserModel> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user == null) {
        throw AuthException(AppStrings.registrationFailed);
      }

      return UserModel.fromFirebaseUser(userCredential.user!);
    } on FirebaseAuthException catch (e) {
      throw AuthException(_getErrorMessage(e.code));
    } catch (e) {
      throw AuthException(AppStrings.unexpectedErrorOccurred);
    }
  }

  Future<UserModel?> signInWithGoogle() async {
    try {
      // Trigger the Google sign-in flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        // User canceled the sign-in flow
        return null;
      }

      // Obtain the auth details from the Google sign-in
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new Firebase credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credential
      final userCredential = await _auth.signInWithCredential(credential);

      if (userCredential.user == null) {
        throw AuthException(AppStrings.googleSignInFailed);
      }

      return UserModel.fromFirebaseUser(userCredential.user!);
    } on FirebaseAuthException catch (e) {
      throw AuthException(_getErrorMessage(e.code));
    } catch (e) {
      debugPrint('Error: $e');
      throw AuthException(AppStrings.googleSignInFailed);
    }
  }

  Future<UserModel?> signInWithApple() async {
    // This requires the sign_in_with_apple package and additional setup
    // For this MVP version, we'll just throw an exception
    throw AuthException('Apple Sign In will be implemented in a future update');
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw AuthException(AppStrings.signOutFailed);
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw AuthException(_getErrorMessage(e.code));
    } catch (e) {
      throw AuthException(AppStrings.failedToSendPasswordResetEmail);
    }
  }

  String _getErrorMessage(String code) {
    debugPrint('Error code: $code');
    switch (code) {
      case 'user-not-found':
        return 'No user found with this email';
      case 'wrong-password':
        return 'Wrong password provided';
      case 'email-already-in-use':
        return 'Email is already registered';
      case 'invalid-email':
        return 'Invalid email address';
      case 'weak-password':
        return 'Password is too weak';
      case 'operation-not-allowed':
        return 'Operation not allowed';
      case 'user-disabled':
        return 'User has been disabled';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later';
      case 'account-exists-with-different-credential':
        return 'An account already exists with the same email address';
      case 'invalid-action-code':
        return 'The action code is invalid. Please try again';
      case 'invalid-credential':
        return 'The email or password you entered is incorrect';
      default:
        return 'An error occurred. Please try again';
    }
  }
}

@Riverpod(keepAlive: true)
AuthRepository authRepository(AuthRepositoryRef ref) {
  final auth = ref.watch(firebaseAuthProvider);
  return AuthRepository(auth: auth);
}
