import 'package:flutter/material.dart';
import 'package:good_game_duo/widgets/common_widgets.dart';

class FeedPage extends StatelessWidget {
  const FeedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: myCustomText("피드 화면"),
          elevation: 0.0,
        ),
      ),
    );
  }
}
