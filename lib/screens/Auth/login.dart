import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:HealthHelp/api/apis.dart';
import 'package:HealthHelp/screens/Auth/register.dart';

import '../../helper/dialogs.dart';
import '../../helper/utils/Colors.dart';
import '../../helper/utils/Common.dart';
import '../../helper/utils/Images.dart';
import '../../helper/utils/Routes.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _keyForm = GlobalKey<FormState>();
  bool _showPassword = false;
  bool _ggBtnisLoading = false;
  bool _isLoading = false;
  TextEditingController _username = TextEditingController();
  TextEditingController _password = TextEditingController();
  _hangleGoogleBtnClick() async {
    Dialogs.showProgressBar(context);
    //  _sigOut();
    await APIs.signInWithGoogle(context);
    Navigator.pop(context);
  }

  _handleEmailPasswordLogin() async {
    FocusScope.of(context).unfocus();
    try {
      if (!_keyForm.currentState!.validate()) {
        // Sign in with email and password}
        return;
      }
      setState(() {
        _isLoading = true;
      });
      _keyForm.currentState!.save();
      String email = _username.text;
      String password = _password.text;
      await APIs.signInEmailPasswordLogin(email, password, context);

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print('signInWithEmailAndPassword: ${e}');
      Dialogs.showSnackbar(context, 'Login failed, check your credentials.');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _username.text = '';
    _password.text = '';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: SafeArea(
        child: Scaffold(
          extendBodyBehindAppBar: true,
          body: SingleChildScrollView(
            child: Container(
              height: displaySize.height,
              width: displaySize.width,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                      fit: BoxFit.fill,
                      image: AssetImage('assets/images/bg.png'))),
              child: Center(
                child: SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.only(
                        left: 20, right: 20, top: 20, bottom: 20),
                    margin: EdgeInsets.symmetric(
                      vertical: displaySize.height * .15,
                    ),
                    width: displaySize.width * .85,
                    decoration: BoxDecoration(
                      color: color7,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Log In',
                          style: TextStyle(
                              fontSize: 32, fontWeight: FontWeight.bold),
                        ),
                        Padding(
                            padding: EdgeInsets.only(top: 20),
                            child: Form(
                                key: _keyForm,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                          right: 1,
                                          left: 1,
                                          top: 12,
                                          bottom: 10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text('Email'),
                                          SizedBox(height: 5),
                                          TextFormField(
                                            keyboardType:
                                                TextInputType.emailAddress,
                                            autovalidateMode: AutovalidateMode
                                                .onUserInteraction,
                                            controller: _username,
                                            decoration: InputDecoration(
                                                filled: true,
                                                fillColor: Colors.grey[200],
                                                hintStyle:
                                                    TextStyle(color: color8),
                                                hintText: "Email/Username",
                                                counterStyle: TextStyle(
                                                    height: double.minPositive),
                                                labelStyle: TextStyle(
                                                    color: color8,
                                                    fontFamily:
                                                        'Raleway-SemiBold',
                                                    fontSize: 15.0),
                                                border: OutlineInputBorder(
                                                    borderSide: BorderSide.none,
                                                    borderRadius: BorderRadius.all(
                                                        Radius.circular(10.0))),
                                                enabledBorder: OutlineInputBorder(
                                                    borderSide: BorderSide.none,
                                                    borderRadius: BorderRadius.all(
                                                        Radius.circular(10.0))),
                                                focusedBorder: OutlineInputBorder(
                                                    borderSide: BorderSide.none,
                                                    borderRadius: BorderRadius.all(
                                                        Radius.circular(10.0))),
                                                errorBorder: OutlineInputBorder(
                                                    borderSide: BorderSide.none,
                                                    borderRadius: BorderRadius.all(
                                                        Radius.circular(10.0))),
                                                contentPadding: EdgeInsets.all(10),
                                                prefixIcon: Icon(Icons.person)),
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty ||
                                                  !value.contains('@')) {
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
                                          right: 1, left: 1, top: 5, bottom: 5),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text('Password'),
                                          SizedBox(height: 5),
                                          TextFormField(
                                            keyboardType: TextInputType.text,
                                            autovalidateMode: AutovalidateMode
                                                .onUserInteraction,
                                            obscureText: !_showPassword,
                                            controller: _password,
                                            decoration: InputDecoration(
                                                filled: true,
                                                fillColor: Colors.grey[200],
                                                hintStyle:
                                                    TextStyle(color: color8),
                                                hintText: "Password",
                                                counterStyle: TextStyle(
                                                    height: double.minPositive),
                                                counterText: "",
                                                labelStyle: TextStyle(
                                                    color: color8,
                                                    fontFamily:
                                                        'Raleway-SemiBold',
                                                    fontSize: 15.0),
                                                border: OutlineInputBorder(
                                                    borderSide: BorderSide.none,
                                                    borderRadius: BorderRadius.all(
                                                        Radius.circular(10.0))),
                                                enabledBorder: OutlineInputBorder(
                                                    borderSide: BorderSide.none,
                                                    borderRadius: BorderRadius.all(
                                                        Radius.circular(10.0))),
                                                focusedBorder: OutlineInputBorder(
                                                    borderSide: BorderSide.none,
                                                    borderRadius: BorderRadius.all(
                                                        Radius.circular(10.0))),
                                                errorBorder: OutlineInputBorder(
                                                    borderSide: BorderSide.none,
                                                    borderRadius: BorderRadius.all(
                                                        Radius.circular(10.0))),
                                                contentPadding:
                                                    EdgeInsets.all(10),
                                                prefixIcon: Icon(Icons.lock),
                                                suffixIcon: IconButton(
                                                  icon: Icon(_showPassword
                                                      ? Icons.visibility_off
                                                      : Icons.visibility),
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
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: GestureDetector(
                                          onTap: () {},
                                          child: Text(
                                            'Forgot Password',
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.teal,
                                                fontWeight: FontWeight.w400),
                                          )),
                                    ),
                                    Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 20.0),
                                        child: SizedBox(
                                            height: 50.0,
                                            width: displaySize.width,
                                            child: TextButton(
                                              onPressed: () {
                                                _handleEmailPasswordLogin();
                                              },
                                              style: TextButton.styleFrom(
                                                backgroundColor: color15,
                                              ),
                                              child: _isLoading
                                                  ? SpinKitFadingCircle(
                                                      color: color3,
                                                      size: 30,
                                                    )
                                                  : Text('Login',
                                                      style: TextStyle(
                                                          color: color3,
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                            ))),
                                    GestureDetector(
                                        onTap: () {
                                          Routes(context: context)
                                              .navigate(RegistrationScreen());
                                        },
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "Don't have an account?",
                                              style: TextStyle(
                                                color: color3,
                                              ),
                                            ),
                                            Text(
                                              "Register",
                                              style: TextStyle(
                                                  color: color3,
                                                  fontWeight: FontWeight.w800),
                                            ),
                                          ],
                                        )),
                                    Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 20.0),
                                        child: SizedBox(
                                            height: 50.0,
                                            width: displaySize.width,
                                            child: TextButton(
                                              onPressed: () {
                                                _hangleGoogleBtnClick();
                                              },
                                              style: TextButton.styleFrom(
                                                backgroundColor: color3,
                                              ),
                                              child: _ggBtnisLoading
                                                  ? SpinKitFadingCircle(
                                                      color: color7,
                                                      size: 30,
                                                    )
                                                  : Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        SizedBox(
                                                            height: 20,
                                                            width: 20,
                                                            child: Image.asset(
                                                                gg_logo)),
                                                        SizedBox(
                                                          width: 20,
                                                        ),
                                                        Text(
                                                            'Sign In With Google',
                                                            style: TextStyle(
                                                                color: color5,
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                      ],
                                                    ),
                                            ))),
                                  ],
                                )))
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
