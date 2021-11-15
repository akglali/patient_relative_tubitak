import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:patient_relative/utils/secure_storage.dart';

class AddPatientService {
  String prName1,
      prSurname1,
      prPhone1,
      prName2,
      prSurname2,
      prPhone2,
      pName,
      pSurname,
      pTc,
      pBd,
      pGender,
      pAddress;
  String domain = "http://192.168.1.52:8000/relative/";

  AddPatientService(
      {required this.prName1,
      required this.prSurname1,
      required this.prPhone1,
      required this.prName2,
      required this.prSurname2,
      required this.prPhone2,
      required this.pName,
      required this.pSurname,
      required this.pTc,
      required this.pBd,
      required this.pGender,
      required this.pAddress});

  Future<List> addPatient() async {
    var url = Uri.parse('${domain}add_patient');
    var token = await SecureStorage().readKey('token');
    var response = await http.post(url,
        headers: {"Token": token.toString()},
        body: json.encode({
          "PatientBd": pBd,
          "PRName": prName1,
          "PRNum": prPhone1,
          "PRName2": prName2,
          "PRNum2": prPhone2,
          "PatientGender": pGender,
          "PatientAddress": pAddress,
          "PatientTc": pTc,
          "PatientName": pName,
          "PatientSurname": pSurname,
          "PRSurname": prSurname1,
          "PRSurname2": prSurname2
        }));
    var body = jsonDecode(response.body);
    var statusCode = response.statusCode;
    if (statusCode != 200) {
      return [statusCode.toString(), body['Error']];
    }
    return [statusCode.toString(), body];
  }
}
