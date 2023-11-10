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
  String? school;
  String? docName;
  String? docId;
double? status;
  List<Test>? test;
DateTime screeningDate;

  Medicals({

    required this.patientId,
     this.docName,
     this.docId,
    required this.patientName,
     this.status,
     this.test,
    required this.screeningDate,
    this.school,
  });
  double calculateVerificationStatus() {
    if (test == null || test!.isEmpty) {
      return 0.0; // No tests, so 0.0 (0%) verified
    }

    int verifiedCount = test!.where((test) => test.isDone).length;
    double verificationStatus = (verifiedCount / test!.length);

    return verificationStatus;
  }
  factory Medicals.fromJson(Map<String, dynamic> json) {
    List<Test>? tests = (json['test'] as List<dynamic>?)
        ?.map((test) => Test.fromJson(test))
        .toList();

    Medicals medicals = Medicals(
      patientId: json['patientId'],
      patientName: json['patientName'],
      docId: json['docId'] ?? null,
      docName: json['docName'] ?? null,
      status: 0.0, // Initialize with 0%, you will calculate it later
      test: tests ?? [],
      screeningDate: DateTime.parse(json['screeningDate']),
      school: json['school'] ?? null,
    );

    // Now, calculate the verification status
    medicals.status = medicals.calculateVerificationStatus();

    return medicals;
  }

  Map<String, dynamic> toJson() {
    return {

      'id':patientId,
      'docId':docId,

      'test': test!.map((test) => test.toJson()).toList(),
    };
  }
}



class Test {
  bool isDone;
  String? docName;

  DateTime? date;
  String title;
  String? comment;

  Test({
    this.isDone = false,
     this.comment,
     this.date,
     this.docName,
    required this.title,
  });

  factory Test.fromJson(Map<String, dynamic> json) {
    return Test(
      isDone: json['isDone'] ,
      docName: json['docName']??null ,
      title: json['title'],
      date: json['docName']==null?null: DateTime.parse(json['date']) ,
      comment: json['comment'] ??null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isDone': isDone,
      'docName': docName??null,
      'date': date!=null?date!.toIso8601String():null,
      'title': title,
      'comment': comment??null,
    };
  }
}

class DocReg {
  String name;
  String homeAddress;
  bool isUniStaff;
  String? schoolName;
  ApprovalStatus status;
  String? officeAddress;
  List<Certificate>? certificates;

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
      schoolName: json['schoolName']??null,
      status:  _parseApprovalStatus(json['status']),
      officeAddress: json['officeAddress']??null,
      certificates: (json['certificates'] as List<dynamic>?)
          ?.map((cert) => Certificate.fromJson(cert))
          .toList() ?? [],
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
      'certificates': certificates!.map((cert) => cert.toJson()).toList(),
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
ApprovalStatus _parseApprovalStatus(String status) {
  switch (status.toLowerCase()) {
    case 'approved':
      return ApprovalStatus.approved;
    case 'pending':
      return ApprovalStatus.pending;
    case 'rejected':
      return ApprovalStatus.rejected;
    default:
      throw ArgumentError('Invalid status: $status');
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

