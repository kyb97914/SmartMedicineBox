import 'Medicine.dart';
import 'takeMedicineHist.dart';

class BottleInfo {
  Medicine medeicine;
  int dailyDosage;
  int totalDosage;
  List<TakeMedicineHist> takeMedicineHist;

  BottleInfo(
      {this.medeicine,
      this.dailyDosage,
      this.totalDosage,
      this.takeMedicineHist});

  factory BottleInfo.fromJson(Map<String, dynamic> parsedJson) {
    var list = parsedJson['takeMedicineHist'] as List;
    List<TakeMedicineHist> resultList =
        list.map((i) => TakeMedicineHist.fromJson(i)).toList();
    return BottleInfo(
      medeicine: parsedJson['medeicine'],
      dailyDosage: parsedJson['dailyDosage'],
      totalDosage: parsedJson['totalDosage'],
      takeMedicineHist: resultList,
    );
  }

  Map<String, dynamic> toJson() => {
        "medeicine": medeicine,
        "dailyDosage": dailyDosage,
        "takeMedicineHist": takeMedicineHist,
        "totalDosage": totalDosage,
      };
}
