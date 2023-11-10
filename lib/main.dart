import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:HealthHelp/firebase_options.dart';
import 'package:HealthHelp/screens/init/splash_screen.dart';
import 'package:HealthHelp/helper/utils/Colors.dart';
import 'package:flutter_notification_channel/flutter_notification_channel.dart';
import 'package:flutter_notification_channel/notification_importance.dart';

import 'widgets/error_widget.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  var result = await FlutterNotificationChannel.registerNotificationChannel(
    description: 'For showing message nofitications',
    id: 'chats',
    importance: NotificationImportance.IMPORTANCE_HIGH,
    name: 'Chats',
  );
  print('notification channel result: ${result}');

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
      home: SplashScreen(),
    );
  }
}

_initializeFirebase() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}
