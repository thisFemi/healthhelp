// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:HealthHelp/main.dart';
import 'package:HealthHelp/providers/DUMMY_DATA.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_notification_channel/flutter_notification_channel.dart';
import 'package:flutter_notification_channel/notification_importance.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:HealthHelp/models/message.dart';
import 'package:HealthHelp/screens/Auth/register.dart';
import 'package:http/http.dart' as http;

import '../helper/dialogs.dart';

import '../helper/utils/prefs.dart';
import '../models/appointment.dart';
import '../models/others.dart';
import '../models/user.dart' as user_model;
import '../models/user.dart';
import '../screens/Auth/login.dart';
import '../screens/dashboard.dart';

class APIs {
  static FirebaseAuth auth = FirebaseAuth.instance;
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  static FirebaseStorage storage = FirebaseStorage.instance;
  static String userId = auth.currentUser!.uid;
  static FirebaseMessaging fMessaging = FirebaseMessaging.instance;

  static Future<bool> hasNetwork() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
        isConnected = true;
        return true;
      }
    } on SocketException catch (_) {
      print('not connected');
    }

    return false;
  }

   Future<void> initNofication()async{


    initPushNotifiation();
    registerChannel();
  }

  void handleMessage(RemoteMessage? message)async{
    if(message==null)return;
    print("gotten");
  }

Future initPushNotifiation() async{
    fMessaging.getInitialMessage().then(handleMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
    //FirebaseMessaging.onBackgroundMessage(backgroundHandler);
}
Future<void> registerChannel()async{
  await FlutterNotificationChannel.registerNotificationChannel(
    description: 'For showing message nofitications',
    id: 'chats',
    importance: NotificationImportance.IMPORTANCE_HIGH,
    name: 'Chats',
  );
  print('channel register');
}

  static Future<void> getFirebaseMessagingToken() async {
    await fMessaging.requestPermission();
    fMessaging.getToken().then((token) {
      if (token != null) {
        print(token);
        userInfo.pushToken = token;
        print('Push Token: ${token}');
      }
    });
    // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    //   print('message data: ${message.data}');
    //   if (message.notification != null) {
    //     print('message also contained a notification: ${message.notification}');
    //   }
    // });
  }

  static Future<void> sendPushNotification(user_model.UserInfo user,
      String msg) async {
    try {
      final body = {
        "to": user.pushToken,
        "notification": {
          "title": user.name,
          "body": msg,
          "android_channel_id": "chats"
        },
        "data": {"some_data": "User ID: ${userInfo.id}"}
      };
      var response = await http.post(
          Uri.parse('https://fcm.googleapis.com/fcm/send'),
          body: jsonEncode(body),
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
            HttpHeaders.authorizationHeader:
            'key=AAAAMCFDAGQ:APA91bGMO4epIlzU6LZ9IGp8qXTVQdqoOBjUJE_6um_2Ke9A2bJk4HZxST0G619EFHs9DRhY87Jy0m0AcVUEx6gyb3Q5Lm0QmrzJ7doPl2N9eArUbBDWtPRcC8jA380FP1snjrGwVLi1'
          });
      print(response.statusCode);
      print(response.body);
    } catch (error) {
      print(error);
    }
  }

  static Future<void> signInWithGoogle(BuildContext context) async {
    try {
      await InternetAddress.lookup('google.com');
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
      await googleUser?.authentication;
      print('got here');
      // Create a new credential
      final credential = await GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      final UserCredential userCredential =
      await FirebaseAuth.instance.signInWithCredential(credential);
      print('and here');
      print(userCredential);
      fetchUserDataFromFirestore(userCredential, context);
    } catch (e) {
      print('signInWithGoogle: ${e}');
      throw(
          'Something went wrong, check internet connection and try again ');
    }
  }

  static Future<void> signInEmailPasswordLogin(String email, String password,
      BuildContext context) async {
    try {
      print('trying login');

      final UserCredential userCredential =
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      print(userCredential);
      if (userCredential.user!.emailVerified) {
        fetchUserDataFromFirestore(userCredential, context);
      } else {
        Dialogs.showSnackbar(
            context, 'Click the link sent to your email to veify your account');
      }
      print('loginggg here');

      print('after here');
    } on FirebaseAuthException catch (e) {
      // Handle registration errors
      print('Registration error: $e');
      if (e.code == 'unknown') {
        throw(' kindly check your internet connection');
      }
      throw(' ${e.message}');
    } catch (error) {
      throw(' ${error.toString()}');
    }
  }

  static Future<void> fetchUserDataFromFirestore(UserCredential userCredential,
      BuildContext context) async {
    final User? user = userCredential.user;
    final String userUID = user!.uid;
    print(' id: ${userUID}');

    // Check the "patients" collection
    DocumentSnapshot snapshot =
    await firestore.collection('patients').doc(userUID).get();
    print(snapshot);
    if (snapshot.exists) {
      Map<String, dynamic> patientData =
      snapshot.data() as Map<String, dynamic>;
      print(patientData);
      String userType = patientData['user_type']; // "patient"
      print('printing userType');
      print(userType);
      final user_model.UserInfo userDataInfo =
      user_model.UserInfo.fromJson(patientData);
      userInfo = userDataInfo;
      Prefs.saveUserInfoToPrefs(userInfo);
      isConnected=true;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => Dashboard()),
            (Route<dynamic> route) => false,
      );

    } else {
      snapshot = await FirebaseFirestore.instance
          .collection('doctors')
          .doc(userUID)
          .get();

      if (snapshot.exists) {
        Map<String, dynamic> doctorData =
        snapshot.data() as Map<String, dynamic>;
        String userType = doctorData['user_type']; // "doctor"
        log(userType);
        final user_model.UserInfo userDataInfo =
        user_model.UserInfo.fromJson(doctorData);
        userInfo = userDataInfo;
        Prefs.saveUserInfoToPrefs(userInfo);
        isConnected=true;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => Dashboard()),
        );
      } else {
        userCredential.user!.delete();
        await auth.signOut();
        await GoogleSignIn().signOut();
        Dialogs.showSnackbar(
            context, 'User Details not found, kindly proceed to register');
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => RegistrationScreen()));
      }
    }
  }

  static Future<void> registerWithEmailAndPassword(String name, String email,
      String password, String userType, BuildContext context) async {


    try {
      // Create a new user account with email and password
      if(await hasNetwork()) {
        print(name);
        print(email);
        print(userType);
        final UserCredential userCredential = await auth
            .createUserWithEmailAndPassword(email: email, password: password);
        await userCredential.user!.sendEmailVerification();

        print(userCredential);

        // Get the user's UID
        final String userUID = userCredential.user!.uid;

        // Create a Map containing user data (you can customize this based on your needs)
        final Map<String, dynamic> userData = {
          'name': name,
          'user_type': userType, // "patient" or "doctor"
          'email': email,
          'id': userUID,
          'created_at': DateTime.now().toString(),
          'image': userCredential.user!.photoURL ?? '',
          'is_online': true,
          'last_active': '',
          'phone_number': "",
          'push_token': "",
          'contact_info': userType.toLowerCase() == 'patient'
              ? {"address": "", "phone": ""}
              : {
            'phone': "",
            'clinic_address': "",
            'total_avg_rating': 0,
            'specialization': [],
            'reviews': [],
            'appointments': {},
            'selected_duration': AvailabilityDuration.aMonth.name,
            'is_verified': false,
            'start_time': "",
            'end_time': "",
          }
          // Add other user-specific data here
        };

        // Add the user data to the Firestore collection based on userType
        await firestore
            .collection('${userType.toLowerCase()}s')
            .doc(userUID)
            .set(userData);
        final user_model.UserInfo userDataInfo =
        user_model.UserInfo.fromJson(userData);
        userInfo = userDataInfo;
        Prefs.saveUserInfoToPrefs(userInfo);
        Dialogs.showSnackbar(context, 'Registration Successful');
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => Dashboard()),
              (Route<dynamic> route) => false,
        );
      }else{
        throw("Check your internet connection");
      }
      print('registr don');
    } on FirebaseAuthException catch (e) {
      // Handle registration errors
      print('Registration error: $e');
      if (e.code == 'unknown') {
       throw(
            'Registration failed, kindly check your internet connection');
      } else {
        throw('Registration failed, ${e.message}');
      }
    } catch (error) {
      print(error);
      throw( 'Registration failed, ${error}');
    }
  }

  static late user_model.UserInfo userInfo;

  static Future<void> getSelfInfo() async {
    DocumentSnapshot snapshot =
    await firestore.collection('patients').doc(userInfo.id).get();
    print(snapshot);
    if (snapshot.exists) {
      Map<String, dynamic> patientData =
      snapshot.data() as Map<String, dynamic>;
      print(patientData);
      String userType = patientData['user_type']; // "patient"
      log(userType);
      final user_model.UserInfo userDataInfo =
      user_model.UserInfo.fromJson(patientData);

      userInfo = userDataInfo;
      Prefs.saveUserInfoToPrefs(userInfo);
      await getFirebaseMessagingToken();
     updateActiveStatus(true);
    } else {
      snapshot = await FirebaseFirestore.instance
          .collection('doctors')
          .doc(userInfo.id)
          .get();

      if (snapshot.exists) {
        Map<String, dynamic> doctorData =
        snapshot.data() as Map<String, dynamic>;
        String userType = doctorData['user_type']; // "doctor"
        log(userType);
        final user_model.UserInfo userDataInfo =
        user_model.UserInfo.fromJson(doctorData);

        userInfo = userDataInfo;
        Prefs.saveUserInfoToPrefs(userInfo);
        await getFirebaseMessagingToken();
     updateActiveStatus(true);
      }
    }
  }

  static Future<void> logOut(BuildContext context) async {
    await updateActiveStatus(false);
    await auth.signOut();
    // await GoogleSignIn().signOut();


    await Prefs.clearUserData();
    docReg=null;
    patientBio=null;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => LoginScreen()),
          (Route<dynamic> route) => false,
    );
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getMyUsersId() {
    if (userInfo.userType.toLowerCase() == 'doctor') {
      return APIs.firestore
          .collection('patients')
          .doc(userInfo.id)
          .collection('my_users')
          .snapshots();
    } else {
      return APIs.firestore
          .collection('doctors')
          .doc(userInfo.id)
          .collection('my_users')
          .snapshots();
    }
  }

  static Future<void> sendFirstMessage(user_model.UserInfo chatUser, String msg,
      Type type) async {
    await firestore
        .collection('${userInfo.userType.toLowerCase()}s')
        .doc(chatUser.id)
        .collection('my_users')
        .doc(userInfo.id)
        .set({}).then((value) => sendMessage(chatUser, msg, type));
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers(
      List<String> userIds) {
    if (userInfo.userType.toLowerCase() == 'doctor') {
      return APIs.firestore
          .collection('patients')
          .where("id", whereIn: userIds.isEmpty ? [''] : userIds)
          .snapshots();
    } else {
      return APIs.firestore
          .collection('doctors')
          .where("id", whereIn: userIds.isEmpty ? [''] : userIds)
          .snapshots();
    }
  }

  static Future<void> updateUserInfo(BuildContext context) async {
    try {
      await firestore
          .collection('${userInfo.userType.toLowerCase()}s')
          .doc(userInfo.id)
          .update({
        "name": userInfo.name,
        "phone_number": userInfo.phoneNumber,
        "image": userInfo.image,
        "contact_info": userInfo.userType.toLowerCase() == 'patient'
            ? {
          'phone': userInfo.patientContactInfo!.phone,
          'address': userInfo.patientContactInfo!.clinicAddress,
        }
            : {
          'phone': userInfo.phoneNumber,
          'clinic_address': userInfo.doctorContactInfo!.clinicAddress,
          'start_time': userInfo.doctorContactInfo!.startTime,
          'end_time': userInfo.doctorContactInfo!.endTime,
          'selected_duration':
          userInfo.doctorContactInfo!.selectedDuration.name,
          'is_verified': userInfo.doctorContactInfo!.isVerified,
          'appointments':
          userInfo.doctorContactInfo!.appointments.map((entry) {
            final date = entry.keys.first;
            final slots =
            entry.values.first.map((slot) => slot.toJson()).toList();
            return {
              date: slots,
            };
          }).toList(),
          'specializations': userInfo.doctorContactInfo!.specilizations
              .map((spec) => spec.title) // Extract titles
              .toList(),
          'reviews': userInfo.doctorContactInfo!.reviews
              .map((review) => review.toJson())
              .toList(),
        }
      });
      Prefs.saveUserInfoToPrefs(userInfo);
    } on FirebaseAuthException catch (e) {
      // Handle registration errors
      print('Registration error: $e');
      if (e.code == 'unknown') {
        Dialogs.showSnackbar(context,
            'Registration failed, kindly check your internet connection');
      }
      Dialogs.showSnackbar(context, 'Update failed, ${e.message}');
    } catch (error) {
      Dialogs.showSnackbar(context, 'Update failed, ${error}');
    }
  }

  static Future<void> updateProfilePicture(BuildContext context,
      File file) async {
    print('started profile ');
    final ext = file.path
        .split('.')
        .last;
    print('Extenson: ${ext}');
    final ref = storage.ref().child('profile_pictures/${userInfo.id}.$ext');
    try {
      await ref
          .putFile(file, SettableMetadata(contentType: 'image/${ext}'))
          .then((p0) {
        print('Date Transffered: ${p0.bytesTransferred / 1000} kb ');
      });
      userInfo.image = await ref.getDownloadURL();
      await firestore
          .collection('${userInfo.userType}s')
          .doc(userInfo.id)
          .update({"image": userInfo.image});
      Prefs.saveUserInfoToPrefs(userInfo);
    } on FirebaseException catch (e) {
      // Handle registration errors
      print('Registration error: $e');
      if (e.code == 'unknown') {
        Dialogs.showSnackbar(context,
            'Registration failed, kindly check your internet connection');
      }
      Dialogs.showSnackbar(context, 'Update failed, ${e.message}');
    } catch (error) {
      Dialogs.showSnackbar(context, 'Update failed, ${error}');
    }
  }

  static  bool isConnected=false;

  /**Chat Screen Related APIs */

//coverservation id
  static String getConversationID(String id) =>
      userInfo.id.hashCode <= id.hashCode
          ? '${userInfo.id}_$id'
          : '${id}_${userInfo.id}';

  //getting messages fo a specific conversatio from firestore db
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(
      user_model.UserInfo user) {
    return firestore
        .collection('chats/${getConversationID(user.id)}/messages')
        .orderBy('sent', descending: true)
        .snapshots();
  }

  static Future<bool> localDataExist() async {
    final data = await Prefs.getUserInfoFromPrefs();
    if (data != null) {
      userInfo = data;
      print('data exist');
      return true;
    }
    print('no data ');
    return false;
  }

  static Future<void> initUser() async {
    final result = await hasNetwork();

    if (result) {
      await getSelfInfo();

      await fetchApplication();



    }

    // else {
    //   final checker = await localDataExist();
    //   if (checker) {
    //     Navigator.pushAndRemoveUntil(
    //       context,
    //       MaterialPageRoute(builder: (_) => Dashboard()),
    //           (Route<dynamic> route) => false,
    //     );
    //   } else {
    //     Navigator.pushAndRemoveUntil(
    //       context,
    //       MaterialPageRoute(builder: (_) => LoginScreen()),
    //           (Route<dynamic> route) => false,
    //     );
    //   }
    // }
  }

  static Future<bool> addChatUser(String email) async {
    final data = await firestore
        .collection('doctors')
        .where('email', isEqualTo: email)
        .get();
    if (data.docs.isNotEmpty && data.docs.first != userInfo.id) {
      firestore
          .collection('doctors')
          .doc(userInfo.id)
          .collection('my_users')
          .doc(data.docs.first.id)
          .set({});
      return true;
    } else {
      return false;
    }
  }

  static Future<void> sendMessage(user_model.UserInfo user, String msg,
      Type type) async {
    //messag esing time(also used as id)
    final time = DateTime
        .now()
        .millisecondsSinceEpoch
        .toString();
    //meesage to send
    final Message message = Message(
        fromId: userId,
        msg: msg,
        read: '',
        sent: time,
        toId: user.id,
        type: type);
    final ref =
    firestore.collection('chats/${getConversationID(user.id)}/messages');
    await ref.doc(time).set(message.toJson()).then((value) =>
        sendPushNotification(user, type == Type.text ? msg : 'Photo'));
  }

  static Future<void> updateMessageReadStatus(Message message) async {
    firestore
        .collection('chats/${getConversationID(message.fromId)}/messages/')
        .doc(message.sent)
        .update({'read': DateTime
        .now()
        .millisecondsSinceEpoch
        .toString()});
  }

  static Stream<QuerySnapshot> getLastMessage(user_model.UserInfo user,) {
    return firestore
        .collection('chats/${getConversationID(user.id)}/messages')
        .orderBy('sent', descending: true)
        .limit(1)
        .snapshots();
  }

  static Future<void> sendChatImage(user_model.UserInfo user, File file) async {
    final ext = file.path
        .split('.')
        .last;
    print('Extenson: ${ext}');
    final ref = storage.ref().child(
        'images/${getConversationID(user.id)}/${DateTime
            .now()
            .millisecondsSinceEpoch}.$ext');

    await ref
        .putFile(file, SettableMetadata(contentType: 'image/${ext}'))
        .then((p0) {
      print('Date Transffered: ${p0.bytesTransferred / 1000} kb ');
    });
    final imageUrl = await ref.getDownloadURL();
    await sendMessage(user, imageUrl, Type.image);
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getUserInfo(
      user_model.UserInfo user) {
    return firestore
        .collection('${user.userType.toLowerCase()}s')
        .where('id', isEqualTo: user.id)
        .snapshots();
  }

  //update online or last active status of user
  static Future<void> updateActiveStatus(bool isOnline) async {
    if (await hasNetwork()) {
      firestore
          .collection('${userInfo.userType.toLowerCase()}s')
          .doc(userInfo.id)
          .update({
        "is_online": isOnline,
        'last_active': DateTime
            .now()
            .microsecondsSinceEpoch
            .toString(),
        'push_token': userInfo.pushToken,
      });
    }
  }
  static Future<void> deleteMessage(Message message) async {
    await firestore
        .collection('chats/${getConversationID(message.toId)}/messages/')
        .doc(message.sent)
        .delete();
    if (message.type == Type.image)
      await storage.refFromURL(message.msg).delete();
  }

  // static Future<void> updateMessage(Message message, String updatedMsg) async {
  //   await firestore
  //       .collection('chats/${getConversationID(message.toId)}/messages/')
  //       .doc(message.sent)
  //       .update({'msg': updatedMsg});
  // }

  //booking
  //return only verified doctors for booking
  // static Stream<QuerySnapshot<Map<String, dynamic>>> getAllDoctors() {
  //   return firestore
  //       .collection('doctors')
  //       .where('is_verified', isEqualTo: true)
  //       .snapshots();
  // }

  static Stream<List<Map<String, dynamic>>> getAllDoctors() {
    final StreamController<List<Map<String, dynamic>>> controller =
    StreamController<List<Map<String, dynamic>>>.broadcast();

    firestore.collection('doctors').snapshots().listen((querySnapshot) {
      final List<QueryDocumentSnapshot<Map<String, dynamic>>> documents =
          querySnapshot.docs;

      final List<Map<String, dynamic>> verifiedDoctors = documents
          .where((doc) {
        final data = doc.data();
        if (data['user_type'].toLowerCase() == 'doctor') {
          final doctorContactInfo =
          data['contact_info'] as Map<String, dynamic>;
          if (doctorContactInfo != null) {
            final isVerified = doctorContactInfo['is_verified'] as bool;
            return isVerified == true;
          }
        }
        return false;
      })
          .map((doc) => doc.data())
          .toList();

      controller.add(verifiedDoctors);
    });

    return controller.stream;
  }

  static Future<void> sendAppointmentRequest(DateTime createdDay, String note,
      user_model.UserInfo user, String time, DateTime date) async {
    print('entered booking');
    String formattedDate = "${date.year}-${date.month}-${date.day}";
    final Appointment newAppointment =
    Appointment(patientId: userInfo.id, time: time, isBooked: false);

    if (user.doctorContactInfo != null) {
      var doctorInfo = user.doctorContactInfo;

      // If the availability list is not initialized, create an empty list.
      if (doctorInfo!.appointments == null) {
        doctorInfo.appointments = [];
      }

      // Check if the date exists in the availability list.
      var availabilityIndex = doctorInfo.appointments.indexWhere(
            (entry) => entry.keys.first == formattedDate,
      );

      if (availabilityIndex != -1) {
        // The date exists in the availability list. Add the new appointment.
        var timeSlotExists = doctorInfo
            .appointments[availabilityIndex].values.first
            .any((slot) => slot.time == time && userInfo.id == slot.patientId);

        if (timeSlotExists) {
          // Time slot is already booked; throw an error.
          throw 'You already booked this  time slot in the selected date.';
        }

        doctorInfo.appointments[availabilityIndex][formattedDate]
            ?.add(newAppointment);
      } else {
        // The date doesn't exist in the availability list. Create a new entry.
        var newDateEntry = {
          formattedDate: [newAppointment],
        };
        doctorInfo.appointments.add(newDateEntry);
      }

      try {
        await firestore.collection('doctors').doc(user.id).update({
          "contact_info": {
            'phone': user.phoneNumber,
            'clinic_address': user.doctorContactInfo!.clinicAddress,
            'start_time': user.doctorContactInfo!.startTime,
            'end_time': user.doctorContactInfo!.endTime,
            'is_verified': user.doctorContactInfo!.isVerified,
            'selected_duration': user.doctorContactInfo!.selectedDuration.name,
            'appointments': doctorInfo.appointments.map((entry) {
              final date = entry.keys.first;
              final slots =
              entry.values.first.map((slot) => slot.toJson()).toList();
              return {
                date: slots,
              };
            }).toList(),
            'specializations': user.doctorContactInfo!.specilizations
                .map((spec) => spec.title) // Extract titles
                .toList(),
            'reviews':
            doctorInfo.reviews.map((review) => review.toJson()).toList(),
          },
        }).then((value) async {
          final userAppointment = UserAppointment(
              doctorId: user.id,
              patientId: userInfo.id,
              date: date,
              details: note,
              createdAt: createdDay,
              status: AppointmentStatus.pending,
              time: time);
          await firestore
              .collection('appointments')
              .add(userAppointment.toJson());
          print('sent to appts.');
          sendPushNotification(
              user, '${userInfo.name} just booked an appointment with you.');
        });
      } catch (error) {
        print(error);
        throw error;
      }
    }
  }

  static Stream<List<UserAppointment>> getMyAppointments() {
    return firestore
        .collection('appointments')
        .where('${userInfo.userType == 'doctor' ? 'doctorId' : 'patientId'}',
        isEqualTo: userInfo.id)
        .snapshots()
        .map((querySnapshot) {
      List<UserAppointment> appointments = querySnapshot.docs.map((doc) {
        final data = doc.data();
        final appointment = UserAppointment.fromJson(data);
        appointment.updateStatusIfNecessary();
        return appointment;
      }).toList();
      // return querySnapshot.docs.map((doc) {
      //   final data = doc.data();
      //   return UserAppointment.fromJson(data);
      // }).toList();

      return appointments.reversed.toList(); // Reverse the list
    });
  }

  static Stream<user_model.UserInfo> getUserInfoById(String userId) {
    // Create a reference to the 'patients' or 'doctors' collection based on user type
    print(userId);
    CollectionReference collectionReference =
    userInfo.userType.toLowerCase() == 'doctor'
        ? firestore.collection('doctors')
        : firestore.collection('doctors');

    return collectionReference.doc(userId).snapshots().map((documentSnapshot) {
      final data = documentSnapshot.data();
      print(data);
      if (data != null) {
        return user_model.UserInfo.fromJson(data as Map<String, dynamic>);
      } else {
        // Handle the case where data is null, e.g., return a default UserInfo or throw an error
        // Modify this to return your default UserInfo
        print('null');
        throw 'null';
      }
    });
  }

  static Future<void> updateAppointment(user_model.UserInfo patient,
      UserAppointment appointment, AppointmentStatus newStatus) async {
    final QuerySnapshot querySnapshot = await firestore
        .collection('appointments')
        .where('doctorId', isEqualTo: appointment.doctorId)
        .where('patientId', isEqualTo: appointment.patientId)
        .where('date', isEqualTo: appointment.date.toString())
        .where('time', isEqualTo: appointment.time)
        .get();
    if (querySnapshot.docs.isNotEmpty) {
      // Assuming there is only one matching document, you can update its status
      final DocumentReference appointmentRef =
          querySnapshot.docs.first.reference;
      await appointmentRef.update({
        'status': newStatus.name,
      }).then((value) async {
        print('entered hereeeee');
        await updateDoctorAppointments(
            userInfo,
            appointment.patientId,
            appointment.time,
            newStatus == AppointmentStatus.approved ? true : false);
      }).then((value) =>
          sendPushNotification(userInfo,
              'Hi, your appointment request has been ${newStatus ==
                  AppointmentStatus.approved
                  ? 'approved'
                  : 'rejected'}.Kindly open the for more info.'));
    } else {
      // Handle the case where no matching document is found
      print('No matching appointment found.');
    }
  }

  static Future<void> updateDoctorAppointments(user_model.UserInfo doctor,
      String patientId, String time, bool isApproved) async {
    if (doctor.doctorContactInfo != null) {
      final List<Map<String, List<Appointment>>> appointments =
          doctor.doctorContactInfo!.appointments;
      for (final appointMentMap in appointments) {
        for (final date in appointMentMap.keys) {
          final appointmentList = appointMentMap[date];
          final matchingAppointment = appointmentList!.firstWhere(
                  (appointment) =>
              appointment.patientId == patientId &&
                  appointment.time == time);
          if (isApproved) {
            matchingAppointment.isBooked = true;
          } else {
            appointmentList.remove(matchingAppointment);
          }
        }
      }
    }
    userInfo = doctor;
    final updatedData = userInfo.toJson();
    await firestore.collection('doctors').doc(doctor.id).update(updatedData);
    print('done');
  }

  static List<School>schoolList = [];

  static Future<List<School>> fetchSchools(String searchText,
      BuildContext context) async {
    String apiUrl;
    if (searchText == "") {
      print('used 1');
      apiUrl = 'http://universities.hipolabs.com/search?name=';
    } else {
      apiUrl = 'http://universities.hipolabs.com/search?name=$searchText';
    }

    try {
      final response = await http.get(Uri.parse(apiUrl), headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      }).timeout(Duration(minutes: 3));
      print(response.statusCode);
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        print('ater');
        print(data);
        final list = data.map((school) => School.fromJson(school)).toList();
        schoolList = list;
        return schoolList;
      } else {
        throw Exception('Failed to load schools');
      }
    } catch (error) {
      rethrow;
    }
  }

  static List<String> fetchAllTest() {
    return DUMMY_DATA.availableTests;
  }

//   static Future<void> docApplication(DocReg doc)async{
// try{
// await  firestore.collection('verification').add({
//   'name': doc.name,
//   'homeAddress': doc.homeAddress,
//   'isUniStaff': doc.isUniStaff,
//   'schoolName': doc.schoolName,
//   'officeAddress': doc.officeAddress,
// });
// }
//   }


  static DocReg? docReg;

  static Future<void> docApplication(DocReg doc) async {
    print('strted');
    if (userInfo.userType != "doctor") {
      throw("You're not eligible for this service");
    }
    try {
      var docsCollection = firestore.collection('verification');


      await docsCollection.doc(userInfo.id).set({
        'name': doc.name,
        'homeAddress': doc.homeAddress,
        'isUniStaff': doc.isUniStaff,
        'status': doc.status.name,
        'schoolName': doc.schoolName,
        'officeAddress': doc.officeAddress,
      });

      for (Certificate certificate in doc.certificates!) {
        print(userInfo.email);
        final ext = certificate.fileName.path
            .split('.')
            .last;
        Reference storageReference = FirebaseStorage.instance.ref().child(
            'certificates/${userInfo.email}/${DateTime
                .now()
                .millisecondsSinceEpoch}.$ext');

        UploadTask uploadTask = storageReference.putFile(certificate.fileName);
        print('sent');
        await uploadTask.whenComplete(() async {
          String downloadURL = await storageReference.getDownloadURL();
          // CollectionReference certificatesCollection = docReference.collection('certificates');
          print('fetched');
          if (doc != null) {
            docReg = doc;
          }

          // Add certificate details along with the download URL to the 'certificates' subcollection
          // await certificatesCollection.add({
          //   'type': certificate.type == FileType.img ? 'image' : 'pdf',
          //   'date': certificate.date.toIso8601String(),
          //   'downloadURL': downloadURL,
          // });
        });
      }
    } catch (e) {
      print('Error sending data to Firestore: $e');
      throw(e);
    }
  }

  static Future<void> fetchApplication() async {
    try {
      if (userInfo.userType == "doctor") {
        DocumentSnapshot snapshot =
        await firestore.collection('verification').doc(userId).get();
        print(snapshot);
        if (snapshot.exists) {
          Map<String, dynamic> data =
          snapshot.data() as Map<String, dynamic>;
          final DocReg docData = DocReg.fromJson(data);
          if (docData != null) {
            docReg = docData;
          }
        } else {
          throw("Kindly  try again later");
        }
      } else {
        DocumentSnapshot snapshot =
        await firestore.collection('medicals').doc(userId).get();
        print(snapshot);
        if (snapshot.exists) {
          print('here');
          Map<String, dynamic> data =
          snapshot.data() as Map<String, dynamic>;
          print(data);
          final Medicals medData = Medicals.fromJson(data);
          if (medData != null) {
            patientBio = medData;
          }
        } else {
          throw("Kindly check try again later");
        }
      }
    } catch (e) {
      throw(e);
    }
  }

  static Medicals? patientBio;

  static Future<void> bioDataApplication(Medicals medicals) async {
    if (userInfo.userType != "patient") {
      throw("You're not eligible for this service");
    }
    try {
      print('en fnc');
      var medCollection = firestore.collection('medicals');
      await medCollection.doc(userInfo.id).set({
        'patientId': medicals.patientId,
        'docName': medicals.docName,
        'docId': medicals.docId,
        'patientName': medicals.patientName,
        "screeningDate": medicals.screeningDate.toIso8601String(),
        'school': medicals.school,
        'test': medicals.test?.map((test) => test.toJson()).toList(),
      }).then((value) {
        patientBio = medicals;
        print('bio sent');
      });
    } catch (e) {
      print('Error sending data to Firestore: $e');
      throw(e);
    }
  }

  static Stream<List<Medicals>> getMedicalRecords(String docId, bool isUniStaff,
      String? school) {
    CollectionReference<Map<String, dynamic>> medicalsCollection =
    firestore.collection('medicals');

    // Query for university staff
    if (isUniStaff && school != null) {
      print('using uni');
      return medicalsCollection

          .where('school', isEqualTo: school)
          .snapshots()
          .map((querySnapshot) =>
          querySnapshot.docs
              .map((documentSnapshot) =>
              Medicals.fromJson(documentSnapshot.data()))
              .toList()
              .reversed
              .toList());
    }
    // Query for non-university staff
    else {
      print('using doc');
      return medicalsCollection
          .where('docId', isEqualTo: docId)
          .snapshots()
          .map((querySnapshot) {
        return querySnapshot.docs
            .map(
                (documentSnapshot) =>
                Medicals.fromJson(documentSnapshot.data())

        )
            .toList()
            .reversed
            .toList();
      });
    }
  }



  static Future<void> updateRecords(String patientId, Test updatedTest) async {
  try {
  CollectionReference medCollection = firestore.collection('medicals');
  QuerySnapshot querySnapshot = await medCollection.where('patientId', isEqualTo: patientId).get();

  if (querySnapshot.docs.isNotEmpty) {
  DocumentSnapshot documentSnapshot = querySnapshot.docs.first;
  Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;

  // Find the index of the updated test in the certificates list
  int testIndex = data['test'].indexWhere((test) => test['title'] == updatedTest.title);

  if (testIndex != -1) {
  // Update the 'test' field in the corresponding tests
  data['test'][testIndex]= updatedTest.toJson();

  // Update the record in Firebase
  await medCollection.doc(documentSnapshot.id).update({'test': data['test']});
  print('updated');
  } else {
  // Handle the case where the test is not found
  print('Test not found in the certificates list.');
  }
  } else {
  // Handle the case where the document with the specified ID is not found
  print('Document not found with ID: $patientId');
  }
  } catch (error) {
  print('Error updating records: $error');
  throw error;
  }
  }

}
