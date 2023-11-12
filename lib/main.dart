import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:HealthHelp/firebase_options.dart';
import 'package:HealthHelp/screens/init/splash_screen.dart';
import 'package:HealthHelp/helper/utils/Colors.dart';
import 'package:flutter_notification_channel/flutter_notification_channel.dart';
import 'package:flutter_notification_channel/notification_importance.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'api/apis.dart';
import 'widgets/error_widget.dart';
Future<void> _firebaseMessagingBackgroundHandler(message) async {
  await Firebase.initializeApp();

  print('Handling a background message ${message.messageId}');
}
final navigattorKey=GlobalKey<NavigatorState>();


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await APIs().initNofication();

  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
      Widget error =
      Text('......rendering error....: ${errorDetails.summary}');
      // if (child is Scaffold || child is Navigator) {
      //   error = Scaffold(
      //     body: Center(
      //       child: error,
      //     ),
      //   );
      // }
      return ErrorScreen(label: "Sorry, Page not found 😔",);
    };
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: color7,
        systemNavigationBarColor: color7,
        statusBarIconBrightness: Brightness.light));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Health-Help ',
      theme: ThemeData(primarySwatch: Colors.cyan, fontFamily: 'Raleway'),
        navigatorKey:navigattorKey,
      home: SplashScreen(),
    );
  }
}

_initializeFirebase() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}
