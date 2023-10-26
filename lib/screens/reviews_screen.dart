import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../helper/utils/Colors.dart';
import '../helper/utils/contants.dart';
import '../models/user.dart';
import '../widgets/resuables.dart';
import '../widgets/review_card.dart';

class ReviewListScreen extends StatelessWidget {
  ReviewListScreen(this.reviews);
  List<Reviews> reviews;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: color7,
        elevation: 0,
        leading: Reausables.arrowBackIcon(context),
        title: Text(
          'Reviews',
          style: TextStyle(color: color3, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: reviews.isNotEmpty
          ? SingleChildScrollView(
              child: Container(
                  margin: EdgeInsets.only(
                    left: 20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      AnimationLimiter(
                        child: ListView.builder(
                          itemCount: reviews
                              .length, // Change this to the number of reviews you have
                          physics: BouncingScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return AnimationConfiguration.staggeredList(
                                position: index,
                                duration: const Duration(milliseconds: 375),
                                child: SlideAnimation(
                                    verticalOffset: 50.0,
                                    child: FadeInAnimation(
                                      child: SizedBox(
                                          height: Screen.deviceSize(context)
                                                  .height *
                                              .13,
                                          child: ReviewCard(reviews[index])),
                                    )));
                          },
                        ),
                      )
                    ],
                  )))
          : Center(
              child: Text(
                'No reviews yet',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
    );
  }
}
