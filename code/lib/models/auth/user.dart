class User {
  final String id;
  final String name;
  final String email;
  final String? profileImageUrl;

  const User({
    required this.id,
    required this.name,
    required this.email,
    this.profileImageUrl,
  });

  factory User.fromNaverAccount(Map<String, dynamic> data) {
    return User(
      id: data['id'] as String,
      name: (data['name'] ?? data['nickname']) as String,
      email: data['email'] as String,
      profileImageUrl: data['profile_image'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'profileImageUrl': profileImageUrl,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      profileImageUrl: json['profileImageUrl'] as String?,
    );
  }

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? profileImageUrl,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is User &&
        other.id == id &&
        other.name == name &&
        other.email == email &&
        other.profileImageUrl == profileImageUrl;
  }

  @override
  int get hashCode => Object.hash(id, name, email, profileImageUrl);
}
