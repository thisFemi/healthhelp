import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../api/apis.dart';
import '../helper/utils/Colors.dart';
import '../helper/utils/contants.dart';
import '../models/user.dart';
import 'chat_user_card.dart';

class CallTabContent extends StatefulWidget {
  const CallTabContent({super.key});

  @override
  State<CallTabContent> createState() => _CallTabContentState();
}

class _CallTabContentState extends State<CallTabContent> {
  List<UserInfo> list = [];
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
            padding: EdgeInsets.symmetric(
                horizontal: Screen.deviceSize(context).width * .04,
                vertical: 10),
            child: Container(
              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.circular(10.0), // Adjust the radius as needed
                color: Colors.grey[200], // Customize the fill color as needed
              ),
              child: TextFormField(
                // controller: _name,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: InputDecoration(
                  hintText: "Search",
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(10),
                  prefixIcon: Icon(CupertinoIcons.search, color: color3),
                ),
              ),
            )),
        StreamBuilder(
            stream: APIs.getMyUsersId(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                case ConnectionState.none:
                  return Center(
                    child: SpinKitFadingCircle(
                      color: color3,
                      size: 40,
                    ),
                  );

                case ConnectionState.active:
                case ConnectionState.done:
                  break;
                default:
              }

              final data = snapshot.data?.docs;
              list =
                  data?.map((e) => UserInfo.fromJson(e.data())).toList() ?? [];
              print(list);
              if (list.isNotEmpty) {
                return ListView.builder(
                    physics: BouncingScrollPhysics(),
                    shrinkWrap: true,
                    padding: EdgeInsets.only(top: 10),
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      return ChatUserCard(list[index]);
                    });
              } else {
                return Center(
                  child: Text('No Messages yet'),
                );
              }
            }),
      ],
    );
  }
}
