import 'package:HealthHelp/helper/utils/Colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../helper/utils/contants.dart';
import '../helper/utils/date_util.dart';
import '../models/user.dart';

class ReviewCard extends StatelessWidget {
  ReviewCard(this.review);
  Reviews review;
  @override
  Widget build(BuildContext context) {
    // final loremIpsum =
    //     "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.";

    return Card(
        margin: EdgeInsets.only(
          right: Screen.deviceSize(context).width * .03,
          top: 10,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: .5,
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () {
            showReviewDetails(context, review.comment);
          },
          child: Container(
            padding: EdgeInsets.all(10),
            height: Screen.deviceSize(context).height * .05,
            width: Screen.deviceSize(context).width * .8,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(
                        Screen.deviceSize(context).height * .03),
                    child: CachedNetworkImage(
                      height: Screen.deviceSize(context).height * .045,
                      width: Screen.deviceSize(context).height * .045,
                      fit: BoxFit.cover,
                      imageUrl: 'widget.doctor.image',
                      // placeholder: (context, url) => CircularProgressIndicator(
                      //   color: color3,
                      // ),
                      errorWidget: (context, url, error) => CircleAvatar(
                        child: Icon(CupertinoIcons.person),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        review.name,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      Text(
                        DateUtil.formatRelativeTime(review.date),
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            color: color8),
                      )
                    ],
                  ),
                  Spacer(),
                  RatingBarIndicator(
                    rating: double.parse(review.rating.toString()),
                    itemSize: 12,
                    direction: Axis.horizontal,
                    itemCount: 5,
                    itemPadding: const EdgeInsets.symmetric(horizontal: .1),
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: Colors.orange.shade500,
                    ),
                  ),
                ]),
                Text(
                  review.comment,
                  softWrap: true,
                  textAlign: TextAlign.justify,
                  overflow: TextOverflow.ellipsis, // Set overflow to ellipsis
                  maxLines: 2,
                  style: TextStyle(fontSize: 13),
                )
              ],
            ),
          ),
        ));
  }

  void showReviewDetails(BuildContext context, String text) {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        builder: (_) {
          return ListView(
            shrinkWrap: true,
            padding: EdgeInsets.only(
                top: Screen.deviceSize(context).height * 0.03,
                bottom: Screen.deviceSize(context).height * 0.05),
            children: [
              Center(
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ),
              ExpandableNotifier(
                  child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  children: [
                    ScrollOnExpand(
                        scrollOnExpand: true,
                        scrollOnCollapse: false,
                        child: ExpandablePanel(
                          theme: const ExpandableThemeData(
                            headerAlignment:
                                ExpandablePanelHeaderAlignment.center,
                            tapBodyToCollapse: true,
                          ),
                          header: Padding(
                              padding: EdgeInsets.all(10),
                              child: Row(
                                children: [
                                  Text(
                                    review.name,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  RatingBarIndicator(
                                    rating:
                                        double.parse(review.rating.toString()),
                                    itemSize: 12,
                                    direction: Axis.horizontal,
                                    itemCount: 5,
                                    itemPadding: const EdgeInsets.symmetric(
                                        horizontal: .1),
                                    itemBuilder: (context, _) => Icon(
                                      Icons.star,
                                      color: Colors.orange.shade500,
                                    ),
                                  ),
                                ],
                              )),
                          collapsed: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                DateUtil.formatRelativeTime(review.date),
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400,
                                    color: color8),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                text,
                                softWrap: true,
                                maxLines: 2,
                                textAlign: TextAlign.justify,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                          expanded: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                '1 Wk Ago',
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400,
                                    color: color8),
                              ),
                              Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: Text(
                                    text,
                                    softWrap: true,
                                    textAlign: TextAlign.justify,
                                    overflow: TextOverflow.fade,
                                  )),
                            ],
                          ),
                          builder: (_, collapsed, expanded) {
                            return Padding(
                              padding: const EdgeInsets.only(
                                left: 10,
                                right: 10,
                              ),
                              child: Expandable(
                                collapsed: collapsed,
                                expanded: expanded,
                                theme: const ExpandableThemeData(
                                    crossFadePoint: 0),
                              ),
                            );
                          },
                        )),
                  ],
                ),
              )),
            ],
          );
        });
  }
}
