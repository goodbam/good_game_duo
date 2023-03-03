import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:good_game_duo/constants/firestore_constants.dart';
import 'package:get/get.dart';
import 'package:good_game_duo/controller/auth_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../controller/profile_controller.dart';

class MenuPage extends StatelessWidget {
  MenuPage({super.key});

  final AuthController authCtl = AuthController.instance;
  final ProfileController profileCtl = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.topCenter,
      clipBehavior: Clip.none,
      children: [
        Positioned(
          top: 10,
          child: Container(
            width: 60,
            height: 7,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(5),
            ),
          ),
        ),
        Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                String? loggedInPlatform =
                    authCtl.prefs.getString(FirestoreConstants.provider);
                if (loggedInPlatform != null) {
                  authCtl.logout(loggedInPlatform);
                }
              },
              child: const Text("로그아웃"),
            ),
            ElevatedButton(
              onPressed: () {
                debugPrint(
                    "Menu_Page -> currentUser: ${FirebaseAuth.instance.currentUser}");
              },
              child: const Text("User ID 콘솔에 찍기"),
            ),
            ElevatedButton(
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.clear();
                debugPrint("Menu_Page -> SharedPreferences Reset");
              },
              child: const Text("로컬 저장소 초기화"),
            ),
            ElevatedButton(
              onPressed: () {
                authCtl.isLocalDataLoaded.value =
                    !authCtl.isLocalDataLoaded.value;
                debugPrint(
                    "Menu_Page -> isLocalDataLoaded 값: ${authCtl.isLocalDataLoaded.value}");
              },
              child: const Text("isLocalDataLoaded Switch true/false "),
            ),
          ],
        ),
      ],
    );
  }
}
