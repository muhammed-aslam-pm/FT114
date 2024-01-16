import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:test_project_1/constants/colors.dart';
import 'package:test_project_1/screens/user_details/user_details.dart';

class LoginController extends GetxController {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  final Future<SharedPreferences> _prif = SharedPreferences.getInstance();

  //------------------------------------------------------------------Toggle Obscure

  final RxBool obscure = true.obs;

  void toggleObscure() {
    obscure(!obscure.value);
  }

  //-----------------------------------------------------------------LogIn
  Future<void> login() async {
    // Map<String, String> header = {"Content-Type": "application/form-data"};
    try {
      var url = Uri.parse('https://trial.weberfox.in/test/api/login');

      // Create a multipart request
      MultipartRequest post = http.MultipartRequest('POST', url);

      // Add fields to the request
      post.fields['email'] = email.text;
      post.fields['password'] = password.text;

      // Send the request
      var response = await post.send();

      print(response.statusCode);

      // Read and print the response
      var json = await response.stream.bytesToString();
      print(json);

      if (response.statusCode == 200) {
        final body = jsonDecode(json);

        if (body['status'] == "true") {
          Get.to(() => const UserDetail());
          Get.snackbar("", body['message'],
              snackPosition: SnackPosition.BOTTOM, backgroundColor: green);
          final SharedPreferences? pref = await SharedPreferences.getInstance();
          var tocken = body['refresh_token'];
          await pref?.setString('tocken', tocken);
          print('tocken ${pref?.get('tocken')}');
          email.clear();
          password.clear();
        } else {
          throw body["message"] ?? "Somthing went wrong";
        }
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
