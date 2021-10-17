class DoctorFeedback {
  String fdbType;
  String doctorId;
  String feedback;
  DateTime fdbDtm;

  DoctorFeedback({
    this.fdbType,
    this.doctorId,
    this.feedback,
    this.fdbDtm,
  });

  factory DoctorFeedback.fromJson(Map<String, dynamic> parsedJson) {
    return DoctorFeedback(
        fdbType: parsedJson['fdbType'],
        doctorId: parsedJson['doctorId'],
        feedback: parsedJson['feedback'],
        fdbDtm: DateTime.parse(parsedJson['fdbDtm']).toLocal());
  }

  Map<String, dynamic> toJson() => {
        "fdbType": fdbType,
        "doctorId": doctorId,
        "feedback": feedback,
        "fdbDtm": fdbDtm,
      };
}
