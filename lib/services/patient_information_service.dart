import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:patient_relative/utils/secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PatientInformationService {
  String domain = "http://192.168.1.52:8000/relative/";

  PatientInformationService();

  Future<List> getLastLocationInfo() async {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    var token = await SecureStorage().readKey('token');
    var patientTc = prefs.getString("patientTc");
    var url = Uri.parse('${domain}last_location/$patientTc');
    var response = await http.get(url, headers: {"Token": token.toString()});
    var body = jsonDecode(response.body);
    if (response.statusCode != 200) {
      return [response.statusCode.toString(), body['Error']];
    }
    return [response.statusCode.toString(), body];
  }
}
