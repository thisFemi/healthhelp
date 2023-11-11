import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:HealthHelp/api/apis.dart';
import 'package:HealthHelp/screens/Auth/login.dart';
import 'package:HealthHelp/helper/utils/Common.dart';

import '../../helper/dialogs.dart';
import '../../helper/utils/Colors.dart';

import '../../helper/utils/Routes.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _keyForm = GlobalKey<FormState>();
  TextEditingController _name = TextEditingController();
  TextEditingController _email = TextEditingController();

  TextEditingController _password = TextEditingController();
  TextEditingController _usertType = TextEditingController();
  TextEditingController _confirmPassword = TextEditingController();

  bool _showPassword = false;
  bool _isLoading = false;
  String selectedType = '';

  _handleEmailPasswordRegister() async {
    FocusScope.of(context).unfocus();
    try {
      if (!_keyForm.currentState!.validate()) {
        return;
      }
      _keyForm.currentState!.save();
      setState(() {
        _isLoading = true;
      });
      String name = _name.text;
      String email = _email.text;
      String password = _password.text;
      String userType =
          selectedType.toLowerCase() == 'patient' ? 'patient' : 'doctor';

      await APIs.registerWithEmailAndPassword(
          name, email, password, userType, context);

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print('signInWithEmailAndPassword: ${e}');
      Dialogs.showSnackbar(context, 'Registration failed, ${e.toString()}');
      setState(() {
        _isLoading = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    _usertType.text = selectedType;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SafeArea(
        child: Scaffold(
          extendBodyBehindAppBar: true,
          body: SingleChildScrollView(
            child: Container(
              width: displaySize.width,
              height:  displaySize.height,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.fill,
                      image: AssetImage('assets/images/bg5.png'))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      top: 10,
                    ),
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: Icon(
                            CupertinoIcons.back,
                            color: const Color.fromARGB(255, 33, 43, 42),
                            size: 20,
                          ),
                        )),
                  ),
                  Center(
                    child: SingleChildScrollView(
                      child: Container(
                        padding: EdgeInsets.only(
                          left: 20,
                          top: 20,
                          right: 20,
                        ),
                        margin:
                            EdgeInsets.only(bottom: displaySize.height * .025),
                        width: displaySize.width * .9,
                        decoration: BoxDecoration(
                            color: color7,
                            borderRadius: BorderRadius.circular(5)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Sign Up',
                                  style: TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 10.0),
                                  child: Text(
                                    'Registration',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: color8),
                                  ),
                                ),
                                Padding(
                                    padding: EdgeInsets.only(top: 20),
                                    child: Form(
                                        key: _keyForm,
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: 1,
                                                  top: 10,
                                                  bottom: 10,
                                                  right: 1),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text('Full Name', style: TextStyle(fontWeight:FontWeight.bold),),
                                                  SizedBox(height: 5),
                                                  TextFormField(
                                                    controller: _name,
                                                    autovalidateMode:
                                                        AutovalidateMode
                                                            .onUserInteraction,
                                                    decoration: InputDecoration(
                                                        filled: true,
                                                        fillColor:
                                                            Colors.grey[200],
                                                        hintStyle: TextStyle(
                                                            color: color8,
                                                            fontSize: 12),
                                                        hintText:
                                                            "enter your name",
                                                        counterStyle: TextStyle(
                                                            height: double
                                                                .minPositive),
                                                        labelStyle: TextStyle(
                                                            color: color8,
                                                            fontFamily:
                                                                'Raleway-SemiBold',
                                                            fontSize: 15.0),
                                                        border: OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide.none,
                                                            borderRadius:
                                                                BorderRadius.all(
                                                                    Radius.circular(
                                                                        10.0))),
                                                        enabledBorder: OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide.none,
                                                            borderRadius:
                                                                BorderRadius.all(
                                                                    Radius.circular(10.0))),
                                                        focusedBorder: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.all(Radius.circular(10.0))),
                                                        errorBorder: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.all(Radius.circular(10.0))),
                                                        contentPadding: EdgeInsets.all(10),
                                                        prefixIcon: Icon(Icons.person)),
                                                    validator: (value) {
                                                      if (value == null ||
                                                          value.isEmpty ||
                                                          value.length < 3) {
                                                        return 'name is too  short or empty';
                                                      }
                                                      return null;
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: 1,
                                                  top: 5,
                                                  bottom: 10,
                                                  right: 1),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text('Email', style: TextStyle(fontWeight:FontWeight.bold),),
                                                  SizedBox(height: 5),
                                                  TextFormField(
                                                    keyboardType: TextInputType
                                                        .emailAddress,
                                                    controller: _email,
                                                    autovalidateMode:
                                                        AutovalidateMode
                                                            .onUserInteraction,
                                                    decoration: InputDecoration(
                                                        filled: true,
                                                        fillColor:
                                                            Colors.grey[200],
                                                        hintStyle: TextStyle(
                                                            color: color8,
                                                            fontSize: 12),
                                                        hintText:
                                                            "enter your email",
                                                        counterStyle: TextStyle(
                                                            height: double
                                                                .minPositive),
                                                        labelStyle: TextStyle(
                                                            color: color8,
                                                            fontFamily:
                                                                'Raleway-SemiBold',
                                                            fontSize: 15.0),
                                                        border: OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide.none,
                                                            borderRadius:
                                                                BorderRadius.all(
                                                                    Radius.circular(
                                                                        10.0))),
                                                        enabledBorder: OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide.none,
                                                            borderRadius:
                                                                BorderRadius.all(
                                                                    Radius.circular(10.0))),
                                                        focusedBorder: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.all(Radius.circular(10.0))),
                                                        errorBorder: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.all(Radius.circular(10.0))),
                                                        contentPadding: EdgeInsets.all(10),
                                                        prefixIcon: Icon(Icons.mail)),
                                                    validator: (value) {
                                                      if (value == null ||
                                                          value.isEmpty ||
                                                          !value
                                                              .contains('@')) {
                                                        return 'invalid email';
                                                      }
                                                      return null;
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                left: 1,
                                                top: 5,
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text('Account Type', style: TextStyle(fontWeight:FontWeight.bold),),
                                                  SizedBox(height: 5),
                                                  GestureDetector(
                                                    onTap: () =>
                                                        _showUsertTypes(),
                                                    child: AbsorbPointer(
                                                      child: TextFormField(
                                                        controller: _usertType,
                                                        autovalidateMode:
                                                            AutovalidateMode
                                                                .onUserInteraction,
                                                        decoration: InputDecoration(

                                                            filled: true,
                                                            fillColor: Colors
                                                                .grey[200],
                                                            hintStyle: TextStyle(
                                                                color: color8,
                                                                fontSize: 12),
                                                            hintText:
                                                                "select your user type",
                                                            counterStyle: TextStyle(
                                                                height: double
                                                                    .minPositive),
                                                            labelStyle: TextStyle(
                                                                color: color8,
                                                                fontFamily:
                                                                    'Raleway-SemiBold',
                                                                fontSize: 15.0),
                                                            border: OutlineInputBorder(
                                                                borderSide:
                                                                    BorderSide
                                                                        .none,
                                                                borderRadius:
                                                                    BorderRadius.all(
                                                                        Radius.circular(
                                                                            10.0))),
                                                            disabledBorder:
                                                                OutlineInputBorder(
                                                                    borderSide:
                                                                        BorderSide
                                                                            .none,
                                                                    borderRadius:
                                                                        BorderRadius.all(Radius.circular(10.0))),
                                                            focusedBorder: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.all(Radius.circular(10.0))),
                                                            errorBorder: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.all(Radius.circular(10.0))),
                                                            contentPadding: EdgeInsets.all(10),
                                                            prefixIcon: Icon(Icons.person),
                                                            suffixIcon: Icon(Icons.keyboard_arrow_down_outlined)),
                                                        validator: (value) {
                                                          if (value == null ||
                                                              value.isEmpty ||
                                                              selectedType ==
                                                                  '') {
                                                            return 'you need to select a user type';
                                                          }
                                                          return null;
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),

                                            Padding(
                                              padding: EdgeInsets.only(
                                                right: 1,
                                                left: 1,
                                                top: 5,
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text('Password', style: TextStyle(fontWeight:FontWeight.bold),),
                                                  SizedBox(height: 5),
                                                  TextFormField(
                                                    keyboardType:
                                                        TextInputType.text,
                                                    controller: _password,
                                                    autovalidateMode:
                                                        AutovalidateMode
                                                            .onUserInteraction,
                                                    obscureText: !_showPassword,
                                                    decoration: InputDecoration(
                                                        filled: true,
                                                        fillColor:
                                                            Colors.grey[200],
                                                        hintStyle: TextStyle(
                                                            color: color8,
                                                            fontSize: 12),
                                                        hintText:
                                                            "enter your password",
                                                        contentPadding:
                                                            EdgeInsets.all(10),
                                                        counterStyle: TextStyle(
                                                            height: double
                                                                .minPositive),
                                                        labelStyle: TextStyle(
                                                            color: color8,
                                                            fontFamily:
                                                                'Raleway-SemiBold',
                                                            fontSize: 15.0),
                                                        border: OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide.none,
                                                            borderRadius:
                                                                BorderRadius.all(
                                                                    Radius.circular(
                                                                        10.0))),
                                                        disabledBorder:
                                                            OutlineInputBorder(
                                                                borderSide:
                                                                    BorderSide
                                                                        .none,
                                                                borderRadius:
                                                                    BorderRadius.all(
                                                                        Radius.circular(10.0))),
                                                        focusedBorder: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.all(Radius.circular(10.0))),
                                                        errorBorder: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.all(Radius.circular(10.0))),
                                                        prefixIcon: Icon(
                                                          Icons.lock,
                                                          size: 18,
                                                        ),
                                                        suffixIcon: IconButton(
                                                          icon: Icon(
                                                            _showPassword
                                                                ? Icons
                                                                    .visibility_off
                                                                : Icons
                                                                    .visibility,
                                                            size: 18,
                                                          ),
                                                          onPressed: () {
                                                            setState(() {
                                                              _showPassword =
                                                                  !_showPassword;
                                                            });
                                                          },
                                                        )),
                                                    validator: (value) {
                                                      if (value == null ||
                                                          value.isEmpty ||
                                                          value.length < 5) {
                                                        return 'invalid password';
                                                      }
                                                      return null;
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                right: 1,
                                                left: 1,
                                                top: 5,
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text('Confirm Password', style: TextStyle(fontWeight:FontWeight.bold),),
                                                  SizedBox(height: 5),
                                                  TextFormField(
                                                    keyboardType:
                                                        TextInputType.text,
                                                    controller:
                                                        _confirmPassword,
                                                    obscureText: !_showPassword,
                                                    decoration: InputDecoration(
                                                        filled: true,
                                                        fillColor:
                                                            Colors.grey[200],
                                                        hintStyle: TextStyle(
                                                            color: color8,
                                                            fontSize: 12),
                                                        hintText:
                                                            "confirm your password",
                                                        contentPadding:
                                                            EdgeInsets.all(10),
                                                        counterStyle: TextStyle(
                                                            height: double
                                                                .minPositive),
                                                        labelStyle: TextStyle(
                                                            color: color8,
                                                            fontFamily:
                                                                'Raleway-SemiBold',
                                                            fontSize: 15.0),
                                                        border: OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide.none,
                                                            borderRadius:
                                                                BorderRadius.all(
                                                                    Radius.circular(
                                                                        10.0))),
                                                        disabledBorder:
                                                            OutlineInputBorder(
                                                                borderSide:
                                                                    BorderSide
                                                                        .none,
                                                                borderRadius:
                                                                    BorderRadius.all(
                                                                        Radius.circular(10.0))),
                                                        focusedBorder: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.all(Radius.circular(10.0))),
                                                        errorBorder: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.all(Radius.circular(10.0))),
                                                        prefixIcon: Icon(
                                                          Icons.lock,
                                                          size: 18,
                                                        ),
                                                        suffixIcon: IconButton(
                                                          icon: Icon(
                                                            _showPassword
                                                                ? Icons
                                                                    .visibility_off
                                                                : Icons
                                                                    .visibility,
                                                            size: 18,
                                                          ),
                                                          onPressed: () {
                                                            setState(() {
                                                              _showPassword =
                                                                  !_showPassword;
                                                            });
                                                          },
                                                        )),
                                                    validator: (value) {
                                                      if (value !=
                                                          _password.text) {
                                                        return 'password dose not match';
                                                      }
                                                      return null;
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 40.0),
                                                child: SizedBox(
                                                    height: 50.0,
                                                    width: displaySize.width,
                                                    child: TextButton(
                                                      onPressed:_isLoading?null: () {
                                                        _handleEmailPasswordRegister();
                                                      },
                                                      style:
                                                          TextButton.styleFrom(
                                                        backgroundColor:
                                                            color15,
                                                      ),
                                                      child: _isLoading
                                                          ? SpinKitFadingCircle(
                                                              color: color3,
                                                              size: 30,
                                                            )
                                                          : Text('Register',
                                                              style: TextStyle(
                                                                  color: color3,
                                                                  fontSize: 18,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold)),
                                                    ))),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 10, bottom: 20),
                                              child: GestureDetector(
                                                  onTap: () {
                                                    Routes(context: context)
                                                        .navigate(
                                                            LoginScreen());
                                                  },
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        "Already have an account?",
                                                        style: TextStyle(
                                                          color: color3,
                                                        ),
                                                      ),
                                                      Text(
                                                        "Login",
                                                        style: TextStyle(
                                                            color: color3,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w800),
                                                      ),
                                                    ],
                                                  )),
                                            ),
                                          ],
                                        )))
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showUsertTypes() {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        builder: (_) => Wrap(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Text(
                      'Select Type',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                ),
                ListView(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  shrinkWrap: true,
                  children: [
                    ListTile(
                      leading: Icon(Icons.person),
                      title: Text('Patient'),
                      onTap: () {
                        setState(() {
                          selectedType = 'Patient';
                        });
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      onTap: () {
                        setState(() {
                          selectedType = 'Medical Practitioner';
                        });
                        Navigator.pop(context);
                      },
                      leading: Icon(Icons.people),
                      title: Text('Medical Practitioner'),
                    )
                  ],
                )
              ],
            ));
  }
}
