class DoctorREQ {
  final String patientId;
  final String doctorId;
  final String useYn;
  final String info;
  final String doctorNm;

  DoctorREQ(
      {this.patientId, this.doctorId, this.useYn, this.info, this.doctorNm});

  factory DoctorREQ.fromJson(Map<String, dynamic> parsedJson) {
    return DoctorREQ(
        patientId: parsedJson['patientId'],
        doctorId: parsedJson['doctorId'],
        useYn: parsedJson['useYn'],
        info: parsedJson['info'],
        doctorNm: parsedJson['doctorNm']);
  }

  Map<String, dynamic> toJson() => {
        "patientId": patientId,
        "doctorId": doctorId,
        "useYn": useYn,
        "info": info,
        "doctorNm": doctorNm,
      };
}
