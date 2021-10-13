class Hub {
  final int hubId;
  final String hubNm;

  Hub({this.hubId, this.hubNm});

  factory Hub.fromJson(Map<String, dynamic> parsedJson) {
    return Hub(
      hubId: parsedJson['hubId'],
      hubNm: parsedJson['hubNm'],
    );
  }

  Map<String, dynamic> toJson() => {
        "hubId": hubId,
        "hubNm": hubNm,
      };
}
