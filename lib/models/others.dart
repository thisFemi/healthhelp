class School {
  final String name;
  final String location;

  School({required this.name, required this.location});

  factory School.fromJson(Map<String, dynamic> json) {
    return School(
      name: json['name'] as String,
      location: json['location'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'location': location,
    };
  }
}

class Medicals {
  String patientName;
  String patientId;
  MedStatus status;
  List<Test> test;

  Medicals({
    required this.status,
    required this.patientId,
    required this.patientName,
    required this.test,
  });

  factory Medicals.fromJson(Map<String, dynamic> json) {
    return Medicals(
        status: MedStatus.values[json['status']],
        test: (json['test'] as List<dynamic>)
            .map((test) => Test.fromJson(test))
            .toList(),
        patientId: json['id'],
        patientName: json['name']);
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status.index,
      'test': test.map((test) => test.toJson()).toList(),
    };
  }
}

enum MedStatus {
  notApplied,
  pending,
  approved,
}

class Test {
  bool isDone;
  String docName;
  DateTime date;
  String title;
  String comment;

  Test({
    this.isDone = false,
    required this.comment,
    required this.date,
    required this.docName,
    required this.title,
  });

  factory Test.fromJson(Map<String, dynamic> json) {
    return Test(
      isDone: json['isDone'] as bool,
      docName: json['docName'] as String,
      date: DateTime.parse(json['date']),
      title: json['title'] as String,
      comment: json['comment'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isDone': isDone,
      'docName': docName,
      'date': date.toIso8601String(),
      'title': title,
      'comment': comment,
    };
  }
}
