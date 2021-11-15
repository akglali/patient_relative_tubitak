import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:patient_relative/screens/patient_information_screen.dart';
import 'package:patient_relative/services/add_patient_service.dart';
import 'package:patient_relative/widgets/rounded_button.dart';
import 'package:patient_relative/widgets/text_form_field_v2.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../size_config.dart';

class AddPatientScreen extends StatefulWidget {
  @override
  State<AddPatientScreen> createState() => _AddPatientScreenState();
}

class _AddPatientScreenState extends State<AddPatientScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController PRname1 = TextEditingController();

  final TextEditingController PRsurname1 = TextEditingController();

  final TextEditingController PRphone1 = TextEditingController();

  final TextEditingController PRname2 = TextEditingController();

  final TextEditingController PRsurname2 = TextEditingController();

  final TextEditingController PRphone2 = TextEditingController();

  final TextEditingController Pname = TextEditingController();

  final TextEditingController Psurname = TextEditingController();

  final TextEditingController PTC = TextEditingController();

  final TextEditingController PBD = TextEditingController();

  final TextEditingController ADDRESS = TextEditingController();

  DateTime selectedDate = DateTime.now();

  String? cinsiyet = null;

  @override
  void initState() {
    super.initState();
    getPatientTc();
  }

  void getPatientTc() async {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    print(prefs.getString("patientTc"));
    setState(() {
      PTC.text = prefs.getString("patientTc")!;
      print(PTC.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    final _spacer = SizedBox(height: getProportionateScreenHeight(15));
    final format = DateFormat("yyyy-MM-dd");

    String? _myValidator(String? s) {
      if (s == null || s.isEmpty) {
        return 'Bu alan doldurulmalı';
      }

      return null;
    }

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        body: SingleChildScrollView(
          child: SafeArea(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  buildTitle('Hasta Yakını 1'),
                  Row(
                    children: [
                      FormTextFieldV2(
                        controller: PRname1,
                        hint: 'Ad',
                        validator: _myValidator,
                      ),
                      FormTextFieldV2(
                        controller: PRsurname1,
                        hint: 'Soyad',
                        validator: _myValidator,
                      ),
                    ],
                  ),
                  _spacer,
                  Row(
                    children: [
                      FormTextFieldV2(
                        controller: PRphone1,
                        hint: 'Telefon',
                        validator: _myValidator,
                        keyboardType: TextInputType.number,
                      ),
                    ],
                  ),
                  _spacer,
                  buildTitle('Hasta Yakını 2'),
                  Row(
                    children: [
                      FormTextFieldV2(
                        controller: PRname2,
                        hint: 'Ad',
                        validator: _myValidator,
                      ),
                      FormTextFieldV2(
                        controller: PRsurname2,
                        hint: 'Soyad',
                        validator: _myValidator,
                      ),
                    ],
                  ),
                  _spacer,
                  Row(
                    children: [
                      FormTextFieldV2(
                        controller: PRphone2,
                        hint: 'Telefon',
                        validator: _myValidator,
                        keyboardType: TextInputType.number,
                      ),
                    ],
                  ),
                  _spacer,
                  buildTitle('Hasta Bilgileri'),
                  _spacer,
                  Row(
                    children: [
                      FormTextFieldV2(
                        controller: Pname,
                        hint: 'Ad',
                        validator: _myValidator,
                      ),
                      FormTextFieldV2(
                        controller: Psurname,
                        hint: 'Soyad',
                        validator: _myValidator,
                      ),
                    ],
                  ),
                  _spacer,
                  Row(
                    children: [
                      FormTextFieldV2(
                        controller: PTC,
                        hint: 'TC no',
                        enable: false,
                        validator: _myValidator,
                        keyboardType: TextInputType.number,
                      ),
                      Flexible(
                        child: DateTimeField(
                          controller: PBD,
                          format: format,
                          decoration: InputDecoration(hintText: 'Doğum Tarihi'),
                          onShowPicker: (BuildContext context,
                              DateTime? currentValue) async {
                            final date = await showDatePicker(
                                context: context,
                                initialDate: currentValue ?? DateTime.now(),
                                firstDate: DateTime(1930),
                                lastDate: DateTime(2100));
                            return date;
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: getProportionateScreenWidth(10)),
                        child: DropdownButton<String>(
                          hint: Text("Cinsiyet"),
                          value: cinsiyet,
                          items: <String>['Kadın', 'Erkek'].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              cinsiyet = newValue;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      FormTextFieldV2(
                        controller: ADDRESS,
                        hint: 'Address',
                        validator: _myValidator,
                        maxLines: 2,
                      ),
                    ],
                  ),
                  _spacer,
                  RoundedButton(
                    name: 'Ekle',
                    bgColor: Colors.lightBlueAccent,
                    primaryColor: Colors.white,
                    function: () async {
                      if (_formKey.currentState!.validate()) {
                        if (cinsiyet == null || (PBD.text) == "") {
                          AlertDialog alert = AlertDialog(
                            title: Text("Hata Bulundu"),
                            content: Text(
                              "Hasta doğum tarihi yada cinsiyeti eksik girilmiş!  ",
                              style: TextStyle(color: Colors.red),
                            ),
                            actions: const [],
                          );
                          showDialog(
                              context: context, builder: (context) => alert);
                        } else {
                          var result = await AddPatientService(
                                  prName1: PRname1.text,
                                  prSurname1: PRsurname1.text,
                                  prPhone1: PRphone1.text,
                                  prName2: PRname2.text,
                                  prSurname2: PRsurname2.text,
                                  prPhone2: PRphone2.text,
                                  pName: Pname.text,
                                  pSurname: Psurname.text,
                                  pTc: PTC.text,
                                  pBd: PBD.text,
                                  pGender: cinsiyet!,
                                  pAddress: ADDRESS.text)
                              .addPatient();
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
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        PatientInformationScreen()));
                          }
                        }
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Text buildTitle(String title) {
    return Text(
      title,
      style: TextStyle(
          fontSize: getProportionateScreenHeight(25),
          fontWeight: FontWeight.bold),
    );
  }
}
