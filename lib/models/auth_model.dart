class Auth {
  final String token;
  final String refreshToken;
  final int expiresIn;

  const Auth({
    required this.token,
    required this.refreshToken,
    required this.expiresIn,
  });

  factory Auth.fromJson(Map<String, dynamic> json) {
    return Auth(
      token: json['token'],
      refreshToken: json['refreshToken'],
      expiresIn: json['expiredAt'],
    );
  }

  toJson() {
    return {
      'token': token,
      'refreshToken': refreshToken,
      'expiredAt': expiresIn,
    };
  }
}
