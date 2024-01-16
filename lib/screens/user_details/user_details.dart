import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:test_project_1/constants/dimensions.dart';
import 'package:test_project_1/constants/images.dart';
import 'package:test_project_1/constants/styles.dart';
import 'package:test_project_1/controller/user_detailes.dart';
import 'package:test_project_1/screens/user_details/user_head.dart';
import 'package:test_project_1/widgets/name.dart';

class UserDetail extends StatefulWidget {
  const UserDetail({super.key});

  @override
  State<UserDetail> createState() => _UserDetailState();
}

class _UserDetailState extends State<UserDetail> {
  @override
  void initState() {
   
    Get.put(UserDetailesController());
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var ctr = Get.put(UserDetailesController());

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const UserHead(image: user),
              Padding(
                padding: e2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Personal Information', style: s15),
                      ],
                    ),
                    name('Alex Jacob', 'Name'),
                    const SizedBox(height: 5),
                    name('alexjacob@gmail.com', 'Email'),
                    const SizedBox(height: 5),
                    name('Male', 'Gender'),
                    name('2006-12-23', 'Date of Birth'),
                    const SizedBox(height: 5),
                    name('9876567890', 'Contact Number'),
                    const SizedBox(height: 5),
                    name('Kochi', 'Location'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
