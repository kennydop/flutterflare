import 'package:firebase_auth/firebase_auth.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required String uid,
    required String email,
    String? firstName,
    String? lastName,
    String? photoURL,
    @Default(false) bool emailVerified,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? lastLoginAt,
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
    return UserModel(
      uid: user.uid,
      email: user.email ?? '',
      firstName: firstName,
      lastName: lastName,
      photoURL: user.photoURL,
      emailVerified: user.emailVerified,
      updatedAt: user.metadata.lastSignInTime,
      createdAt: user.metadata.creationTime,
      lastLoginAt: user.metadata.lastSignInTime,
    );
  }
}
