import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:HealthHelp/widgets/call_tab_content.dart';

import '../helper/utils/Colors.dart';
import '../helper/utils/contants.dart';
import '../widgets/chat_tab_content.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  void _switchTab(int newIndex) {
    setState(() {
      _tabController.index = newIndex;
    });
  }

  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: WillPopScope(
        onWillPop: () {
          if (_isSearching) {
            setState(() {
              _isSearching = !_isSearching;
            });
            return Future.value(false);
          } else {
            return Future.value(true);
          }
        },
        child: Scaffold(
          backgroundColor: color6,
            body: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Container(
            height: Screen.deviceSize(context).height,
            margin:
                EdgeInsets.only(top: Screen.deviceSize(context).height * .06),
            child: SingleChildScrollView(child: ChatTabContent(_isSearching)),
          ),
        )),
      ),
    );
  }
}
