import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:patient_relative/screens/patient_location_list_screen.dart';
import 'package:patient_relative/services/patient_information_service.dart';
import 'package:patient_relative/widgets/rounded_button.dart';

import '../size_config.dart';

class PatientInformationScreen extends StatefulWidget {
  @override
  State<PatientInformationScreen> createState() =>
      _PatientInformationScreenState();
}

class _PatientInformationScreenState extends State<PatientInformationScreen> {
  String patientTc = "";
  String pName = "";
  String pSurname = "";
  String? lastSeenTimeDay = "";
  String? lastSeenTimeHour = "";
  String? location = "";
  String? distance = "";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      getLastLasLocation();
    });
  }

  Future<void> refreshPage() async {
     await getLastLasLocation();
  }
  Future<void> getLastLasLocation() async {
    var result = await PatientInformationService().getLastLocationInfo();
    if (result[0] == "200") {
      Map<String, dynamic> info = result[1];
      setState(() {
        patientTc = info["PatientTc"];
        pName = info["PatientName"];
        pSurname = info["PatientSurname"];
        if (info["LastSeenTime"] != null) {
          location = info["Location"];
          distance = info["Distance"];

          var parsedDate = DateTime.parse(info["LastSeenTime"]);
          final DateFormat formatter = DateFormat('yyyy.MM.dd HH:mm');
          final String formatted = formatter.format(parsedDate);
          var fullTime = formatted.split(" ");
          lastSeenTimeDay = fullTime[0];
          lastSeenTimeHour = fullTime[1];
        } else {
          location = "Hastanin henuz bir bilgisi yoktur!";
        }
      });
    } else {
      AlertDialog alert = AlertDialog(
        title: Text("Hata Bulundu"),
        content: Text(
          result[1],
          style: TextStyle(color: Colors.red),
        ),
        actions: const [],
      );
      showDialog(context: context, builder: (context) => alert);
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final _spacer = SizedBox(height: getProportionateScreenHeight(20));
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text('Tubitak'),
      ),
      body: RefreshIndicator(
        onRefresh: refreshPage,
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              buildSection('Hasta TC', patientTc),
              buildSection('Hasta Adı', pName),
              buildSection('Hasta Soyadı', pSurname),
              _spacer,
              Text(
                'Hastanın En Sor Yer Bilgisi',
                style: TextStyle(
                  fontSize: getProportionateScreenHeight(35),
                  fontWeight: FontWeight.bold,
                  color: Colors.lightBlueAccent,
                ),
              ),
              buildLocationSection(_spacer, lastSeenTimeDay!, lastSeenTimeHour!,
                  location!, distance!),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: getProportionateScreenWidth(8),
                    vertical: getProportionateScreenHeight(8)),
                child: RoundedButton(
                  name: 'Geçmiş Yer Bilgilerini Görüntüle',
                  bgColor: Colors.lightBlueAccent,
                  primaryColor: Colors.white,
                  size: getProportionateScreenHeight(20),
                  function: () {
                    if (location != "Hastanin henuz bir bilgisi yoktur!") {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PatientLocationListScreen(
                                    pName: pName,
                                  )));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content:
                            Text("Hasta geçmiş yer bilgisi bulunmamaktadır."),
                      ));
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Padding buildLocationSection(SizedBox _spacer, String date, String hour,
      String location, String distance) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: getProportionateScreenWidth(5),
          vertical: getProportionateScreenHeight(10)),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blueAccent, width: 3),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: getProportionateScreenWidth(10),
              vertical: getProportionateScreenHeight(10)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    date,
                    style:
                        TextStyle(fontSize: getProportionateScreenHeight(35)),
                  ),
                  Text(
                    hour,
                    style:
                        TextStyle(fontSize: getProportionateScreenHeight(35)),
                  ),
                ],
              ),
              _spacer,
              Text(
                location,
                style: TextStyle(fontSize: getProportionateScreenHeight(35)),
              ),
              _spacer,
              Text(
                "${distance}m uzaklıkta.",
                style: TextStyle(fontSize: getProportionateScreenHeight(35)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Padding buildSection(String title, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: getProportionateScreenWidth(20),
          vertical: getProportionateScreenHeight(10)),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blueAccent, width: 3),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                '$title:',
                style: TextStyle(fontSize: getProportionateScreenHeight(35)),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                value,
                style: TextStyle(
                  fontSize: getProportionateScreenHeight(35),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
