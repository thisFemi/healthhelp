class UserAppointment {
  String patientId;
  String doctorId;
  DateTime date;
  String time;
  DateTime createdAt;
  String details;
  AppointmentStatus status;

  UserAppointment(
      {required this.doctorId,
      required this.patientId,
      required this.date,
      required this.status,
      required this.createdAt,
      required this.details,
      required this.time});
  factory UserAppointment.fromJson(Map<String, dynamic> json) {
    print('done');
    print(json.runtimeType);
    return UserAppointment(
      doctorId: json['doctorId'],
      details: json['details'],
      patientId: json['patientId'],
      createdAt: DateTime.parse(json['created_at']),
      date: DateTime.parse(
          json['date']), // Assuming 'date' is stored as a Firestore Timestamp
      time: json['time'],

      status: appointmentStatusFromJson(json['status']),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'doctorId': doctorId,
      'patientId': patientId,
      'date':
          date.toString(), // You may need to convert this to a Firestore Timestamp if required
      'time': time,
      'created_at': createdAt.toString(),
      'details': details,
      'status': status.name,
    };
  }

  void updateStatusIfNecessary() {
    if (status == AppointmentStatus.approved) {
      final currentDate = DateTime.now();
      if (date.isBefore(currentDate)) {
        status = AppointmentStatus.completed;
      }
    }
  }
}

String appointmentStatusToJson(AppointmentStatus status) {
  return status.toString().split('.').last;
}

AppointmentStatus appointmentStatusFromJson(String status) {
  late AppointmentStatus fetchedStatus;
  if (status == 'completed') {
    fetchedStatus = AppointmentStatus.completed;
  } else if (status == 'approved') {
    fetchedStatus = AppointmentStatus.approved;
  } else if (status == 'pending') {
    fetchedStatus = AppointmentStatus.pending;
  } else {
    fetchedStatus = AppointmentStatus.rejected;
  }
  return fetchedStatus;
}

enum AppointmentStatus { rejected, approved, pending, completed }
