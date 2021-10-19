class TakeMedicineHist {
  DateTime takeDate;
  double temperature;
  double humidity;
  int balance;

  TakeMedicineHist(
      {this.takeDate, this.temperature, this.humidity, this.balance});

  factory TakeMedicineHist.fromJson(Map<String, dynamic> parsedJson) {
    return TakeMedicineHist(
        takeDate: DateTime.parse(parsedJson['takeDate']).toLocal(),
        temperature: parsedJson['temperature'].toDouble(),
        humidity: parsedJson['humidity'].toDouble(),
        balance: parsedJson['balance']);
  }

  Map<String, dynamic> toJson() => {
        "takeDate": takeDate,
        "temperature": temperature,
        "humidity": humidity,
        "balance": balance,
      };
}
