import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../helper/utils/Colors.dart';
import '../helper/utils/contants.dart';
import '../models/user.dart';
import '../widgets/resuables.dart';

class AddReviewScreen extends StatefulWidget {
  AddReviewScreen({required this.doctor});
  final UserInfo doctor;

  @override
  State<AddReviewScreen> createState() => _AddReviewScreenState();
}

class _AddReviewScreenState extends State<AddReviewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: color7,
        elevation: 0,
        leading: Reausables.arrowBackIcon(context),
        title: Text(
          'Review',
          style: TextStyle(color: color3, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      backgroundColor: color7,
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(
              horizontal: Screen.deviceSize(context).width * .04, vertical: 10),
          child: Center(
            child: Column(
              //crossAxisAlignment: CrossAxisAlignment.start,
              //mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Rate the Medical Practitioner',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: 20,
                ),
                RatingBar.builder(
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: false,
                  itemCount: 5,
                  itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: Colors.orange.shade500,
                  ),
                  onRatingUpdate: (rating) {
                    print(rating);
                  },
                ),
                SizedBox(
                  height: 30,
                ),
                Text(
                  'Your review',
                  textAlign: TextAlign.left,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  keyboardType: TextInputType.text,
                  //  controller: noteController,
                  maxLines: 7,
                  onSaved: (newValue) {},
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[200],
                    hintStyle: TextStyle(color: color8),
                    labelStyle: TextStyle(
                        color: color8,
                        fontFamily: 'Raleway-SemiBold',
                        fontSize: 15.0),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(width: 1, color: color3),
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    disabledBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 1, color: color3),
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    errorBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    contentPadding: EdgeInsets.all(10),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "notes can't be empty";
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                    padding: EdgeInsets.symmetric(vertical: 20.0),
                    child: SizedBox(
                        height: 50.0,
                        width: Screen.deviceSize(context).width,
                        child: TextButton(
                          onPressed: () {
                            //  bookAppointment();
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: color3,
                          ),
                          child: Text('Share Your Experience',
                              style: TextStyle(
                                  color: color5,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold)),
                        )))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
