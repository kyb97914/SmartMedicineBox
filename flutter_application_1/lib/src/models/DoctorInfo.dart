class DoctorInfo {
  String hospitalNm;
  String hospitalAddr;
  String contact;
  String doctorNm;
  String doctorId;

  DoctorInfo(
      {this.hospitalNm,
      this.hospitalAddr,
      this.contact,
      this.doctorNm,
      this.doctorId});

  factory DoctorInfo.fromJson(Map<String, dynamic> parsedJson) {
    return DoctorInfo(
        /*
        hospitalNm: parsedJson['info']['hospitalNm'],
        hospitalAddr: parsedJson['info']['hospitalAddr'],
        contact: parsedJson['info']['contact'],
        doctorNm: parsedJson['info']['doctorNm'],
        doctorId: parsedJson['doctorId']*/
        );
  }

  Map<String, dynamic> toJson() => {
        "hospitalNm": hospitalNm,
        "hospitalAddr": hospitalAddr,
        "contact": contact,
        "doctorNm": doctorNm,
        "doctorId": doctorId,
      };
}
