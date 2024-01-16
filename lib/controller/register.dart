import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:test_project_1/constants/colors.dart';
import 'package:test_project_1/screens/login/login.dart';

class RegisterController extends GetxController {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController cpassword = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController location = TextEditingController();
  //------------------------------------------------------------------Toggle Obscure
  final RxBool obscure = true.obs;
  final RxBool obscure1 = true.obs;

  void toggleObscure() {
    obscure(!obscure.value);
  }

  void toggleObscure1() {
    obscure1(!obscure1.value);
  }

  //------------------------------------------------------------------Select Gender
  String _selectGender = 'Select Gender';
  String get selectGender => _selectGender;
  List<String> gender = ['Select Gender', 'Male', 'Female', 'Other'];

  selectedGender(gender) {
    _selectGender = gender;
  }

  //------------------------------------------------------------------Select Date
  final Rx<DateTime?> selectDate = Rx<DateTime?>(null);

  Future<void> selectedDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      selectDate.value = picked;
    } else {
      if (kDebugMode) {
        print('Date of Birth not Selected');
      }
    }
  }

  //------------------------------------------------------------------Select Image from Gallery
  final Rx<File?> selectedImage = Rx<File?>(null);
  Future<void> openImagePicker() async {
    final XFile? pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      selectedImage.value = File(pickedImage.path);
    } else {
      if (kDebugMode) {
        print('Image not Selected');
      }
    }
  }

  //----------------------------------------------------------------------Register

  Future<void> register(BuildContext context) async {
    try {
      DateTime? date = selectDate.value;
      // Map<String, String> header = {"Content-Type": "application/form-data"};
      Uri url = Uri.parse("http://trial.weberfox.in/test/api/register");

      // Create a multipart request
      MultipartRequest post = http.MultipartRequest('POST', url);

      // Add fields to the request
      post.fields['name'] = name.text;
      post.fields['gender'] = _selectGender.toString();
      post.fields['phone'] = phone.text;
      post.fields['email'] = email.text;
      post.fields['password'] = password.text;
      post.fields['location'] = location.text;
      post.fields['dob'] = DateFormat('yyyy-MM-dd').format(date!);
      // post.fields['avatar'] = selectedImage.value!.path;

      // Add avatar image to the request
      var file = await http.MultipartFile.fromPath(
          'avatar', selectedImage.value!.path);
      post.files.add(file);

      // Send the request
      var response = await post.send();

      print(response.statusCode);

      // Read and print the response
      var json = await response.stream.bytesToString();
      print(json);

      if (response.statusCode == 201) {
        final body = jsonDecode(json);
        print("body $body");
        Get.snackbar("1", body["message"],
            dismissDirection: DismissDirection.down,
            backgroundColor: green,
            snackPosition: SnackPosition.BOTTOM);
        if (body["status"] == "true") {
          Get.to(() => const Login());
          name.clear();
          password.clear();
          phone.clear();
          cpassword.clear();
          email.clear();
          print(body);
        } else {
          Get.snackbar("2", body["message"] ?? "Something went wrong",
              backgroundColor: red, snackPosition: SnackPosition.BOTTOM);
        }
      }
    } catch (e) {
      Get.snackbar("2", e.toString() ?? "Something went wrong",
          backgroundColor: red, snackPosition: SnackPosition.BOTTOM);
    }
  }
}
