import 'Medicine.dart';
import 'takeMedicineHist.dart';
import 'DoctorInfo.dart';

class BottleInfo {
  Medicine medeicine;
  int dailyDosage;
  int totalDosage;
  DoctorInfo doctorInfo;
  List<TakeMedicineHist> takeMedicineHist;

  BottleInfo(
      {this.medeicine,
      this.dailyDosage,
      this.totalDosage,
      this.takeMedicineHist,
      this.doctorInfo});

  factory BottleInfo.fromJson(Map<String, dynamic> parsedJson) {
    var list = parsedJson['takeMedicineHist'] as List;

    Map<String, dynamic> map = (parsedJson['medicine']);
    Medicine info = Medicine.fromJson(map);

    Map<String, dynamic> doctormap = (parsedJson['doctorInfo']);
    DoctorInfo doctorinfo = DoctorInfo.fromJson(doctormap);
    List<TakeMedicineHist> resultList =
        list.map((i) => TakeMedicineHist.fromJson(i)).toList();
    return BottleInfo(
        medeicine: info,
        dailyDosage: parsedJson['dailyDosage'],
        totalDosage: parsedJson['totalDosage'],
        takeMedicineHist: resultList,
        doctorInfo: doctorinfo);
  }

  Map<String, dynamic> toJson() => {
        "medeicine": medeicine,
        "dailyDosage": dailyDosage,
        "takeMedicineHist": takeMedicineHist,
        "totalDosage": totalDosage,
        "doctorInfo": doctorInfo,
      };
}
