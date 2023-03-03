import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditNicknamePage extends StatefulWidget {
  final String nickname;

  const EditNicknamePage({Key? key, required this.nickname}) : super(key: key);

  @override
  State<EditNicknamePage> createState() => _EditNicknamePageState();
}

class _EditNicknamePageState extends State<EditNicknamePage> {
  late TextEditingController _textEditingController;
  late FocusNode _focusNode;

  @override
  void initState() {
    _textEditingController = TextEditingController();
    _focusNode = FocusNode();
    _textEditingController.text = widget.nickname;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _focusNode.unfocus,
      child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text("닉네임 편집"),
            elevation: 0.0,
            actions: [
              IconButton(
                onPressed: () {
                  debugPrint("Edit nickname page - 닉네임 저장");
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
                  maxLength: 15,
                  style: const TextStyle(fontSize: 20, color: Colors.black),
                  decoration: const InputDecoration(
                      hintText: "사용하실 닉네임을 입력해주세요", border: InputBorder.none
                    //counter: customTextCounter(),
                  ),
                ),
              ),
              const Text(
                "15일에 한 번만 변경이 가능하니 신중하게 설정 해주세요 ",
                style: TextStyle(
                  color: Colors.redAccent,
                  fontSize: 12,
                ),
              )
            ],
          )
      ),
    );
  }
}
