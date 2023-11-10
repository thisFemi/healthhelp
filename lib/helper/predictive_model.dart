import '../models/others.dart';

class MedicalScheduler {
  final List<Medicals> existingMedicals;

  MedicalScheduler({required this.existingMedicals});

  DateTime? getClosestAvailableBookingDateTime() {
    // Sort the existing medicals by screeningDate
    existingMedicals.sort((a, b) => a.screeningDate!.compareTo(b.screeningDate!));

    // Initialize with the current date and time
    DateTime proposedDateTime = DateTime.now();

    // Check for the closest available booking datetime
    for (var existingMedical in existingMedicals) {
      if (proposedDateTime.isBefore(existingMedical.screeningDate!)) {
        return proposedDateTime;
      }

      // Set proposedDateTime to the next day
      proposedDateTime = existingMedical.screeningDate!.add(Duration(days: 1));
    }

    // Check for available booking datetimes within working hours (8 am to 5 pm)
    while (proposedDateTime.hour < 8 || proposedDateTime.hour >= 17) {
      proposedDateTime = proposedDateTime.add(Duration(hours: 1));
    }

    return proposedDateTime;
  }
}
