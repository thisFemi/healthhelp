import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:HealthHelp/models/user.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multiple_search_selection/helpers/create_options.dart';
import 'package:multiple_search_selection/multiple_search_selection.dart';
import '../api/apis.dart';
import '../helper/dialogs.dart';
import '../helper/utils/Colors.dart';
import '../helper/utils/Common.dart';
import '../helper/utils/contants.dart';

// ignore: must_be_immutable
class EditProfileScreen extends StatefulWidget {
  UserInfo userInfo;
  EditProfileScreen({required this.userInfo});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _keyForm = GlobalKey<FormState>();

  String? _image;
  String initialCountry = 'NG';
  PhoneNumber? number;
  @override
  void initState() {
    super.initState();
    initValues();
  }

  void initValues() {
    if (widget.userInfo.phoneNumber == "" ||
        widget.userInfo.phoneNumber == null) {
      number = PhoneNumber(isoCode: 'NG');
    } else {
      number = parsePhoneNumber(APIs.userInfo.phoneNumber);
    }
    if (widget.userInfo.userType.toLowerCase() == 'doctor') {
      userSpecilizations = widget.userInfo.doctorContactInfo!.specilizations;
      selectedDuration = widget.userInfo.doctorContactInfo!.selectedDuration;
      if (selectedDuration == AvailabilityDuration.aMonth) {
        selectedPeriod =
            periods.firstWhere((period) => period.contains('A Month'));
      } else if (selectedDuration == AvailabilityDuration.twoMonths) {
        selectedPeriod =
            periods.firstWhere((period) => period.contains('Next 2 Month'));
      } else if (selectedDuration == AvailabilityDuration.sixMonths) {
        selectedPeriod =
            periods.firstWhere((period) => period.contains('Next 6 Month'));
      } else if (selectedDuration == AvailabilityDuration.twoMonths) {
        selectedPeriod =
            periods.firstWhere((period) => period.contains('Always Available'));
      } else {
        selectedPeriod =
            periods.firstWhere((period) => period.contains('Not Available'));
      }
      selectedFrom = widget.userInfo.doctorContactInfo!.startTime == ""
          ? workHours[0]
          : widget.userInfo.doctorContactInfo!.startTime;
      selectedTo = widget.userInfo.doctorContactInfo!.endTime == ""
          ? workHours[1]
          : widget.userInfo.doctorContactInfo!.endTime;
      APIs.userInfo.doctorContactInfo!.selectedDuration = selectedDuration!;
      APIs.userInfo.doctorContactInfo!.startTime = selectedFrom!;
      APIs.userInfo.doctorContactInfo!.endTime = selectedTo!;
      APIs.userInfo.doctorContactInfo!.specilizations = userSpecilizations;
    }
  }

  _updateProfileClk() async {
    if (!_keyForm.currentState!.validate()) {
      return;
    }
    if (widget.userInfo.userType.toLowerCase() == "doctor") {
      if (userSpecilizations.isEmpty) {
        Dialogs.showSnackbar(context, 'You need to pick a specilization');
        return;
      }
      if (selectedTo == null ||
          selectedFrom == null ||
          selectedPeriod == null) {
        Dialogs.showSnackbar(
            context, 'You need to set your availability period');
        return;
      }
    }
    Dialogs.showProgressBar(context);
    _keyForm.currentState!.save();
    await APIs.updateUserInfo(context).then((value) {}).catchError((onError) {
      Navigator.pop(context);
      Dialogs.showSnackbar(context, onError);
    });

    Navigator.pop(context);
    Dialogs.showSnackbar(context, 'Profile Updated Successfully');

    Navigator.pop(context, true);
  }

  List<Specialization> userSpecilizations = [];
  final List<Specialization> specialization = [
    Specialization(title: 'Dentist'),
    Specialization(title: 'Surgeon'),
    Specialization(title: 'Pharmacist')
  ];
  String? selectedPeriod;
  AvailabilityDuration? selectedDuration;
  String? selectedFrom;
  String? selectedTo;
  final List<String> periods = [
    'A Month',
    'Next 2 Month',
    'Next 6 Months',
    'Always Available',
    'Not Available'
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
  @override
  Widget build(BuildContext context) {
    // print(userType.$!);
    print('object');
    print(widget.userInfo.userType);
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: color7,
            elevation: 0,
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(CupertinoIcons.back)),
            title: const Text(
              'Edit Profile',
              style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 1),
            ),
            centerTitle: true,
            actions: [
              GestureDetector(
                onTap: () => _updateProfileClk(),
                child: const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Text('Save'),
                ),
              )
            ],
          ),
          body: SingleChildScrollView(
              child: Container(
                  // height: Screen.deviceSize(context).height,
                  padding: const EdgeInsets.only(top: 40, bottom: 20),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Column(
                            children: [
                              Stack(
                                alignment: Alignment.bottomRight,
                                children: [
                                  _image != null
                                      ? InkWell(
                                          onTap: () {
                                            _showBtnSht();
                                          },
                                          borderRadius: BorderRadius.circular(
                                              Screen.deviceSize(context)
                                                      .height *
                                                  .04),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                                Screen.deviceSize(context)
                                                        .height *
                                                    .1),
                                            child: Image.file(
                                              File(_image!),
                                              height: Screen.deviceSize(context)
                                                      .height *
                                                  .12,
                                              width: Screen.deviceSize(context)
                                                      .height *
                                                  .12,
                                              fit: BoxFit.fill,
                                            ),
                                          ))
                                      : InkWell(
                                          onTap: () {
                                            _showBtnSht();
                                          },
                                          borderRadius: BorderRadius.circular(
                                              Screen.deviceSize(context)
                                                      .height *
                                                  .04),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                                Screen.deviceSize(context)
                                                        .height *
                                                    .04),
                                            child: CachedNetworkImage(
                                              height: Screen.deviceSize(context)
                                                      .height *
                                                  .12,
                                              width: Screen.deviceSize(context)
                                                      .height *
                                                  .12,
                                              fit: BoxFit.cover,
                                              imageUrl:
                                                  APIs.userInfo.image ?? "",
                                              errorWidget:
                                                  (context, url, error) =>
                                                      const CircleAvatar(
                                                child:
                                                    Icon(CupertinoIcons.person),
                                              ),
                                            ),
                                          ),
                                        ),
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: Container(
                                      width:
                                          25.0, // Adjust the width as needed for the camera circle
                                      height:
                                          25.0, // Adjust the height as needed for the camera circle
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: Icon(
                                          Icons.camera_alt,
                                          color: color3,
                                          size: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              widget.userInfo.userType.toLowerCase() == 'doctor'
                                  ? Padding(
                                      padding: const EdgeInsets.only(top: 5.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                              '${widget.userInfo.doctorContactInfo!.isVerified ? 'Verified' : 'Unverified'}'),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Icon(
                                            widget.userInfo.doctorContactInfo!
                                                    .isVerified
                                                ? CupertinoIcons
                                                    .checkmark_alt_circle
                                                : Icons.pending_outlined,
                                            color: widget
                                                    .userInfo
                                                    .doctorContactInfo!
                                                    .isVerified
                                                ? color13
                                                : color1,
                                            size: 16,
                                          ),
                                        ],
                                      ),
                                    )
                                  : const SizedBox.shrink()
                            ],
                          ),
                        ),
                        Padding(
                            padding:
                                const EdgeInsets.only(top: 20, left: 10, right: 10),
                            child: Form(
                              key: _keyForm,
                              child: ListView(
                                shrinkWrap: true,
                                children: [
                                  const Text('Full Name'),
                                  const SizedBox(height: 10),
                                  TextFormField(
                                    keyboardType: TextInputType.text,
                                    initialValue: widget.userInfo.name,
                                    onChanged: (newValue) =>
                                        APIs.userInfo.name = newValue ?? '',
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.grey[200],
                                        hintText: 'your name',
                                        hintStyle: TextStyle(color: color8),
                                        labelStyle: TextStyle(
                                            color: color8,
                                            fontFamily: 'Raleway-SemiBold',
                                            fontSize: 15.0),
                                        border: const OutlineInputBorder(
                                            borderSide: BorderSide.none,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10.0))),
                                        enabledBorder: const OutlineInputBorder(
                                            borderSide: BorderSide.none,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10.0))),
                                        focusedBorder: const OutlineInputBorder(
                                            borderSide: BorderSide.none,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10.0))),
                                        errorBorder: const OutlineInputBorder(
                                            borderSide: BorderSide.none,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10.0))),
                                        // focusColor: Colors.grey[300],
                                        contentPadding: const EdgeInsets.all(10),
                                        prefixIcon: const Icon(Icons.person)),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "name can't be empty";
                                      } else if (value.length < 3) {
                                        return "name too short";
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 10),
                                  const Text('Email Address'),
                                  const SizedBox(height: 10),
                                  TextFormField(
                                    keyboardType: TextInputType.emailAddress,
                                    initialValue: widget.userInfo.email,
                                    onSaved: (newValue) =>
                                        APIs.userInfo.email ?? '',
                                    enabled: false,
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.grey[200],
                                        hintStyle: TextStyle(color: color8),
                                        labelStyle: TextStyle(
                                            color: color8,
                                            fontFamily: 'Raleway-SemiBold',
                                            fontSize: 15.0),
                                        border: const OutlineInputBorder(
                                            borderSide: BorderSide.none,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10.0))),
                                        disabledBorder: const OutlineInputBorder(
                                            borderSide: BorderSide.none,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10.0))),
                                        focusedBorder: const OutlineInputBorder(
                                            borderSide: BorderSide.none,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10.0))),
                                        errorBorder: const OutlineInputBorder(
                                            borderSide: BorderSide.none,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10.0))),
                                        contentPadding: const EdgeInsets.all(10),
                                        prefixIcon: const Icon(CupertinoIcons.mail)),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "email can't be empty";
                                      } else if (!value.contains('@')) {
                                        return "invalid email";
                                      }
                                      return null;
                                    },
                                  ),
                                  // ignore: prefer_const_constructors
                                  SizedBox(height: 10),
                                  const Text('Phone Number'),
                                  const SizedBox(height: 10),
                                  InternationalPhoneNumberInput(
                                    spaceBetweenSelectorAndTextField: .1,
                                    inputDecoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.grey[200],
                                      hintStyle: TextStyle(color: color8),
                                      labelStyle: TextStyle(
                                          color: color8,
                                          fontFamily: 'Raleway-SemiBold',
                                          fontSize: 15.0),
                                      border: const OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0))),
                                      disabledBorder: const OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0))),
                                      focusedBorder: const OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0))),
                                      errorBorder: const OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0))),
                                      contentPadding: const EdgeInsets.all(10),
                                    ),
                                    onInputChanged: (PhoneNumber number) {
                                      print(number.phoneNumber);
                                    },
                                    onInputValidated: (bool value) {
                                      print(value);
                                    },
                                    selectorConfig: const SelectorConfig(
                                      selectorType:
                                          PhoneInputSelectorType.BOTTOM_SHEET,
                                    ),
                                    ignoreBlank: false,
                                    autoValidateMode: AutovalidateMode.disabled,
                                    selectorTextStyle:
                                        const TextStyle(color: Colors.black),
                                    initialValue: number,
                                    formatInput: true,
                                    keyboardType:
                                        const TextInputType.numberWithOptions(
                                            signed: true, decimal: true),
                                    inputBorder: const OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10.0))),
                                    onSaved: (PhoneNumber number) {
                                      APIs.userInfo.phoneNumber =
                                          number.toString();
                                    },
                                  ),
                                  const SizedBox(height: 10),
                                  "patient" ==
                                          widget.userInfo.userType.toLowerCase()
                                      ? Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                              const Text('Home Address '),
                                              const SizedBox(height: 10),
                                              TextFormField(
                                                keyboardType:
                                                    TextInputType.text,
                                                initialValue: widget
                                                        .userInfo
                                                        .patientContactInfo!
                                                        .clinicAddress ??
                                                    "",
                                                maxLines: 2,
                                                onSaved: (newValue) => APIs
                                                        .userInfo
                                                        .patientContactInfo!
                                                        .clinicAddress =
                                                    newValue ?? '',
                                                autovalidateMode:
                                                    AutovalidateMode
                                                        .onUserInteraction,
                                                decoration: InputDecoration(
                                                    filled: true,
                                                    fillColor: Colors.grey[200],
                                                    hintStyle: TextStyle(
                                                        color: color8),
                                                    labelStyle: TextStyle(
                                                        color: color8,
                                                        fontFamily:
                                                            'Raleway-SemiBold',
                                                        fontSize: 15.0),
                                                    border: const OutlineInputBorder(
                                                        borderSide:
                                                            BorderSide.none,
                                                        borderRadius: BorderRadius.all(
                                                            Radius.circular(
                                                                10.0))),
                                                    disabledBorder: const OutlineInputBorder(
                                                        borderSide:
                                                            BorderSide.none,
                                                        borderRadius: BorderRadius.all(
                                                            Radius.circular(
                                                                10.0))),
                                                    focusedBorder: const OutlineInputBorder(
                                                        borderSide: BorderSide.none,
                                                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                                                    errorBorder: const OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.all(Radius.circular(10.0))),
                                                    contentPadding: const EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 20),
                                                    prefixIcon: const Icon(CupertinoIcons.home)),
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return "address can't be empty";
                                                  }
                                                  return null;
                                                },
                                              ),
                                            ])
                                      : Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                              MultipleSearchSelection<
                                                  Specialization>.creatable(
                                                title: const Text(
                                                  'Specialization',
                                                ),

                                                onPickedChange: (data) {
                                                  setState(() {
                                                    userSpecilizations = data;
                                                    APIs
                                                            .userInfo
                                                            .doctorContactInfo!
                                                            .specilizations =
                                                        userSpecilizations;
                                                  });
                                                },
                                                initialPickedItems:
                                                    userSpecilizations,
                                                onItemAdded: (c) {},
                                                showClearSearchFieldButton:
                                                    true,
                                                createOptions: CreateOptions(
                                                  createItem: (text) {
                                                    return Specialization(
                                                        title: text);
                                                  },
                                                  onItemCreated: (c) => print(
                                                      'Specilization ${c.title} created'),
                                                  createItemBuilder: (text) =>
                                                      Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Text(
                                                          'Create "$text"'),
                                                    ),
                                                  ),
                                                  pickCreatedItem: false,
                                                ),
                                                items:
                                                    specialization, // List<Country>
                                                fieldToCheck: (c) {
                                                  return c.title;
                                                },
                                                itemBuilder: (country, index) {
                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            6.0),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(6),
                                                        color: Colors.white,
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                          vertical: 20.0,
                                                          horizontal: 12,
                                                        ),
                                                        child:
                                                            Text(country.title),
                                                      ),
                                                    ),
                                                  );
                                                },
                                                pickedItemBuilder: (country) {
                                                  return Container(
                                                    decoration: BoxDecoration(
                                                        color: Colors.black,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5)),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10),
                                                      child: Text(
                                                        country.title,
                                                        style: const TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ),
                                                  );
                                                },
                                                searchFieldInputDecoration:
                                                    InputDecoration(
                                                  filled: true,
                                                  fillColor: Colors.grey[200],
                                                  hintStyle:
                                                      TextStyle(color: color8),
                                                  hintText:
                                                      'Type here to search',
                                                  labelStyle: TextStyle(
                                                      color: color8,
                                                      fontFamily:
                                                          'Raleway-SemiBold',
                                                      fontSize: 15.0),
                                                  border: const OutlineInputBorder(
                                                      borderSide:
                                                          BorderSide.none,
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10.0))),
                                                  disabledBorder:
                                                      const OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide.none,
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius.circular(
                                                                      10.0))),
                                                  focusedBorder:
                                                      const OutlineInputBorder(
                                                          borderSide: BorderSide
                                                              .none,
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius.circular(
                                                                      10.0))),
                                                  errorBorder: const OutlineInputBorder(
                                                      borderSide:
                                                          BorderSide.none,
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10.0))),
                                                  contentPadding:
                                                      const EdgeInsets.all(10),
                                                ),
                                                sortShowedItems: true,
                                                sortPickedItems: true,
                                                selectAllButton: Padding(
                                                  padding: const EdgeInsets.all(
                                                      12.0),
                                                  child: DecoratedBox(
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: Colors.blue),
                                                    ),
                                                    child: const Padding(
                                                      padding:
                                                          EdgeInsets.all(
                                                              8.0),
                                                      child: Text(
                                                        'Select All',
                                                        // style: kStyleDefault,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                clearAllButton: Padding(
                                                  padding: const EdgeInsets.all(
                                                      12.0),
                                                  child: DecoratedBox(
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: Colors.red),
                                                    ),
                                                    child: const Padding(
                                                      padding:
                                                          EdgeInsets.all(
                                                              8.0),
                                                      child: Text(
                                                        'Clear All',
                                                        // style: kStyleDefault,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                caseSensitiveSearch: true,
                                                fuzzySearch: FuzzySearch.none,
                                                itemsVisibility:
                                                    ShowedItemsVisibility
                                                        .onType,
                                                showSelectAllButton: false,
                                                maximumShowItemsHeight:
                                                    Screen.deviceSize(context)
                                                            .height *
                                                        .3,
                                                clearSearchFieldOnSelect: true,
                                                maxSelectedItems: 5,
                                                showItemsButton:
                                                    const Icon(Icons.clear),

                                                // This trailing comma makes auto-formatting nicer for build methods.
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              const Text(
                                                'Schedules',
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Container(
                                                  ////  width: double.infinity,
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  decoration: BoxDecoration(
                                                      color: Colors.grey[200],
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)),
                                                  child: Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              const Text(
                                                                  'Available Period',
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        12,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  )),
                                                              const SizedBox(
                                                                height: 10,
                                                              ),
                                                              SizedBox(
                                                                height: Screen.deviceSize(
                                                                            context)
                                                                        .height *
                                                                    .05,
                                                                width: Screen.deviceSize(
                                                                            context)
                                                                        .width *
                                                                    .3,
                                                                child:
                                                                    DropdownButton2<
                                                                        String>(
                                                                  isExpanded:
                                                                      true,
                                                                  hint:
                                                                      const SizedBox(
                                                                    child: Text(
                                                                        'Period',
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              12,
                                                                        )),
                                                                  ),
                                                                  items: periods.map<
                                                                          DropdownMenuItem<
                                                                              String>>(
                                                                      (period) {
                                                                    return DropdownMenuItem<
                                                                            String>(
                                                                        value:
                                                                            period,
                                                                        child: SizedBox(
                                                                            child: Text(period,
                                                                                style: const TextStyle(
                                                                                  fontSize: 11,
                                                                                ))));
                                                                  }).toList(),
                                                                  value:
                                                                      selectedPeriod,
                                                                  onChanged:
                                                                      (value) {
                                                                    setState(
                                                                        () {
                                                                      selectedPeriod =
                                                                          value;
                                                                      if (value!
                                                                          .contains(
                                                                              'A Month')) {
                                                                        selectedDuration =
                                                                            AvailabilityDuration.aMonth;
                                                                      } else if (value
                                                                          .contains(
                                                                              'Next 2 Month')) {
                                                                        selectedDuration =
                                                                            AvailabilityDuration.twoMonths;
                                                                      } else if (value
                                                                          .contains(
                                                                              'Next 6 Month')) {
                                                                        selectedDuration =
                                                                            AvailabilityDuration.sixMonths;
                                                                      } else if (value
                                                                          .contains(
                                                                              'Always Available')) {
                                                                        selectedDuration =
                                                                            AvailabilityDuration.everyTime;
                                                                      } else {
                                                                        selectedDuration =
                                                                            AvailabilityDuration.notAvailable;
                                                                      }
                                                                    });
                                                                    APIs
                                                                        .userInfo
                                                                        .doctorContactInfo!
                                                                        .selectedDuration = selectedDuration!;
                                                                  },
                                                                  buttonStyleData:
                                                                      ButtonStyleData(
                                                                          // height: deviceSize.height * .04,
                                                                          // padding: EdgeInsets.only(left: 10, right: 10),
                                                                          decoration: BoxDecoration(
                                                                              borderRadius: BorderRadius.circular(5),
                                                                              border: Border.all(color: Theme.of(context).colorScheme.secondary))),
                                                                ),
                                                              ),
                                                            ]),
                                                        const Spacer(),
                                                        selectedDuration !=
                                                                AvailabilityDuration
                                                                    .notAvailable
                                                            ? Container(
                                                                margin:
                                                                    const EdgeInsets
                                                                        .only(
                                                                  left: 10,
                                                                ),
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    const Text(
                                                                        'Daily Time Availability',
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              12,
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                        )),
                                                                    const SizedBox(
                                                                      height:
                                                                          10,
                                                                    ),
                                                                    Row(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          SizedBox(
                                                                            height:
                                                                                Screen.deviceSize(context).height * .05,
                                                                            width:
                                                                                Screen.deviceSize(context).width * .26,
                                                                            child:
                                                                                DropdownButtonHideUnderline(
                                                                              child: DropdownButton2<String>(
                                                                                isExpanded: true,
                                                                                hint: const SizedBox(
                                                                                  child: Text('From',
                                                                                      style: TextStyle(
                                                                                        fontSize: 12,
                                                                                      )),
                                                                                ),
                                                                                items: workHours.map<DropdownMenuItem<String>>((period) {
                                                                                  return DropdownMenuItem<String>(
                                                                                      value: period,
                                                                                      child: SizedBox(
                                                                                          child: Text(period,
                                                                                              style: const TextStyle(
                                                                                                fontSize: 11,
                                                                                              ))));
                                                                                }).toList(),
                                                                                value: selectedFrom,
                                                                                onChanged: (value) {
                                                                                  setState(() {
                                                                                    selectedFrom = value;

                                                                                    selectedTo = null;
                                                                                  });
                                                                                  APIs.userInfo.doctorContactInfo!.startTime = selectedFrom!;
                                                                                },
                                                                                buttonStyleData: ButtonStyleData(
                                                                                    // height: deviceSize.height * .04,
                                                                                    // padding: EdgeInsets.only(left: 10, right: 10),
                                                                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(color: Theme.of(context).colorScheme.secondary))),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          const SizedBox(
                                                                              width: 10),
                                                                          SizedBox(
                                                                            height:
                                                                                Screen.deviceSize(context).height * .05,
                                                                            width:
                                                                                Screen.deviceSize(context).width * .26,
                                                                            child:
                                                                                DropdownButtonHideUnderline(
                                                                              child: DropdownButton2<String>(
                                                                                isExpanded: true,
                                                                                hint: const SizedBox(
                                                                                  child: Text('To',
                                                                                      style: TextStyle(
                                                                                        fontSize: 14,
                                                                                      )),
                                                                                ),
                                                                                items: (workHours.indexOf(selectedFrom!) != workHours.length - 1)
                                                                                    ? workHours.where((period) => workHours.indexOf(period) > workHours.indexOf(selectedFrom!)).map<DropdownMenuItem<String>>((period) {
                                                                                        return DropdownMenuItem<String>(
                                                                                          value: period,
                                                                                          child: SizedBox(
                                                                                            child: Text(
                                                                                              period,
                                                                                              style: const TextStyle(
                                                                                                fontSize: 12,
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        );
                                                                                      }).toList()
                                                                                    : [],
                                                                                value: selectedTo,
                                                                                onChanged: (value) {
                                                                                  setState(() {
                                                                                    selectedTo = value;
                                                                                  });
                                                                                  APIs.userInfo.doctorContactInfo!.endTime = selectedTo!;
                                                                                },
                                                                                buttonStyleData: ButtonStyleData(
                                                                                    // height: deviceSize.height * .04,
                                                                                    // padding: EdgeInsets.only(left: 10, right: 10),
                                                                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(color: Theme.of(context).colorScheme.secondary))),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ]),
                                                                  ],
                                                                ))
                                                            : const SizedBox.shrink()
                                                      ])),
                                              const SizedBox(height: 10),
                                              const Text('Office/Hospital Address '),
                                              const SizedBox(height: 10),
                                              TextFormField(
                                                keyboardType:
                                                    TextInputType.text,
                                                initialValue: widget
                                                        .userInfo
                                                        .doctorContactInfo!
                                                        .clinicAddress ??
                                                    "",
                                                maxLines: 2,
                                                onSaved: (newValue) => APIs
                                                        .userInfo
                                                        .doctorContactInfo!
                                                        .clinicAddress =
                                                    newValue ?? '',
                                                autovalidateMode:
                                                    AutovalidateMode
                                                        .onUserInteraction,
                                                decoration: InputDecoration(
                                                    filled: true,
                                                    fillColor: Colors.grey[200],
                                                    hintStyle: TextStyle(
                                                        color: color8),
                                                    labelStyle: TextStyle(
                                                        color: color8,
                                                        fontFamily:
                                                            'Raleway-SemiBold',
                                                        fontSize: 15.0),
                                                    border: const OutlineInputBorder(
                                                        borderSide:
                                                            BorderSide.none,
                                                        borderRadius: BorderRadius.all(
                                                            Radius.circular(
                                                                10.0))),
                                                    disabledBorder: const OutlineInputBorder(
                                                        borderSide:
                                                            BorderSide.none,
                                                        borderRadius: BorderRadius.all(
                                                            Radius.circular(
                                                                10.0))),
                                                    focusedBorder: const OutlineInputBorder(
                                                        borderSide: BorderSide.none,
                                                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                                                    errorBorder: const OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.all(Radius.circular(10.0))),
                                                    contentPadding: const EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 20),
                                                    prefixIcon: const Icon(CupertinoIcons.home)),
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return "address can't be empty";
                                                  }
                                                  return null;
                                                },
                                              ),
                                            ]),
                                  const SizedBox(height: 10),
                                ],
                              ),
                            ))
                      ])))),
    );
  }

  void _showBtnSht() {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        builder: (_) => ListView(
              shrinkWrap: true,
              padding: EdgeInsets.only(
                  top: Screen.deviceSize(context).height * 0.03,
                  bottom: Screen.deviceSize(context).height * 0.05),
              children: [
                const Text(
                  'Pick Profile Picture',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: Screen.deviceSize(context).height * 0.02,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: const CircleBorder(),
                            fixedSize: Size(
                              Screen.deviceSize(context).width * .3,
                              Screen.deviceSize(context).height * .15,
                            )),
                        onPressed: () async {
                          final ImagePicker picker = ImagePicker();

                          final XFile? image = await picker.pickImage(
                              source: ImageSource.gallery, imageQuality: 80);
                          if (image != null) {
                            log('Image Path :${image.path}');
                            setState(() {
                              _image = image.path;
                            });
                            APIs.updateProfilePicture(context, File(_image!));
                            Navigator.pop(context);
                          }
                        },
                        child: Image.asset('assets/images/add_image.png')),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: const CircleBorder(),
                            fixedSize: Size(
                              Screen.deviceSize(context).width * .3,
                              Screen.deviceSize(context).height * .15,
                            )),
                        onPressed: () async {
                          final ImagePicker picker = ImagePicker();

                          final XFile? image = await picker.pickImage(
                              source: ImageSource.camera, imageQuality: 80);
                          if (image != null) {
                            log('Image Path :${image.path}');
                            setState(() {
                              _image = image.path;
                            });
                            APIs.updateProfilePicture(context, File(_image!));
                            Navigator.pop(context);
                          }
                        },
                        child: Image.asset('assets/images/camera.png'))
                  ],
                )
              ],
            ));
  }
}
