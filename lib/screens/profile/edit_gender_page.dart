import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditGenderPage extends StatefulWidget {
  const EditGenderPage({Key? key}) : super(key: key);

  @override
  State<EditGenderPage> createState() => _EditGenderPageState();
}

class _EditGenderPageState extends State<EditGenderPage> {

  bool isFemale = false;
  bool isMale = false;
  String selectedGender = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("자기소개 편집"),
        elevation: 0.0,
        actions: [
          IconButton(
            onPressed: () {
              debugPrint("Edit nickname page - 자기소개 저장");
              Get.back(result: selectedGender);
            },
            icon: const Icon(Icons.check, color: Colors.blue, size: 30.0),
          )
        ],
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                isFemale = !isFemale;
                isMale = false;
                selectedGender = "여성";
              });
            },
            child: Container(
              margin: const EdgeInsets.only(top: 50, right: 10),
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                    color: isFemale ? Colors.pink : Colors.white12, width: 3),
              ),
              child: Image.asset("assets/female.jpg", fit: BoxFit.contain),
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                isMale = !isMale;
                isFemale = false;
                selectedGender = "남성";
              });
            },
            child: Container(
              margin: const EdgeInsets.only(top: 50, left: 10),
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                    color: isMale ? Colors.blue : Colors.white12, width: 3),
              ),
              child: Image.asset("assets/male.jpg", fit: BoxFit.contain),
            ),
          ),
        ],
      ),
    );
  }
}
