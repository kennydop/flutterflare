import 'package:firebase_auth/firebase_auth.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
abstract class UserModel with _$UserModel {
  const factory UserModel({
    required String uid,
    required String email,
    String? firstName,
    String? lastName,
    String? photoURL,
    @Default(false) bool emailVerified,
    String? phoneNumber,
    String? bio,
    @Default([]) List<String> roles,
    Map<String, dynamic>? preferences,
    String? provider,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? lastLoginAt,
    @Default(false) bool isOnline,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  factory UserModel.fromFirebaseUser(User user) {
    final displayName = user.displayName;
    final nameParts = displayName?.split(' ');
    final firstName = nameParts?.isNotEmpty == true ? nameParts?.first : null;
    // combine the rest of the parts as last name
    final lastName =
        (nameParts?.length ?? 0) > 1 ? nameParts?.skip(1).join(' ') : null;

    // Get auth provider
    String? provider;
    if (user.providerData.isNotEmpty) {
      switch (user.providerData[0].providerId) {
        case 'google.com':
          provider = 'google';
          break;
        case 'apple.com':
          provider = 'apple';
          break;
        case 'password':
          provider = 'email';
          break;
        default:
          provider = user.providerData[0].providerId;
      }
    }

    final now = DateTime.now();

    return UserModel(
      uid: user.uid,
      email: user.email ?? '',
      firstName: firstName,
      lastName: lastName,
      photoURL: user.photoURL,
      emailVerified: user.emailVerified,
      phoneNumber: user.phoneNumber,
      provider: provider,
      roles: const ['user'],
      createdAt: user.metadata.creationTime ?? now,
      updatedAt: now,
      lastLoginAt: now,
      isOnline: true,
    );
  }
}
