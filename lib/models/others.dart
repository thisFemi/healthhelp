import 'dart:io';

import 'package:file_picker/file_picker.dart';

class School {
  final String name;
  final String location;

  School({required this.name, required this.location});

  factory School.fromJson(Map<String, dynamic> json) {
    return School(
      name: json['name'] ??"",
      location: json['country'] ??"",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'country': location,
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
  completed,
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
}class DocReg {
  String name;
  String homeAddress;
  bool isUniStaff;
  String? schoolName;
  ApprovalStatus status;
  String? officeAddress;
  List<Certificate> certificates;

  DocReg({
    required this.name,
    required this.homeAddress,
    required this.isUniStaff,
    required this.certificates,
    required this.status,
    this.officeAddress,
    this.schoolName,
  });

  // Deserialize from JSON
  factory DocReg.fromJson(Map<String, dynamic> json) {
    return DocReg(
      name: json['name'],
      homeAddress: json['homeAddress'],
      isUniStaff: json['isUniStaff'],
      schoolName: json['schoolName'],
      status: ApprovalStatus.values[json['status']],
      officeAddress: json['officeAddress'],
      certificates: (json['certificates'] as List<dynamic>)
          .map((cert) => Certificate.fromJson(cert))
          .toList(),
    );
  }

  // Serialize to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'homeAddress': homeAddress,
      'isUniStaff': isUniStaff,
      'schoolName': schoolName,
      'status':status.name,
      'officeAddress': officeAddress,
      'certificates': certificates.map((cert) => cert.toJson()).toList(),
    };
  }
}

class Certificate {
  DateTime date;
  File fileName;
  FileType type;

  Certificate({
    required this.type,
    required this.date,
    required this.fileName,
  });

  // Deserialize from JSON
  factory Certificate.fromJson(Map<String, dynamic> json) {
    return Certificate(
      type: json['type'] == 'image' ? FileType.img : FileType.pdf, // Adjust for more file types.
      date: DateTime.parse(json['date']),
      fileName: File(json['fileName']),
    );
  }

  // Serialize to JSON
  Map<String, dynamic> toJson() {
    return {
      'type': type == FileType.img ? 'image' : 'pdf', // Adjust for more file types.
      'date': date.toIso8601String(),
      'fileName': fileName.path,
    };
  }
}

enum FileType {
  img,
  pdf,
}
enum ApprovalStatus{
  approved,
  pending,
  rejected,
}

class ToDoItem {
   String title;
   double progress;
 Function onTap;
  ToDoItem({required this.title, required this.onTap, required this.progress});
}

