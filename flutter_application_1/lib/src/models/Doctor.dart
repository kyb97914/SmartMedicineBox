import 'BottleMedicine.dart';

class Doctor {
  String fdbType;
  String doctorId;
  String feedback;
  DateTime fdbDtm;
  BottleMedicine bmId;

  Doctor({this.fdbType, this.doctorId, this.feedback, this.fdbDtm, this.bmId});

  factory Doctor.fromJson(Map<String, dynamic> parsedJson) {
    var list = parsedJson['bmId'] as List;
    List<BottleMedicine> data =
        list.map((i) => BottleMedicine.fromJson(i)).toList();

    return Doctor(
      fdbType: parsedJson['fdbType'],
      doctorId: parsedJson['doctorId'],
      feedback: parsedJson['feedback'],
      fdbDtm: DateTime.parse(parsedJson['fdbDtm']).toLocal(),
      bmId: data[0],
    );
  }
}
