import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditAboutMePage extends StatefulWidget {
  final String aboutMe;

  const EditAboutMePage({Key? key, required this.aboutMe}) : super(key: key);

  @override
  State<EditAboutMePage> createState() => _EditAboutMePageState();
}

class _EditAboutMePageState extends State<EditAboutMePage> {
  late TextEditingController _textEditingController;
  late FocusNode _focusNode;

  @override
  void initState() {
    _textEditingController = TextEditingController();
    _focusNode = FocusNode();
    _textEditingController.text = widget.aboutMe;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _focusNode.unfocus,
      child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text("자기소개 편집"),
            elevation: 0.0,
            actions: [
              IconButton(
                onPressed: () {
                  debugPrint("Edit nickname page - 자기소개 저장");
                  Get.back(result: _textEditingController.text);
                },
                icon: const Icon(Icons.check,color: Colors.blue,size: 30.0),
              )
            ],
          ),
          body: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.only(left: 20,right: 10),
                margin: const EdgeInsets.all(10),
                child: TextField(
                  focusNode: _focusNode,
                  controller: _textEditingController,
                  maxLines: 10,
                  maxLength: 200,
                  cursorColor: Colors.black,
                  style: const TextStyle(fontSize: 20, color: Colors.black),
                  decoration: const InputDecoration(
                      hintText: "간단하게 자신를 설명해 주세요~", border: InputBorder.none
                    //counter: customTextCounter(),
                  ),
                ),
              )
            ],
          )
      ),
    );
  }
}
