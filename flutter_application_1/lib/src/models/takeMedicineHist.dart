class TakeMedicineHist {
  DateTime takeDate;
  int bmId;
  double temperature;
  double humidity;
  int dosage;

  TakeMedicineHist(
      {this.takeDate, this.bmId, this.temperature, this.humidity, this.dosage});

  factory TakeMedicineHist.fromJson(Map<String, dynamic> parsedJson) {
    return TakeMedicineHist(
        takeDate: DateTime.parse(parsedJson['takeDate']).toLocal(),
        bmId: parsedJson['bmId'],
        temperature: parsedJson['temperature'],
        humidity: parsedJson['humidity'],
        dosage: parsedJson['dosage']);
  }

  Map<String, dynamic> toJson() => {
        "takeDate": takeDate,
        "bmId": bmId,
        "temperature": temperature,
        "humidity": humidity,
        "dosage": dosage,
      };
}
