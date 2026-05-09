class User {
  final int id;
  final String username;
  final String role; // admin, technicien
  final String? token;

  User({
    required this.id,
    required this.username,
    required this.role,
    this.token,
  });

  bool get isAdmin => role == 'admin';
  bool get isTechnicien => role == 'technicien';

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      role: json['role'],
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'username': username, 'role': role, 'token': token};
  }
}
