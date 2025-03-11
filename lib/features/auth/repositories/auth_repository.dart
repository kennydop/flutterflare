import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutterflare/core/constants/app_strings.dart';
import 'package:flutterflare/core/logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutterflare/core/exceptions/app_exception.dart';
import 'package:flutterflare/features/auth/models/user_model.dart';
import 'package:flutterflare/features/auth/repositories/user_repository.dart';
import 'package:google_sign_in/google_sign_in.dart';

part 'auth_repository.g.dart';

@Riverpod(keepAlive: true)
FirebaseAuth firebaseAuth(FirebaseAuthRef ref) {
  return FirebaseAuth.instance;
}

class AuthRepository {
  final FirebaseAuth _auth;
  final UserRepository _userRepository;

  AuthRepository({FirebaseAuth? auth, UserRepository? userRepository})
    : _auth = auth ?? FirebaseAuth.instance,
      _userRepository = userRepository ?? UserRepository();

  Stream<UserModel?> authStateChanges() {
    return _auth.authStateChanges().asyncMap((user) async {
      if (user == null) return null;

      // Fetch the user data from Firestore
      try {
        final firestoreUser = await _userRepository.getUser(user.uid);
        if (firestoreUser != null) {
          return firestoreUser;
        }

        // If user doesn't exist in Firestore, create a basic record
        final authUser = UserModel.fromFirebaseUser(user);
        await _userRepository.saveUser(authUser);
        return authUser;
      } catch (e) {
        logger.e('Error fetching user data: $e');
        // Return basic user info from Firebase Auth if Firestore fetch fails
        return UserModel.fromFirebaseUser(user);
      }
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

      // Fetch user data from Firestore
      final user = userCredential.user!;
      final firestoreUser = await _userRepository.getUser(user.uid);

      if (firestoreUser != null) {
        // Update the last login time and isOnline status
        await _userRepository.updateUser(user.uid, {
          'lastLoginAt': DateTime.now().toIso8601String(),
          'isOnline': true,
        });
        return firestoreUser;
      }

      // If user doesn't exist in Firestore (rare case), create one
      final authUser = UserModel.fromFirebaseUser(user);
      await _userRepository.saveUser(authUser);
      return authUser;
    } on FirebaseAuthException catch (e) {
      throw AuthException(_getErrorMessage(e.code));
    } catch (e) {
      throw AuthException(AppStrings.unexpectedErrorOccurred);
    }
  }

  Future<UserModel> createUserWithEmailAndPassword({
    required String email,
    required String password,
    String? firstName,
    String? lastName,
  }) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user == null) {
        throw AuthException(AppStrings.registrationFailed);
      }

      // Try to update the display name if first name is provided
      if (firstName != null || lastName != null) {
        final displayName = '${firstName ?? ''} ${lastName ?? ''}'.trim();
        if (displayName.isNotEmpty) {
          await userCredential.user!.updateDisplayName(displayName);
        }
      }

      // Create a user model from Firebase user
      UserModel userModel = UserModel.fromFirebaseUser(userCredential.user!);

      // If firstName and lastName are not available from Firebase,
      // but were provided directly to this method, use those values
      if (firstName != null || lastName != null) {
        userModel = userModel.copyWith(
          firstName: firstName ?? userModel.firstName,
          lastName: lastName ?? userModel.lastName,
        );
      }

      // Save the user data to Firestore
      await _userRepository.saveUser(userModel);

      return userModel;
    } on FirebaseAuthException catch (e) {
      logger.e('Error creating user with email and password: $e');
      throw AuthException(_getErrorMessage(e.code));
    } catch (e) {
      logger.e('Error creating user with email and password: $e');
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

      // Check if user exists in Firestore
      final user = userCredential.user!;
      final firestoreUser = await _userRepository.getUser(user.uid);

      if (firestoreUser != null) {
        // Update the last login time and isOnline status
        await _userRepository.updateUser(user.uid, {
          'lastLoginAt': DateTime.now().toIso8601String(),
          'isOnline': true,
        });
        return firestoreUser;
      }

      // If user doesn't exist in Firestore, create one
      final userModel = UserModel.fromFirebaseUser(user);
      await _userRepository.saveUser(userModel);
      return userModel;
    } on FirebaseAuthException catch (e) {
      logger.e('Error signing in with Google: $e');
      throw AuthException(_getErrorMessage(e.code));
    } catch (e) {
      logger.e('Error signing in with Google: $e');
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
      // Update isOnline status to false before signing out
      final currentUser = _auth.currentUser;
      if (currentUser != null) {
        await _userRepository.updateUser(currentUser.uid, {
          'isOnline': false,
          'lastLoginAt': DateTime.now().toIso8601String(),
        });
      }

      await _auth.signOut();
    } catch (e) {
      logger.e('Error signing out: $e');
      throw AuthException(AppStrings.signOutFailed);
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      logger.e('Error sending password reset email: $e');
      throw AuthException(_getErrorMessage(e.code));
    } catch (e) {
      logger.e('Error sending password reset email: $e');
      throw AuthException(AppStrings.failedToSendPasswordResetEmail);
    }
  }

  String _getErrorMessage(String code) {
    logger.e('Error code: $code');
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
  final userRepository = ref.watch(userRepositoryProvider);
  return AuthRepository(auth: auth, userRepository: userRepository);
}
