enum UserRole { student, landlord }

class User {
  final String id;
  final String name;
  final String? username;
  final String email;
  final UserRole role;

  const User({
    required this.id,
    required this.name,
    this.username,
    required this.email,
    required this.role,
  });

  String get displayName =>
      (role == UserRole.student && username != null && username!.isNotEmpty)
      ? username!
      : name;

  User copyWith({
    String? id,
    String? name,
    String? username,
    String? email,
    UserRole? role,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      username: username ?? this.username,
      email: email ?? this.email,
      role: role ?? this.role,
    );
  }
}
