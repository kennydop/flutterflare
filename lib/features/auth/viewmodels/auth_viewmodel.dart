import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutterflare/core/exceptions/app_exception.dart';
import 'package:flutterflare/features/auth/models/user_model.dart';
import 'package:flutterflare/features/auth/repositories/auth_repository.dart';
import 'package:flutterflare/features/auth/repositories/user_repository.dart';
import 'package:flutterflare/core/services/notification/toast_service.dart';

part 'auth_viewmodel.g.dart';

@riverpod
Stream<UserModel?> authState(AuthStateRef ref) {
  return ref.watch(authRepositoryProvider).authStateChanges();
}

// For handling auth errors in a centralized way
final authErrorHandlerProvider = Provider<void>((ref) {
  ref.listen<AuthState>(authProvider, (previous, next) {
    if (next.error != null && (previous?.error != next.error)) {
      Toast.showError(next.error!);
    }
  });
});

class AuthState {
  final bool isLoading;
  final String? error;
  final UserModel? user;

  const AuthState({this.isLoading = false, this.error, this.user});

  AuthState copyWith({bool? isLoading, String? error, UserModel? user}) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      user: user ?? this.user,
    );
  }
}

@riverpod
class Auth extends _$Auth {
  @override
  AuthState build() => const AuthState();

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final user = await ref
          .read(authRepositoryProvider)
          .signInWithEmailAndPassword(email: email, password: password);
      state = state.copyWith(isLoading: false, user: user);
    } on AuthException catch (e) {
      state = state.copyWith(isLoading: false, error: e.message);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'An unexpected error occurred',
      );
    }
  }

  Future<void> createUserWithEmailAndPassword({
    required String email,
    required String password,
    String? firstName,
    String? lastName,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final user = await ref
          .read(authRepositoryProvider)
          .createUserWithEmailAndPassword(
            email: email,
            password: password,
            firstName: firstName,
            lastName: lastName,
          );
      state = state.copyWith(isLoading: false, user: user);
    } on AuthException catch (e) {
      state = state.copyWith(isLoading: false, error: e.message);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'An unexpected error occurred',
      );
    }
  }

  // Add method to update user profile
  Future<void> updateUserProfile({
    String? firstName,
    String? lastName,
    String? photoURL,
    String? bio,
    String? phoneNumber,
  }) async {
    if (state.user == null) {
      state = state.copyWith(error: 'No user is logged in');
      return;
    }

    state = state.copyWith(isLoading: true, error: null);
    try {
      final userRepository = ref.read(userRepositoryProvider);
      final updatedData = <String, dynamic>{
        'updatedAt': DateTime.now().toIso8601String(),
      };

      if (firstName != null) updatedData['firstName'] = firstName;
      if (lastName != null) updatedData['lastName'] = lastName;
      if (photoURL != null) updatedData['photoURL'] = photoURL;
      if (bio != null) updatedData['bio'] = bio;
      if (phoneNumber != null) updatedData['phoneNumber'] = phoneNumber;

      await userRepository.updateUser(state.user!.uid, updatedData);

      // Fetch the updated user data
      final updatedUser = await userRepository.getUser(state.user!.uid);
      if (updatedUser != null) {
        state = state.copyWith(isLoading: false, user: updatedUser);
      } else {
        state = state.copyWith(isLoading: false);
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to update profile',
      );
    }
  }

  Future<void> signInWithGoogle() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final user = await ref.read(authRepositoryProvider).signInWithGoogle();
      // If user is null, the sign-in was canceled
      if (user == null) {
        state = state.copyWith(isLoading: false);
        return;
      }
      state = state.copyWith(isLoading: false, user: user);
    } on AuthException catch (e) {
      state = state.copyWith(isLoading: false, error: e.message);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'Google sign in failed');
    }
  }

  Future<void> signOut() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await ref.read(authRepositoryProvider).signOut();
      state = const AuthState();
    } on AuthException catch (e) {
      state = state.copyWith(isLoading: false, error: e.message);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'Failed to sign out');
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await ref.read(authRepositoryProvider).sendPasswordResetEmail(email);
      state = state.copyWith(isLoading: false);
    } on AuthException catch (e) {
      state = state.copyWith(isLoading: false, error: e.message);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to send password reset email',
      );
    }
  }
}
