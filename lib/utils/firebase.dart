import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../main.dart';
import 'package:afia_plus_app/views/screens/doctorPages/manage_appointments.dart';
import 'package:afia_plus_app/views/screens/userPages/user_appointments.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:afia_plus_app/logic/cubits/auth/auth_cubit.dart';


Future<void> firebase_requestPermission() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );
}

Future<void> firebase_initialize_local_plugin() async {
  const AndroidInitializationSettings androidSettings =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initSettings =
      InitializationSettings(android: androidSettings);

  await flutterLocalNotificationsPlugin.initialize(initSettings, 
    onDidReceiveNotificationResponse: (response) {
      if (response.payload != null) {
        final message = RemoteMessage.fromMap(jsonDecode(response.payload!));
        _handleFirebaseMessage(message);
      }
    }
  );
}

Future<bool> init_firebase_messaging() async {
 await FirebaseMessaging.instance.getInitialMessage();
 await firebase_requestPermission();
 await firebase_initialize_local_plugin();
 FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
 FirebaseMessaging.onMessage.listen(_handleFirebaseWhenActive);
 FirebaseMessaging.onMessageOpenedApp.listen(_handleFirebaseMessage);

 await FirebaseMessaging.instance.getToken().then((token) {
   print("Firebase  token is :  $token");
 });
 return true;
}

@pragma('vm:entry-point')
Future<bool> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
 print("Running Background Message>>>");
 print(
   "Recevied Background message ${message.messageId} -  ${message.toMap().toString()}",
 );
 return true;
}

class _NotificationContent {
  final String title;
  final String body;
  const _NotificationContent({required this.title, required this.body});
}

bool _isDoctorNewBooking(AuthState authState, Map<String, dynamic> data) {
  if (authState is! AuthenticatedDoctor) return false;
  final doctorId = authState.doctor.userId?.toString();
  return data['type'] == 'new_booking' &&
      data['doctorId']?.toString() == doctorId &&
      data['appointmentId'] != null;
}

bool _isPatientBookingConfirmed(AuthState authState, Map<String, dynamic> data) {
  if (authState is! AuthenticatedPatient) return false;
  final patientId = authState.patient.userId?.toString();
  return data['type'] == 'booking_confirmed' &&
      data['patientId']?.toString() == patientId &&
      data['appointmentId'] != null;
}

_NotificationContent _buildDoctorNotification(Map<String, dynamic> data) {
  final patientName = data['patientName'] ?? 'Patient';
  final date = data['appointmentDate'];
  final time = data['appointmentTime'];

  final whenClause = [
    if (date != null && date.toString().isNotEmpty) 'on $date',
    if (time != null && time.toString().isNotEmpty) 'at $time',
  ].join(' ');

  final details = whenClause.isNotEmpty ? ' $whenClause' : '';
  return _NotificationContent(
    title: 'New Appointment',
    body: '$patientName booked an appointment$details',
  );
}

_NotificationContent _buildPatientNotification(Map<String, dynamic> data) {
  final doctorName = data['doctorName'] ?? 'Doctor';
  final date = data['appointmentDate'];
  final time = data['appointmentTime'];

  final whenClause = [
    if (date != null && date.toString().isNotEmpty) 'on $date',
    if (time != null && time.toString().isNotEmpty) 'at $time',
  ].join(' ');

  final details = whenClause.isNotEmpty ? ' $whenClause' : '';
  return _NotificationContent(
    title: 'Appointment Confirmed',
    body: '$doctorName confirmed your appointment$details',
  );
}

Future<bool> _handleFirebaseWhenActive(RemoteMessage message) async {
  final context = navigatorKey.currentContext;
  if (context == null) {
    print('Ignoring notification: no navigator context available.');
    return false;
  }

  final authState = context.read<AuthCubit>().state;
  final data = message.data;

  final bool isDoctorCase = _isDoctorNewBooking(authState, data);
  final bool isPatientCase = _isPatientBookingConfirmed(authState, data);

  if (!isDoctorCase && !isPatientCase) {
    print('Notification ignored: not intended for the logged-in user or missing data.');
    return false;
  }

  final content = isDoctorCase
      ? _buildDoctorNotification(data)
      : _buildPatientNotification(data);

  print('Showing in-app notification: ${content.title} -> ${content.body}');

  BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
    content.body,
    htmlFormatBigText: true,
    contentTitle: content.title,
    htmlFormatTitle: true,
  );

  AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
    '3afiaPlus App',
    '3afiaPlus App',
    importance: Importance.high,
    styleInformation: bigTextStyleInformation,
    priority: Priority.high,
    playSound: true,
  );

  NotificationDetails platformChannelSpecifics = NotificationDetails(
    android: androidPlatformChannelSpecifics,
  );

  try {
    await flutterLocalNotificationsPlugin.show(
      data['appointmentId']?.hashCode ?? 0,
      content.title,
      content.body,
      platformChannelSpecifics,
      payload: jsonEncode(message.toMap()),
    );
  } on Exception catch (e, stack) {
    print('Exception $e $stack');
  }

  return true;
}

Future<bool> _handleFirebaseMessage(RemoteMessage message) async {
  final context = navigatorKey.currentContext;
  if (context == null) return false;

  final authState = context.read<AuthCubit>().state;
  final data = message.data;

  final bool isDoctorCase = _isDoctorNewBooking(authState, data);
  final bool isPatientCase = _isPatientBookingConfirmed(authState, data);

  if (!isDoctorCase && !isPatientCase) {
    print('Navigation ignored: message not for the logged-in user.');
    return false;
  }

  if (isDoctorCase) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => SchedulePage(),
      ),
    );
  } else if (isPatientCase) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => UpcomingAppointmentsPage(),
      ),
    );
  }

  return true;
}