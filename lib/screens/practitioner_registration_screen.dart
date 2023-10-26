// ignore_for_file: use_key_in_widget_constructors, must_be_immutable, prefer_const_constructors

import 'package:HealthHelp/models/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:multiple_search_selection/helpers/create_options.dart';
import 'package:multiple_search_selection/multiple_search_selection.dart';

import '../helper/utils/Colors.dart';
import '../helper/utils/contants.dart';
import '../widgets/resuables.dart';

class PractitionerRegistrationScreen extends StatefulWidget {
  UserInfo userInfo;
  PractitionerRegistrationScreen(this.userInfo);

  @override
  State<PractitionerRegistrationScreen> createState() =>
      _PractitionerRegistrationScreenState();
}

class _PractitionerRegistrationScreenState
    extends State<PractitionerRegistrationScreen> {
  final List<Specialization> specialization = [
    Specialization(title: 'Dentist'),
    Specialization(title: 'Surgeon'),
    Specialization(title: 'Pharmacist')
  ];

  final List<String> periods = [
    'A Month',
    'Next 3 Month',
    'Next 6 Months',
    'Always Available'
  ];
    final List<String> workHours = [
      '9:00 AM',
      '10:00 AM',
      '11:00 AM',
      '12:00 PM',
      '1:00 PM',
      '2:00 PM',
      '3.00 PM',
      '4.00 PM',
      '5.00 PM',
    ];
  String? selectedPeriod;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: color7,
        elevation: 0,
        leading: Reausables.arrowBackIcon(context),
        title: Text(
          'Medical Registration',
          style: TextStyle(color: color3, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          // Padding(
          //   padding: const EdgeInsets.only(right: 10.0),
          //   child: IconButton(
          //       onPressed: () {},
          //       icon: Icon(CupertinoIcons.chat_bubble_2, color: color3)),
          // )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(
              horizontal: Screen.deviceSize(context).width * .04, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MultipleSearchSelection<Specialization>.creatable(
                title: Text('Specialization',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    )),

                onItemAdded: (c) {},
                showClearSearchFieldButton: true,
                createOptions: CreateOptions(
                  createItem: (text) {
                    return Specialization(title: text);
                  },
                  onItemCreated: (c) =>
                      print('Specilization ${c.title} created'),
                  createItemBuilder: (text) => Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Create "$text"'),
                    ),
                  ),
                  pickCreatedItem: false,
                ),
                items: specialization, // List<Country>
                fieldToCheck: (c) {
                  return c.title;
                },
                itemBuilder: (country, index) {
                  return Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: Colors.white,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 20.0,
                          horizontal: 12,
                        ),
                        child: Text(country.title),
                      ),
                    ),
                  );
                },
                pickedItemBuilder: (country) {
                  return Container(
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(5)),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        country.title,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  );
                },
                searchFieldInputDecoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[200],
                  hintStyle: TextStyle(color: color8),
                  hintText: 'Type here to search',
                  labelStyle: TextStyle(
                      color: color8,
                      fontFamily: 'Raleway-SemiBold',
                      fontSize: 15.0),
                  border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  disabledBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  errorBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  contentPadding: EdgeInsets.all(10),
                ),
                sortShowedItems: true,
                sortPickedItems: true,
                selectAllButton: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blue),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Select All',
                        // style: kStyleDefault,
                      ),
                    ),
                  ),
                ),
                clearAllButton: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.red),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Clear All',
                        // style: kStyleDefault,
                      ),
                    ),
                  ),
                ),
                caseSensitiveSearch: true,
                fuzzySearch: FuzzySearch.none,
                itemsVisibility: ShowedItemsVisibility.onType,
                showSelectAllButton: false,
                maximumShowItemsHeight: Screen.deviceSize(context).height * .3,
                clearSearchFieldOnSelect: true,
                maxSelectedItems: 5,
                showItemsButton: Icon(Icons.clear),

                // This trailing comma makes auto-formatting nicer for build methods.
              ),
              SizedBox(
                height: 10,
              ),
              Text('Schedules',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  )),
              Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(children: [
                          Text('Available Period',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              )),
                          SizedBox(
                            height: Screen.deviceSize(context).height * .05,
                            width: Screen.deviceSize(context).width * .45,
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                isExpanded: true,
                                hint: SizedBox(
                                  child: Text('Period',
                                      style: TextStyle(
                                        fontSize: 14,
                                      )),
                                ),
                                items: periods
                                    .map<DropdownMenuItem<String>>((period) {
                                  return DropdownMenuItem<String>(
                                      value: period,
                                      child: SizedBox(
                                          child: Text(period,
                                              style: TextStyle(
                                                fontSize: 12,
                                              ))));
                                }).toList(),
                                value: selectedPeriod,
                                onChanged: (value) {
                                  setState(() {
                                    selectedPeriod = value;
                                  });
                                },
                                // buttonStyleData: ButtonStyleData(
                                //     // height: deviceSize.height * .04,
                                //     // padding: EdgeInsets.only(left: 10, right: 10),
                                //     decoration: BoxDecoration(
                                //         borderRadius: BorderRadius.circular(5),
                                //         border: Border.all(
                                //             color: Theme.of(context)
                                //                 .colorScheme
                                //                 .secondary))),
                              ),
                            ),
                          ),
                        ]),
                        Spacer(),
                        Container(
                            child: Column(
                          children: [
                            Text('Daily Time Availability',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                )),
                            Row(children: [
                              // Text('From'),
                              // SizedBox(width: 10),
                              // SizedBox(
                              //   height: Screen.deviceSize(context).height * .05,
                              //   width: Screen.deviceSize(context).width * .45,
                              //   child: DropdownButtonHideUnderline(
                              //     child: DropdownButton2<String>(
                              //       isExpanded: true,
                              //       hint: SizedBox(
                              //         child: Text('Period',
                              //             style: TextStyle(
                              //               fontSize: 14,
                              //             )),
                              //       ),
                              //       items: periods
                              //           .map<DropdownMenuItem<String>>(
                              //               (period) {
                              //         return DropdownMenuItem<String>(
                              //             value: period,
                              //             child: SizedBox(
                              //                 child: Text(period,
                              //                     style: TextStyle(
                              //                       fontSize: 12,
                              //                     ))));
                              //       }).toList(),
                              //       value: selectedPeriod,
                              //       onChanged: (value) {
                              //         setState(() {
                              //           selectedPeriod = value;
                              //         });
                              //       },
                              //       buttonStyleData: ButtonStyleData(
                              //           // height: deviceSize.height * .04,
                              //           // padding: EdgeInsets.only(left: 10, right: 10),
                              //           decoration: BoxDecoration(
                              //               borderRadius:
                              //                   BorderRadius.circular(5),
                              //               border: Border.all(
                              //                   color: Theme.of(context)
                              //                       .colorScheme
                              //                       .secondary))),
                              //     ),
                              //   ),
                              // ),
                              // Text('To'),
                              // SizedBox(width: 10),
                              SizedBox(
                                height: Screen.deviceSize(context).height * .05,
                                width: Screen.deviceSize(context).width * .45,
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    isExpanded: true,
                                    hint: SizedBox(
                                      child: Text('Period',
                                          style: TextStyle(
                                            fontSize: 14,
                                          )),
                                    ),
                                    items: periods
                                        .map<DropdownMenuItem<String>>(
                                            (period) {
                                      return DropdownMenuItem<String>(
                                          value: period,
                                          child: SizedBox(
                                              child: Text(period,
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                  ))));
                                    }).toList(),
                                    value: selectedPeriod,
                                    onChanged: (value) {
                                      setState(() {
                                        selectedPeriod = value;
                                      });
                                    },
                                    // buttonStyleData: ButtonStyleData(
                                    //     // height: deviceSize.height * .04,
                                    //     // padding: EdgeInsets.only(left: 10, right: 10),
                                    //     decoration: BoxDecoration(
                                    //         borderRadius:
                                    //             BorderRadius.circular(5),
                                    //         border: Border.all(
                                    //             color: Theme.of(context)
                                    //                 .colorScheme
                                    //                 .secondary))),
                                  ),
                                ),
                              ),
                            ])
                          ],
                        ))
                      ]))
            ],
          ),
        ),
      ),
    );
  }
}
