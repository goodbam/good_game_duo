import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../screens/feed/feed_page.dart';
import '../screens/home/home_page.dart';
import '../screens/message/chatting_list_page.dart';
import '../screens/profile/profile_page.dart';

class NavbarController extends GetxController {
  final RxInt _selectedIndex = 0.obs;

  int get selectedIndex => _selectedIndex.value;
  set selectedIndex(int index) => _selectedIndex.value = index;

  List<NavbarDTO> items = [
    NavbarDTO(
      widget: const HomePage(),
      label: "Home",
      iconData: Icons.home,
    ),
    NavbarDTO(
      widget: const FeedPage(),
      label: "Feed",
      iconData: Icons.access_time_outlined,
    ),
    NavbarDTO(
      widget: const ChattingListPage(),
      label: "Chat",
      iconData: Icons.message,
    ),
    NavbarDTO(
      widget: ProfilePage(),
      label: "Profile",
      iconData: Icons.account_box_rounded,
    ),
  ];
}

class NavbarDTO {
  Widget? widget;
  String? label;
  IconData? iconData;
  Color? iconColor;

  NavbarDTO({
    this.widget,
    this.iconColor,
    required this.label,
    required this.iconData,
  });
}
