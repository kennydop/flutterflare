import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutterflare/core/exceptions/app_exception.dart';
import 'package:flutterflare/features/auth/models/user_model.dart';
import 'package:flutterflare/features/auth/repositories/auth_repository.dart';
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
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final user = await ref
          .read(authRepositoryProvider)
          .createUserWithEmailAndPassword(email: email, password: password);
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
      state = state.copyWith(isLoading: false, user: null);
    } on AuthException catch (e) {
      state = state.copyWith(isLoading: false, error: e.message);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'An unexpected error occurred',
      );
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
        error: 'An unexpected error occurred',
      );
    }
  }
}
