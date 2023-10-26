import 'package:flutter/material.dart';

import '../models/user.dart';

// ignore: must_be_immutable
class UserProfileScreen extends StatefulWidget {
  UserInfo userInfo;
  UserProfileScreen({required this.userInfo});
  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
