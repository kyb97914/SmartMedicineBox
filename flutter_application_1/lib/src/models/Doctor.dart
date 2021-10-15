import 'BottleMedicine.dart';

class Doctor {
  String validateDoctorLicense;
  String hospitalNm;
  String hospitalAddr;
  String contact;
  String doctorNm;

  Doctor(
      {this.validateDoctorLicense,
      this.hospitalNm,
      this.hospitalAddr,
      this.contact,
      this.doctorNm});

  factory Doctor.fromJson(Map<String, dynamic> parsedJson) {
    return Doctor(
      validateDoctorLicense: parsedJson['validateDoctorLicense'],
      hospitalNm: parsedJson['hospitalNm'],
      hospitalAddr: parsedJson['hospitalAddr'],
      contact: parsedJson['contact'],
      doctorNm: parsedJson['doctorNm'],
    );
  }

  Map<String, dynamic> toJson() => {
        "validateDoctorLicense": validateDoctorLicense,
        "hospitalNm": hospitalNm,
        "hospitalAddr": hospitalAddr,
        "contact": contact,
        "doctorNm": doctorNm,
      };
}
