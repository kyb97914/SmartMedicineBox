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
    print(parsedJson['info']);
    if (parsedJson['info'] == null) {
      return DoctorInfo(
          hospitalNm: null,
          hospitalAddr: null,
          contact: null,
          doctorNm: null,
          doctorId: null);
    } else {
      String temp = parsedJson['info']['contact'];
      if (temp[3] != '-') {
        temp = temp.substring(0, 3) +
            '-' +
            temp.substring(3, 7) +
            '-' +
            temp.substring(7, 11);
        print(temp);
      }
      return DoctorInfo(
          hospitalNm: parsedJson['info']['hospitalNm'],
          hospitalAddr: parsedJson['info']['hospitalAddr'],
          contact: temp,
          doctorNm: parsedJson['info']['doctorNm'],
          doctorId: parsedJson['doctorId']);
    }
  }

  Map<String, dynamic> toJson() => {
        "hospitalNm": hospitalNm,
        "hospitalAddr": hospitalAddr,
        "contact": contact,
        "doctorNm": doctorNm,
        "doctorId": doctorId,
      };
}
