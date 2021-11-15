import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:patient_relative/screens/login_screen.dart';
import 'package:patient_relative/screens/patient_information_screen.dart';
import 'package:patient_relative/utils/secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isLoggedIn = false;
  bool isLoading = true;

  void getToken() async {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    var token = await SecureStorage().readKey('token');
    print(token);
    await Future.delayed(Duration(seconds: 1));
    if (token != null) {
      setState(() {
        isLoggedIn = true;
      });
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    getToken();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tubitak',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: isLoading
          ? Scaffold(
              body: Center(
                child: SpinKitSpinningLines(
                  color: Colors.redAccent,
                  size: 100,
                  duration: Duration(seconds: 3),
                ),
              ),
            )
          : isLoggedIn
              ? PatientInformationScreen()
              : LoginScreen(),
    );
  }
}
