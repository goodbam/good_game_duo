import 'package:flutter/material.dart';
import 'package:good_game_duo/widgets/common_widgets.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: myCustomText("홈 화면"),
          elevation: 0.0,
        ),
      ),
    );
  }
}
