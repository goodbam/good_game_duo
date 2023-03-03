import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:good_game_duo/controller/profile_controller.dart';
import 'package:good_game_duo/screens/profile/menu_page.dart';
import 'package:good_game_duo/screens/profile/edit_profile_page.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});

  final ProfileController profileCtl = Get.put(ProfileController());



  void _showModalBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(30),
        ),
      ),
      builder: (context) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.5,
        // 화면 기준으로 50%
        maxChildSize: 0.9,
        minChildSize: 0.22,
        builder: (BuildContext context, ScrollController scrollController) =>
            SingleChildScrollView(
          controller: scrollController,
          child: MenuPage(),
        ),
      ),
    );
  }

  Widget _myInfo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // 프로필 사진
        Container(
          margin: const EdgeInsets.all(10),
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Obx(
            () => Image.network(
              profileCtl.photoUrl.value,
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Column(
          children: const [Text("50"), Text("게시물")],
        ),
        Column(
          children: const [Text("23"), Text("팔로워")],
        ),
        Column(
          children: const [Text("23"), Text("팔로잉")],
        ),
      ],
    );
  }

  Widget _editProfile() {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                Get.to(
                  () => EditProfilePage(),
                  transition: Transition.downToUp,
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.white70),
              child: const Text("프로필 편집"),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text("닉네임 : ${profileCtl.nickname}")),
        // elevation: appbar 그림자 효과를 조절
        elevation: 0.0,
        // actions: 한 개 이상의 아이콘을 Appbar 오른쪽에 배치
        actions: [
          IconButton(
            onPressed: () => _showModalBottomSheet(context),
            icon: const Icon(Icons.menu),
          ),
        ],
      ),
      body: Column(
        children: [
          _myInfo(),
          _editProfile(),
        ],
      ),
    );
  }
}

// class ProfilePage extends StatefulWidget {
//   const ProfilePage({Key? key}) : super(key: key);
//
//   @override
//   State<ProfilePage> createState() => _ProfilePageState();
// }
//
// class _ProfilePageState extends State<ProfilePage> {
//   ProfileController profileCtl = Get.put(ProfileController());
//
//   void _showModalBottomSheet(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(
//           top: Radius.circular(30),
//         ),
//       ),
//       builder: (context) => DraggableScrollableSheet(
//         expand: false,
//         initialChildSize: 0.5,
//         // 화면 기준으로 50%
//         maxChildSize: 0.9,
//         minChildSize: 0.22,
//         builder: (BuildContext context, ScrollController scrollController) =>
//             SingleChildScrollView(
//           controller: scrollController,
//           child: MenuPage(),
//         ),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Obx(() => Text("닉네임 : ${profileCtl.nickname}")),
//         // elevation: appbar 그림자 효과를 조절
//         elevation: 0.0,
//         // actions: 한 개 이상의 아이콘을 Appbar 오른쪽에 배치
//         actions: [
//           IconButton(
//             onPressed: () => _showModalBottomSheet(context),
//             icon: const Icon(Icons.menu),
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           _myInfo(),
//           _editProfile(),
//         ],
//       ),
//     );
//   }
//
//   Widget _myInfo() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//       children: [
//         // 프로필 사진
//         Container(
//           margin: const EdgeInsets.all(10),
//           clipBehavior: Clip.hardEdge,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(10),
//           ),
//           child: Obx(
//             () => Image.network(
//               profileCtl.photoUrl.value,
//               width: 100,
//               height: 100,
//               fit: BoxFit.cover,
//             ),
//           ),
//         ),
//         Column(
//           children: const [Text("50"), Text("게시물")],
//         ),
//         Column(
//           children: const [Text("23"), Text("팔로워")],
//         ),
//         Column(
//           children: const [Text("23"), Text("팔로잉")],
//         ),
//       ],
//     );
//   }
//
//   Widget _editProfile() {
//     return Container(
//       margin: const EdgeInsets.only(left: 10, right: 10),
//       child: Row(
//         children: [
//           Expanded(
//             child: ElevatedButton(
//               onPressed: () {
//                 Get.to(
//                   () => EditProfilePage(),
//                   transition: Transition.downToUp,
//                 );
//               },
//               style: ElevatedButton.styleFrom(backgroundColor: Colors.white70),
//               child: const Text("프로필 편집"),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
