class NaverTokens {
  final String accessToken;
  final String refreshToken;
  final DateTime expiresAt;
  final String tokenType;

  const NaverTokens({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresAt,
    required this.tokenType,
  });

  /// Returns true if token is expired or will expire within 5 minutes (buffer)
  bool get isExpired {
    final buffer = const Duration(minutes: 5);
    return DateTime.now().isAfter(expiresAt.subtract(buffer));
  }

  Map<String, dynamic> toJson() {
    return {
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'expiresAt': expiresAt.toIso8601String(),
      'tokenType': tokenType,
    };
  }

  factory NaverTokens.fromJson(Map<String, dynamic> json) {
    return NaverTokens(
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
      expiresAt: DateTime.parse(json['expiresAt'] as String),
      tokenType: json['tokenType'] as String,
    );
  }

  NaverTokens copyWith({
    String? accessToken,
    String? refreshToken,
    DateTime? expiresAt,
    String? tokenType,
  }) {
    return NaverTokens(
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      expiresAt: expiresAt ?? this.expiresAt,
      tokenType: tokenType ?? this.tokenType,
    );
  }
}
