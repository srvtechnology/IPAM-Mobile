class TokenModel {
  final String accessToken;
  final String refreshToken;
  final String? tokenType;
  final int? expiresIn;

  TokenModel({
    required this.accessToken,
    required this.refreshToken,
    this.tokenType,
    this.expiresIn,
  });

  factory TokenModel.fromJson(Map<String, dynamic> json) {
    final effectiveJson = json.containsKey('tokens') ? json['tokens'] : json;
    return TokenModel(
      accessToken: effectiveJson['accessToken'] ?? effectiveJson['access_token'] ?? effectiveJson['token'] ?? '',
      refreshToken: effectiveJson['refreshToken'] ?? effectiveJson['refresh_token'] ?? '',
      tokenType: effectiveJson['tokenType'] ?? effectiveJson['token_type'] ?? 'Bearer',
      expiresIn: effectiveJson['expiresIn'] ?? effectiveJson['expires_in'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'tokenType': tokenType,
      'expiresIn': expiresIn,
    };
  }
}
