import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:good_game_duo/controller/navbar_controller.dart';

class NavbarPage extends StatelessWidget {
  const NavbarPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final navbarCtl = Get.put(NavbarController(), permanent: true);

    return Obx(
      () => Scaffold(
        body: navbarCtl.items[navbarCtl.selectedIndex].widget,
        bottomNavigationBar: BottomNavigationBar(
          //backgroundColor: Colors.black,
          currentIndex: navbarCtl.selectedIndex,
          onTap: (index) {
            navbarCtl.selectedIndex = index;
          },
          items: navbarCtl.items
              .map(
                (e) => BottomNavigationBarItem(
                    icon: Icon(e.iconData, color: Colors.black),
                    label: e.label,
                    backgroundColor: e.iconColor),
              )
              .toList(),
        ),
      ),
    );
  }
}
