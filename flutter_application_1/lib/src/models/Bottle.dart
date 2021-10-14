class Bottle {
  final int bottleId;
  final int hubId;
  final String bottleNm;

  Bottle({this.bottleId, this.hubId, this.bottleNm});

  factory Bottle.fromJson(Map<String, dynamic> parsedJson) {
    return Bottle(
      bottleId: parsedJson['bottleId'],
      hubId: parsedJson['hubId'],
      bottleNm: parsedJson['bottleNm'],
    );
  }

  Map<String, dynamic> toJson() => {
        "bottleId": bottleId,
        "hubId": hubId,
        "bottleNm": bottleNm,
      };
}
