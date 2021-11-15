import 'package:flutter/material.dart';
import 'package:patient_relative/screens/add_patient_screen.dart';
import 'package:patient_relative/services/change_password_service.dart';
import 'package:patient_relative/widgets/rounded_button.dart';
import 'package:patient_relative/widgets/text_form_field.dart';

class ChangePasswordScreen extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController password1Controller = TextEditingController();
  final TextEditingController password2Controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    String? checkPassword(String? s) {
      if (s == null) {
        return 'Bu alan boş kalamaz!';
      }
      if (s == "") {
        return 'Bu alan boş kalamaz!';
      }
      if (s.length < 6) {
        return 'Parola en az 6 karakterden oluşmaktadır';
      }
    }

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        body: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FormTextField(
                hint: "Eski Parola",
                prefixIcon: Icons.lock,
                controller: oldPasswordController,
                obscureText: true,
                validator: (s) {
                  if (checkPassword(s) != null) {
                    return checkPassword(s);
                  }
                  return null;
                },
              ),
              FormTextField(
                hint: "Yeni Parola",
                prefixIcon: Icons.lock,
                controller: password1Controller,
                obscureText: true,
                validator: (s) {
                  if (checkPassword(s) != null) {
                    return checkPassword(s);
                  }
                  return null;
                },
              ),
              FormTextField(
                hint: "Yeni Parolayı doğrula",
                prefixIcon: Icons.lock,
                controller: password2Controller,
                obscureText: true,
                validator: (s) {
                  if (checkPassword(s) != null) {
                    return checkPassword(s);
                  }
                  if (s != password1Controller.text) {
                    return 'Parolalar eşleşmiyor!';
                  }
                  return null;
                },
              ),
              RoundedButton(
                name: 'Onayla',
                bgColor: Colors.lightBlueAccent,
                primaryColor: Colors.white,
                function: () async {
                  if (_formKey.currentState!.validate()) {
                    var result = await ChangePasswordService(
                            oldPassword: oldPasswordController.text,
                            newPassword: password2Controller.text)
                        .changePassword();
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
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(result[1]),
                      ));
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddPatientScreen()));
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
