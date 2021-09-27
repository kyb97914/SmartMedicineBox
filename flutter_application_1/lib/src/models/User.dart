class LocalUser {
  final String userId;
  final String token;

  LocalUser({this.userId, this.token});

  factory LocalUser.fromJson(Map<String, dynamic> parsedJson) {
    return LocalUser(
      userId: parsedJson['userId'],
      token: parsedJson['token'],
    );
  }
  Map<String, dynamic> toJson() => {
        "userId": userId,
        "token": token,
      };
}
