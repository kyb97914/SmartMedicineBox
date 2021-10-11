class UserProfile {
  final String userId;
  final String userNm;
  final String birth;
  final String contact;

  UserProfile({this.userId, this.userNm, this.birth, this.contact});

  factory UserProfile.fromJson(Map<String, dynamic> parsedJson) {
    return UserProfile(
      userId: parsedJson['userId'],
      userNm: parsedJson['userNm'],
      birth: parsedJson['birth'],
      contact: parsedJson['contact'],
    );
  }
  Map<String, dynamic> toJson() => {
        "userId": userId,
        "token": userNm,
        "birth": birth,
        "contact": contact,
      };
}
