import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:property_app/pages/property_listing.dart';
import 'package:property_app/pages/auth/login.dart';

// TODO: Replace with your Firebase configuration
const firebaseConfig = {
  'apiKey': 'YOUR_API_KEY',
  'authDomain': 'YOUR_AUTH_DOMAIN',
  'projectId': 'YOUR_PROJECT_ID',
  'storageBucket': 'YOUR_STORAGE_BUCKET',
  'messagingSenderId': 'YOUR_MESSAGING_SENDER_ID',
  'appId': 'YOUR_APP_ID'
};

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // TODO: Initialize Firebase with your config
  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Property App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/login',
      routes: {
        '/': (context) => const PropertyList
