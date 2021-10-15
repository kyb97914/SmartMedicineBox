class TakeMedicineHist {
  DateTime takeDate;
  double temperature;
  double humidity;
  int dosage;

  TakeMedicineHist(
      {this.takeDate, this.temperature, this.humidity, this.dosage});

  factory TakeMedicineHist.fromJson(Map<String, dynamic> parsedJson) {
    return TakeMedicineHist(
        takeDate: DateTime.parse(parsedJson['takeDate']).toLocal(),
        temperature: parsedJson['temperature'].toDouble(),
        humidity: parsedJson['humidity'].toDouble(),
        dosage: parsedJson['dosage']);
  }

  Map<String, dynamic> toJson() => {
        "takeDate": takeDate,
        "temperature": temperature,
        "humidity": humidity,
        "dosage": dosage,
      };
}
