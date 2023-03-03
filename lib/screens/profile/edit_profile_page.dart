import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:good_game_duo/controller/profile_controller.dart';
import 'package:good_game_duo/screens/profile/edit_about_me_page.dart';
import 'package:good_game_duo/screens/profile/edit_gender_page.dart';
import 'package:good_game_duo/screens/profile/edit_nickname_page.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:scroll_date_picker/scroll_date_picker.dart';

import '../../widgets/common_widgets.dart';
import '../../widgets/loading_view.dart';

class EditProfilePage extends StatelessWidget {
  EditProfilePage({super.key});

  final ProfileController profileCtl = Get.put(ProfileController());

  Future _pickImage(ImageSource source) async {
    // ImagePicker 인스턴스 생성
    ImagePicker imagePicker = ImagePicker();
    try {
      // 촬영 또는 앨범에서 가져온 이미지를 변수에 저장
      XFile? pickedImage = await imagePicker.pickImage(source: source);
      // 선택된 이미지가 없다면 함수 종료
      if (pickedImage == null) return;
      // 이미지 비율 맞춰 자름
      File? croppedImage = await _cropImage(imageFile: File(pickedImage.path));
      if (croppedImage == null) return;
      // 사용자가 프로필 이미지를 변경했는지 안했는지를 확인
      profileCtl.hasPickedProfileImage.value = true;
      // 작업이 끝난 이미지를 전역 변수에 담음 (변경된 프로필 이미지를 바로 적용하기 위함)
      profileCtl.avatarImageFile.value = croppedImage;
    } catch (err) {
      Fluttertoast.showToast(msg: err.toString());
    }
  }

  void openDatePicker() {
    Get.bottomSheet(
      Container(
        height: Get.height * 0.33,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Center(child: myCustomText("생일 편집")),
                ),
                Positioned(
                  child: Container(
                    padding: const EdgeInsets.only(right: 15),
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      onPressed: () {
                        DateTime? pickedDateTime =
                            profileCtl.pickedDateTime.value;
                        if (pickedDateTime != null) {
                          profileCtl.birthDate.value =
                              DateFormat('yyyy - MM - dd')
                                  .format(pickedDateTime);
                        }
                        Get.back();
                      },
                      icon: const Icon(
                        Icons.check,
                        size: 30,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            _scrollDatePicker()
          ],
        ),
      ),
    );
  }

  Widget _scrollDatePicker() {
    return SizedBox(
      height: Get.height * 0.25,
      child: ScrollDatePicker(
        selectedDate: DateTime.now().subtract(const Duration(days: 700)),
        locale: const Locale('ko'),
        scrollViewOptions: const DatePickerScrollViewOptions(
            year: ScrollViewDetailOptions(
              label: '년',
              margin: EdgeInsets.only(right: 8),
            ),
            month: ScrollViewDetailOptions(
              label: '월',
              margin: EdgeInsets.only(right: 8),
            ),
            day: ScrollViewDetailOptions(
              label: '일',
            )),
        onDateTimeChanged: (DateTime value) {
          profileCtl.pickedDateTime.value = value;
        },
      ),
    );
  }

  Future<File?> _cropImage({required File imageFile}) async {
    CroppedFile? croppedImage = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
    );
    if (croppedImage == null) return null;
    return File(croppedImage.path);
  }

  void openBottomSheet() {
    Get.bottomSheet(
      backgroundColor: Colors.white,
      elevation: 0.0,
      Container(
        margin: EdgeInsets.zero,
        height: 170,
        decoration: const BoxDecoration(borderRadius: BorderRadius.zero),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 1,
              child: OutlinedButton(
                onPressed: () {
                  Get.back();
                  _pickImage(ImageSource.gallery);
                },
                child: const Text(
                  "앨범",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: OutlinedButton(
                onPressed: () {
                  Get.back();
                  _pickImage(ImageSource.camera);
                },
                child: const Text(
                  "촬영",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              flex: 1,
              child: OutlinedButton(
                onPressed: () {
                  Get.back();
                },
                child: const Text("취소"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: myCustomText("프로필 편집"),
        elevation: 0.0,
        actions: [
          IconButton(
            onPressed: () async {
              await profileCtl.save();
              Get.back();
            },
            icon: const Icon(Icons.check),
          )
        ],
      ),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.all(10),
            children: [
              Column(
                children: [
                  myCustomText("프로필 사진", fontSize: 15),
                  GestureDetector(
                    onTap: openBottomSheet,
                    child: Container(
                      margin: const EdgeInsets.only(top: 10, bottom: 20),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Obx(
                          () => profileCtl.hasPickedProfileImage.value
                              ? Image.file(
                                  profileCtl.avatarImageFile.value!,
                                  width: 90,
                                  height: 90,
                                  fit: BoxFit.cover,
                                )
                              : Image.network(
                                  profileCtl.photoUrl.value,
                                  width: 90,
                                  height: 90,
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Obx(
                () => ListTile(
                  leading: myCustomText("닉네임", fontSize: 15),
                  title: Center(child: Text(profileCtl.nickname.value)),
                  trailing: const Icon(Icons.navigate_next),
                  onTap: () async {
                    String? result = await Get.to(
                      () =>
                          EditNicknamePage(nickname: profileCtl.nickname.value),
                    );
                    if (result != null) profileCtl.nickname.value = result;
                  },
                ),
              ),
              Obx(
                () => ListTile(
                  leading: myCustomText("자기소개", fontSize: 15),
                  title: Center(
                    child: Text(
                      profileCtl.aboutMe.value,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                  trailing: const Icon(Icons.keyboard_arrow_right),
                  onTap: () async {
                    String? result = await Get.to(() =>
                        EditAboutMePage(aboutMe: profileCtl.aboutMe.value));
                    if (result != null) profileCtl.aboutMe.value = result;
                  },
                ),
              ),
              Obx(
                () => ListTile(
                  leading: myCustomText("성별", fontSize: 15),
                  title: Center(child: Text(profileCtl.gender.value)),
                  trailing: const Icon(Icons.keyboard_arrow_right),
                  onTap: () async {
                    String? result = await Get.to(() => const EditGenderPage());
                    if (result != null) profileCtl.gender.value = result;
                  },
                ),
              ),
              Obx(
                () => ListTile(
                  leading: myCustomText("생일", fontSize: 15),
                  title: Center(child: Text(profileCtl.birthDate.value)),
                  trailing: const Icon(Icons.keyboard_arrow_right),
                  onTap: () {
                    openDatePicker();
                  },
                ),
              ),
              ListTile(
                leading: myCustomText("내 관심사", fontSize: 15),
                trailing: const Icon(Icons.keyboard_arrow_right, size: 20),
                onTap: () {
                  debugPrint("내 관심사 타일 클릭!!");
                },
              ),
            ],
          ),
          Obx(
            () => Positioned(
              child: profileCtl.isLoading.value
                  ? const LoadingView()
                  : const SizedBox.shrink(),
            ),
          ),

          // Obx(() => Positioned(
          //       child: Obx(() => profileCtl.isLoading.value
          //           ? const LoadingView()
          //           : const SizedBox.shrink()),
          //     )),
        ],
      ),
    );
  }
}
