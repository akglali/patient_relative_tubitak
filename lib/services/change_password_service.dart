import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:patient_relative/utils/secure_storage.dart';

class ChangePasswordService {
  String oldPassword, newPassword;
  String domain = "http://192.168.1.52:8000/relative/";

  ChangePasswordService({required this.oldPassword, required this.newPassword});

  Future<List> changePassword() async {
    var url = Uri.parse('${domain}change_password');
    var token = await SecureStorage().readKey('token');
    print(token);
    var response = await http.post(url,
        headers:{"Token": token.toString()},
        body: json
            .encode({"oldpassword": oldPassword, "newpassword": newPassword}));
    var body = jsonDecode(response.body);
    var statusCode=response.statusCode;
    if ( statusCode != 200) {
      return [statusCode.toString(), body['Error']];
    }
    return [statusCode.toString(),body];
  }
}
