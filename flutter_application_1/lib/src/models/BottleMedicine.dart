class BottleMedicine {
  int dosage;
  int bottleId;
  int medicineId;
  String doctorId;
  String doctorName;
  DateTime regDtm;

  BottleMedicine(
      {this.dosage,
      this.bottleId,
      this.medicineId,
      this.doctorId,
      this.doctorName,
      this.regDtm});

  factory BottleMedicine.fromJson(Map<String, dynamic> parsedJson) {
    return BottleMedicine(
      dosage: parsedJson['dosage'],
      bottleId: parsedJson['bottleId'],
      medicineId: parsedJson['medicineId'],
      doctorId: parsedJson['doctorId'],
      regDtm: DateTime.parse(parsedJson['regDtm']).toLocal(),
    );
  }

  Map<String, dynamic> toJson() => {
        "dosage": dosage,
        "bottleId": bottleId,
        "medicineId": medicineId,
        "doctorId": doctorId,
        "doctorName": doctorName,
        "regDtm": regDtm
      };
}
