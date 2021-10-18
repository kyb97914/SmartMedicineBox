class Medicine {
  int medicineId;
  String antiEffect;
  String company;
  String dosage;
  String name;
  String target;
  String warn;

  Medicine(
      {this.medicineId,
      this.antiEffect,
      this.company,
      this.dosage,
      this.name,
      this.target,
      this.warn});

  factory Medicine.fromJson(Map<String, dynamic> parsedJson) {
    if (parsedJson == null) {
      return Medicine(
        medicineId: null,
        antiEffect: null,
        company: null,
        dosage: null,
        name: null,
        target: null,
        warn: null,
      );
    } else {
      String temp;
      if (parsedJson['name'].contains('(') == true) {
        temp = parsedJson['name'].split('(')[0];
      } else if (parsedJson['name'].contains('<') == true) {
        temp = parsedJson['name'].split('<')[0];
      } else {
        temp = parsedJson['name'];
      }
      return Medicine(
        medicineId: parsedJson['medicineId'],
        antiEffect: parsedJson['antiEffect'],
        company: parsedJson['company'],
        dosage: parsedJson['dosage'],
        name: temp,
        target: parsedJson['target'],
        warn: parsedJson['warn'],
      );
    }
  }

  Map<String, dynamic> toJson() => {
        "medicineId": medicineId,
        "antiEffect": antiEffect,
        "company": company,
        "dosage": dosage,
        "name": name,
        "target": target,
        "warn": warn,
      };
}
