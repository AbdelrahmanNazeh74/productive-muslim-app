import 'package:equatable/equatable.dart';

class AuthUser extends Equatable {
  final String id;
  final String email;
  final String? displayName;
  final String? photoUrl;
  final bool isAnonymous;

  const AuthUser({
    required this.id,
    required this.email,
    this.displayName,
    this.photoUrl,
    this.isAnonymous = false,
  });

  AuthUser copyWith({
    String? id,
    String? email,
    String? displayName,
    String? photoUrl,
    bool? isAnonymous,
  }) {
    return AuthUser(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      isAnonymous: isAnonymous ?? this.isAnonymous,
    );
  }

  @override
  List<Object?> get props => [id, email, displayName, photoUrl, isAnonymous];
}
