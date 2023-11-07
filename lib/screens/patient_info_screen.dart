import 'package:flutter/material.dart';

import '../models/others.dart';
import '../models/user.dart';

class PatientInfoScreen extends StatefulWidget {
  PatientInfoScreen({required this.patient, required this.record});
  final UserInfo patient;
  Medicals record;

  @override
  State<PatientInfoScreen> createState() => _PatientInfoScreenState();
}

class _PatientInfoScreenState extends State<PatientInfoScreen> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
