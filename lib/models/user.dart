import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';

class UserInfo {
  String image;
  String userType;
  String name;
  String createdAt;
  String email;
  bool isOnline;
  String lastActive;
  String id;
  String phoneNumber;
  String pushToken;
  PatientContactInfo? patientContactInfo;
  DoctorContactInfo? doctorContactInfo;

  UserInfo({
    required this.image,
    required this.userType,
    required this.name,
    required this.createdAt,
    required this.email,
    required this.isOnline,
    required this.lastActive,
    required this.id,
    required this.phoneNumber,
    required this.pushToken,
    this.patientContactInfo,
    this.doctorContactInfo,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      image: json['image'] ?? '',
      userType: json['user_type'] ?? '',
      name: json['name'] ?? '',
      createdAt: json['created_at'] ?? '',
      email: json['email'] ?? '',
      isOnline: json['is_online'] ?? false,
      lastActive: json['last_active'] ?? '',
      id: json['id'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
      pushToken: json['push_token'] ?? '',
      patientContactInfo:
          json['user_type'].toString().toLowerCase() == 'patient'
              ? PatientContactInfo.fromJson(json['contact_info'])
              : null,
      doctorContactInfo: json['user_type'].toString().toLowerCase() == 'doctor'
          ? DoctorContactInfo.fromJson(json['contact_info'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'image': image,
      'user_type': userType,
      'name': name,
      'created_at': createdAt,
      'email': email,
      'is_online': isOnline,
      'last_active': lastActive,
      'id': id,
      'phone_number': phoneNumber,
      'push_token': pushToken,
      'contact_info': userType == 'patient'
          ? patientContactInfo?.toJson()
          : userType == 'doctor'
              ? doctorContactInfo?.toJson()
              : null,
    };
  }
}

class PatientContactInfo {
  String phone;
  String clinicAddress;

  PatientContactInfo({
    required this.phone,
    required this.clinicAddress,
  });

  factory PatientContactInfo.fromJson(Map<String, dynamic> json) {
    return PatientContactInfo(
      phone: json['phone'],
      clinicAddress: json['address'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'phone': phone,
      'address': clinicAddress,
    };
  }
}

class DoctorContactInfo {
  bool isVerified;
  AvailabilityDuration selectedDuration;
  List<Specialization> specilizations;
  List<Map<String, List<Appointment>>> appointments;
  String phone;
  String clinicAddress;
  double totalRatingAvg;
  List<Reviews> reviews;
  String startTime;
  String endTime;

  DoctorContactInfo({
    required this.phone,
    required this.clinicAddress,
    required this.startTime,
    required this.endTime,
    required this.specilizations,
    required this.isVerified,
    required this.selectedDuration,
    required this.totalRatingAvg,
    required this.reviews,
    required this.appointments,
  });

  factory DoctorContactInfo.fromJson(Map<String, dynamic> json) {
    final selectedDurationStr = json['selected_duration'];
    AvailabilityDuration selectedDuration;
    if (selectedDurationStr == 'aMonth') {
      selectedDuration = AvailabilityDuration.aMonth;
    } else if (selectedDurationStr == 'twoMonths') {
      selectedDuration = AvailabilityDuration.twoMonths;
    } else if (selectedDurationStr == 'sixMonths') {
      selectedDuration = AvailabilityDuration.sixMonths;
    } else if (selectedDurationStr == 'everyTime') {
      selectedDuration = AvailabilityDuration.everyTime;
    } else {
      selectedDuration = AvailabilityDuration.notAvailable; // Default
    }
    final availabilityJson = json['appointments'];
    final List<Map<String, List<Appointment>>> appointments = [];

    if (availabilityJson != null && availabilityJson is List) {
      availabilityJson.forEach((entry) {
        if (entry is Map) {
          entry.forEach((date, slots) {
            if (date is String && slots is List) {
              final List<Appointment> appointmentSlots = slots
                  .map((slot) =>
                      Appointment.fromJson(slot as Map<String, dynamic>))
                  .toList();

              appointments.add({
                date: appointmentSlots,
              });
            }
          });
        }
      });
    }
    double totalAvg = 0.0;
    final reviewsJson = json['reviews'] as List<dynamic>?;
    if (reviewsJson != null) {
      final List<Reviews> reviews =
          reviewsJson.map((review) => Reviews.fromJson(review)).toList();

      if (reviews.isNotEmpty) {
        int total = 0;
        for (final review in reviews) {
          total += review.rating;
        }
        final double averageRating = total / reviews.length;

        // Map the average rating from the range [0, 5] to [1, 5]
        totalAvg = (averageRating * 4 / 5) + 1;
      }
    }
    return DoctorContactInfo(
        phone: json['phone'],
        clinicAddress: json['clinic_address'],
        startTime: json['start_time'],
        endTime: json['end_time'],
        appointments: appointments,
        selectedDuration: selectedDuration,
        isVerified: json['is_verified'],
        totalRatingAvg: totalAvg,
        specilizations: (json['specializations'] as List<dynamic>?)
                ?.map((spec) => Specialization(title: spec.toString()))
                .toList() ??
            [],
        reviews: (json['reviews'] as List<dynamic>?)
                ?.map((review) => Reviews.fromJson(review))
                .toList() ??
            []);
  }

  Map<String, dynamic> toJson() {
    final List<Map<String, dynamic>> availabilityJson =
        appointments.map((entry) {
      final String date = entry.keys.first;
      final List<Map<String, dynamic>> slots =
          entry.values.first.map((slot) => slot.toJson()).toList();
      return {
        date: slots,
      };
    }).toList();

    return {
      'phone': phone,
      'clinic_address': clinicAddress,
      'start_time': startTime,
      'end_time': endTime,
      'is_verified': isVerified,
      'selected_duration': selectedDuration.name, // Convert to string
      'reviews': reviews.map((review) => review.toJson()).toList(),
      'appointments': availabilityJson,
      'specializations': specilizations.map((spec) => spec.title).toList(),
    };
  }

  int calculateTotalRatingAvg() {
    if (reviews.isNotEmpty) {
      int total = 0;
      for (final review in reviews) {
        total += review.rating;
      }
      return total ~/ reviews.length; // Use integer division for the average.
    } else {
      return 0; // Return 0 if there are no reviews to prevent division by zero.
    }
  }
}

class Specialization {
  String title;
  Specialization({required this.title});
  static List<Specialization> listFromJson(List<String> titles) {
    return titles.map((title) => Specialization(title: title)).toList();
  }
}

class Appointment {
  String time;
  bool isBooked;
  String patientId;

  Appointment(
      {required this.time, required this.isBooked, required this.patientId});

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
        time: json['time'],
        isBooked: json['is_booked'] ?? false,
        patientId: json['patient_id']);
  }

  Map<String, dynamic> toJson() {
    return {
      'time': time,
      'is_booked': isBooked,
      'patient_id': patientId,
    };
  }
}

class Reviews {
  String name;
  int rating;
  DateTime date;
  String comment;
  Reviews(
      {required this.name,
      required this.rating,
      required this.date,
      required this.comment});
  factory Reviews.fromJson(Map<String, dynamic> json) {
    final timestamp = json['date'] as Timestamp;
    final dateTime = timestamp.toDate();
    return Reviews(
        name: json['name'],
        rating: json['rating'],
        date: dateTime,
        comment: json['comment']);
  }
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'rating': rating,
      'date': Timestamp.fromDate(date),
      'comment': comment,
    };
  }
}

enum AvailabilityDuration {
  aMonth,
  twoMonths,
  sixMonths,
  everyTime,
  notAvailable,
}

extension AvailabilityDurationExtension on AvailabilityDuration {
  Duration get duration {
    switch (this) {
      case AvailabilityDuration.aMonth:
        return Duration(days: 30);
      case AvailabilityDuration.twoMonths:
        return Duration(days: 60);
      case AvailabilityDuration.sixMonths:
        return Duration(days: 180);
      case AvailabilityDuration.everyTime:
        // Return a long duration to cover a large time span.
        return Duration(days: 365 * 5); // 5 years
      case AvailabilityDuration.notAvailable:
        return Duration.zero; // No duration
    }
  }
}


