import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


import '../api/apis.dart';
import '../helper/utils/Colors.dart';
import '../helper/utils/contants.dart';
import '../models/user.dart';
import 'chat_user_card.dart';
import 'empty_list.dart';

// ignore: must_be_immutable
class ChatTabContent extends StatefulWidget {
  bool isSearching = false;
  ChatTabContent(this.isSearching);

  @override
  State<ChatTabContent> createState() => _ChatTabContentState();
}

class _ChatTabContentState extends State<ChatTabContent> {
  List<UserInfo> list = [];
  List<UserInfo> _searchList = [];
  bool isSearching = false;
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
                onChanged: (value) {
                  isSearching = true;
                  _searchList.clear();
                  for (var i in list) {
                    if (i.name.toLowerCase().contains(value.toLowerCase()) ||
                        i.email.toLowerCase().contains(value.toLowerCase())) {
                      _searchList.add(i);
                    }
                    setState(() {
                      _searchList;
                    });
                  }
                },
              ),
            )),
        StreamBuilder(
            stream: APIs.getMyUsersId(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                case ConnectionState.none:
                  // return Center(
                  //     child: SpinKitFadingCircle(
                  //   color: color3,
                  //   size: 40,
                  // ));
                case ConnectionState.active:
                case ConnectionState.done:
                  break;
                default:
              }

              return StreamBuilder(
                  stream: APIs.getAllUsers(
                      snapshot.data?.docs.map((e) => e.id).toList() ?? []),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                      case ConnectionState.none:
                        return Center(child: SizedBox());

                      case ConnectionState.active:
                      case ConnectionState.done:
                        break;
                      default:
                    }

                    final data = snapshot.data?.docs;
                    list = data
                            ?.map((e) => UserInfo.fromJson(e.data()))
                            .toList() ??
                        [];
                 //   print(list);
                    if (list.isNotEmpty) {
                      return ListView.builder(
                          physics: BouncingScrollPhysics(),
                          shrinkWrap: true,
                          padding: EdgeInsets.only(top: 10),
                          itemCount:
                              isSearching ? _searchList.length : list.length,
                          itemBuilder: (context, index) {
                            return ChatUserCard(
                                isSearching ? _searchList[index] : list[index]);
                          });
                    } else {
                      return EmptyList(
                        label: 'No Messages yet',
                      );
                    }
                  });
            }),
      ],
    );
  }
}


