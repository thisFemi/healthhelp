import 'package:flutter/material.dart';
import 'package:HealthHelp/screens/Auth/register.dart';

import '../../helper/utils/Colors.dart';
import '../../helper/utils/Images.dart';
import '../../helper/utils/Routes.dart';
import '../../widgets/onboarding_slide.dart';
import '../Auth/login.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  final List<Map<String, String>> _slides = [
    {
      'title': 'Easy Registration',
      'description':
          'Students and Staff can do all necessary registration from the comfort of their home.',
      'image': 'assets/images/onboard1.png',
    },
    {
      'title': 'Appointment Schedule',
      'description':
          'Students and Staff can do all necessary registration from the comfort of their home.',
      'image': 'assets/images/onboard2.png',
    },
    {
      'title': 'Easy Registration',
      'description':
          'Students and Staff can do all necessary registration from the comfort of their home.',
      'image': 'assets/images/onboard3.png',
    }
  ];
  void _onPageChanges(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  void _navigateToNext() {
    if (_currentPage < _slides.length - 1) {
      _pageController.nextPage(
          duration: Duration(milliseconds: 500), curve: Curves.easeInCirc);
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                        height: 40,
                        width: 60,
                        child: Image.asset(
                          logo,
                        )),
                    Text(
                      'Health-Help',
                      style: TextStyle(
                        fontSize: 28.0,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
              ),
            ),
            Expanded(
                child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: _onPageChanges,
                    itemCount: _slides.length,
                    itemBuilder: (context, index) {
                      return OnboardingSlide(
                        title: _slides[index]['title']!,
                        description: _slides[index]['description']!,
                        image: _slides[index]['image']!,
                      );
                    })),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _buildPageIndicator(),
            ),
            SizedBox(height: 200.0),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: InkWell(
           borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
              topRight: Radius.circular(10)),
                    onTap: () =>
                        Routes(context: context).navigate(LoginScreen()),
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                          color: color15,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                              topRight: Radius.circular(10))),
                      child: Center(
                          child: Text(
                        'Log in',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: color3),
                      )),
                    ),
                  ),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: InkWell(
                  borderRadius: BorderRadius.only(
    topLeft: Radius.circular(10),
    bottomRight: Radius.circular(10),
    topRight: Radius.circular(10)),
                    onTap: () =>
                        Routes(context: context).navigate(RegistrationScreen()),
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                          color: color3,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                              topRight: Radius.circular(10))),
                      child: Center(
                          child: Text(
                        'Register',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: color7),
                      )),
                    ),
                  ),
                ),
              ],
            ),
            // ElevatedButton(
            //     onPressed: _navigateToNext,
            //     child: Text(
            //       _currentPage < _slides.length - 1 ? 'Next' : 'GetStarted',
            //       style: TextStyle(fontSize: 16),
            //     )),
            SizedBox(
              height: 20.0,
            )
          ],
        ),
      )),
    );
  }

  List<Widget> _buildPageIndicator() {
    List<Widget> indicators = [];
    for (int i = 0; i < _slides.length; i++) {
      indicators.add(i == _currentPage ? _indicator(true) : _indicator(false));
    }
    return indicators;
  }

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: Duration(microseconds: 150),
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      height: 3,
      width: isActive ? 24.0 : 16.0,
      decoration: BoxDecoration(
          color: isActive ? color15 : color8,
          borderRadius: BorderRadius.circular(4.0)),
    );
  }
}
