import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:patient_relative/utils/secure_storage.dart';

class LoginService {
  String email, password;
  String domain = "http://192.168.1.52:8000/relative/";

  LoginService({required this.email, required this.password});
  //425086
  Future<List> signIn() async {
    var url = Uri.parse('${domain}sign_in');
    var response = await http.post(url,
        body: json.encode({"email": email, "password": password}));
    var body = jsonDecode(response.body);
    if (response.statusCode != 200) {
      return [response.statusCode.toString(), body['Error']];
    }
    await SecureStorage().writeKey("token", body["token"]);
    print(await SecureStorage().readKey("token"));
    return [response.statusCode.toString(), body];
  }
}
