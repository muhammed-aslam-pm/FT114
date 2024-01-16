import 'dart:convert';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class UserDetailesController extends GetxController {
  final Future<SharedPreferences> _prif = SharedPreferences.getInstance();
  RxMap<String, dynamic> userDetailes = <String, dynamic>{}.obs;

  @override
  void onInit() {
    print("on Init");
    fechUserData();
    // TODO: implement onInit
    super.onInit();
  }

  //---------------------------------------------fetch User Data
  Future<void> fechUserData() async {
    print("Function calling");
    final SharedPreferences pref = await SharedPreferences.getInstance();
    var tocken = pref.get('tocken');
    print("toch=ken $tocken");
    Uri url = Uri.parse("http://trial.weberfox.in/test/api/user-details");

    http.Response response =
        await http.get(url, headers: {'Authentication': 'Bearer$tocken'});

    if (response.statusCode == 200) {
      userDetailes.value = jsonDecode(response.body);

      print(userDetailes);
    }
  }
}
