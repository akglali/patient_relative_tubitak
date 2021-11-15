import 'package:flutter/material.dart';
import 'package:patient_relative/screens/change_password_screen.dart';
import 'package:patient_relative/screens/patient_information_screen.dart';
import 'package:patient_relative/services/login_screen_service.dart';
import 'package:patient_relative/widgets/rounded_button.dart';
import 'package:patient_relative/widgets/text_form_field.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../size_config.dart';

class LoginScreen extends StatelessWidget {
  final GlobalKey _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController password1Controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        body: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FormTextField(
                hint: "Emailinizi giriniz",
                prefixIcon: Icons.email,
                controller: emailController,
              ),
              FormTextField(
                hint: "Parolanızı giriniz",
                prefixIcon: Icons.lock,
                controller: password1Controller,
                obscureText: true,
              ),
              RoundedButton(
                name: 'Giriş Yap',
                bgColor: Colors.lightBlueAccent,
                primaryColor: Colors.white,
                function: () async {
                  Future<SharedPreferences> _prefs =
                      SharedPreferences.getInstance();
                  final SharedPreferences prefs = await _prefs;
                  var result = await LoginService(
                          email: emailController.text,
                          password: password1Controller.text)
                      .signIn();
                  if (result[0] != "200") {
                    AlertDialog alert = AlertDialog(
                      title: Text("Hata Bulundu"),
                      content: Text(
                        result[1],
                        style: TextStyle(color: Colors.red),
                      ),
                      actions: const [],
                    );
                    showDialog(context: context, builder: (context) => alert);
                  } else {
                    prefs.setString("patientTc", result[1]['patientTc']);
                    if (result[1]['hasPatient']) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  PatientInformationScreen()));
                    } else {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChangePasswordScreen()));
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
