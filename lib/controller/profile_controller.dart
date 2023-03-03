import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:good_game_duo/constants/firestore_constants.dart';
import 'package:good_game_duo/constants/storage_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/my_user.dart';
import 'auth_controller.dart';

class ProfileController extends GetxController {
  final SharedPreferences prefs = AuthController.instance.prefs;

  // 로딩 화면을 보여주기 위해 사용하는 변수
  RxBool isLoading = false.obs;
  // 사용자가 프로필 이미지를 선택 했는지 안 했는지를 확인하기 위한 변수
  RxBool hasPickedProfileImage = false.obs;
  // 사용자가 프로필 이미지를 선택 했을 때 선택된 이미지를 임시적으로 보여주기 위한 변수
  Rx<File?> avatarImageFile = Rx<File?>(null);
  // 저장하기전 임시적으로 선택된 생년월일 값을 저장하기 위한 변수
  Rx<DateTime?> pickedDateTime = Rx<DateTime?>(null);

  String id = "";
  RxString gender = "".obs;
  RxString aboutMe = "".obs;
  RxString nickname = "".obs;
  RxString photoUrl = "".obs;
  RxString birthDate = "".obs;

  @override
  void onInit() {
    // 로컬 데이터 가져오기
    takeLocalData();
    super.onInit();
  }

  Future<void> takeLocalData() async {
    debugPrint("ProfileController -> 로컬 데이터 읽어 오기 실행");
    id = prefs.getString(FirestoreConstants.id) ?? "";
    gender.value = prefs.getString(FirestoreConstants.gender) ?? "";
    print("로컬 저장소 -> 성별 : ${gender.value}");
    aboutMe.value = prefs.getString(FirestoreConstants.aboutMe) ?? "";
    print("로컬 저장소 -> 자기소개 : ${aboutMe.value}");
    photoUrl.value = prefs.getString(FirestoreConstants.photoUrl) ?? "";
    print("로컬 저장소 -> 포토 URL : ${photoUrl.value}");
    nickname.value = prefs.getString(FirestoreConstants.nickname) ?? "";
    print("로컬 저장소 -> 닉네임 : ${nickname.value}");
    birthDate.value = prefs.getString(FirestoreConstants.birthDate) ?? "";
    print("로컬 저장소 -> 생일 : ${birthDate.value}");
  }

  UploadTask uploadImageFile(File image, String fileName) {
    Reference reference = FirebaseStorage.instance.ref().child(fileName);
    UploadTask uploadTask = reference.putFile(image);
    return uploadTask;
  }

  Future<void> updateFirestoreData(
      {required String collectionPath,
      required String path,
      required Map<String, dynamic> updateData}) {
    return FirebaseFirestore.instance
        .collection(collectionPath)
        .doc(path)
        .update(updateData);
  }

  Future<void> save() async {
    isLoading.value = true;
    // 사용자가 프로필 이미지를 변경했다면 해당 로직이 실행 됨
    try {
      if (hasPickedProfileImage.value) {
        // 파일에 이름이 곁치지 않도록 uid 값으로 파일 이름을 지정
        String fileName = id;
        // 업로드할 StorageReference 생성 (이미지 파일의 경로를 의미)
        Reference reference = FirebaseStorage.instance
            .ref()
            .child("${StorageConstants.pathUserAvatarImages}/$fileName");
        // 파일 업로드
        await reference.putFile(avatarImageFile.value!);
        // 업로드 완료 후 이미지가 위치해 있는 url 가져오기
        String photoUrlPath = await reference.getDownloadURL();
        // 변경된 정보를 현재 photoUrl 값에 담음
        photoUrl.value = photoUrlPath;
      }

      // 업데이트 될 정보르 담음
      MyUser updateInfo = MyUser(
        id: id,
        birthDate: birthDate.value,
        aboutMe: aboutMe.value,
        nickname: nickname.value,
        gender: gender.value,
        photoUrl: photoUrl.value,
      );

      // 파이어스토어 저장소와 로컬 저장소의 데이터를 변경
      updateFirestoreData(
        collectionPath: FirestoreConstants.pathUserCollection,
        path: id,
        updateData: updateInfo.toJson(),
      ).then((value) async {
        await prefs.setString(FirestoreConstants.nickname, nickname.value);
        await prefs.setString(FirestoreConstants.aboutMe, aboutMe.value);
        await prefs.setString(FirestoreConstants.gender, gender.value);
        await prefs.setString(FirestoreConstants.birthDate, birthDate.value);
        await prefs.setString(FirestoreConstants.photoUrl, photoUrl.value);
        // 업데이트된 정보로 갱신
        await takeLocalData();
      });
      // 모든 작업이 끝나면 로딩에 값을 false 로 변경
      await Future.delayed(const Duration(seconds: 4), () {
        isLoading.value = false;
      });
      // 작업에 성공을 사용자에게 전달
      Fluttertoast.showToast(msg: "프로필 정보가 변경되었습니다 !");
    } catch (err) {
      Fluttertoast.showToast(msg: err.toString());
    }
  }
}
