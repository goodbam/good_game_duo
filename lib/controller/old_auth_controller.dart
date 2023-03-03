import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:good_game_duo/utilities/common_utils.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/firestore_constants.dart';
import '../models/my_user.dart';
import '../screens/login/login_page.dart';
import '../screens/navbar_page.dart';
import 'navbar_controller.dart';

enum Status {
  uninitialized,
  authenticated,
  authenticating,
  authenticateError,
  authenticateCanceled,
}


class OldAuthController extends GetxController {
  OldAuthController({required this.prefs});

  static OldAuthController instance = Get.find();
  late Rx<User?> _user;
  late NavbarController navbarController = Get.put(NavbarController());

  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final SharedPreferences prefs;

  Rx<Status> status = Status.uninitialized.obs;

  // 컨트롤러가 초기화 되고나서 실행되는 콜백 함수
  @override
  void onReady() {
    _user = Rx<User?>(firebaseAuth.currentUser);
    _user.bindStream(firebaseAuth.userChanges());
    ever(_user, _moveToPage);

    super.onReady();
  }

  _moveToPage(User? user) {
    if (user == null) {
      Get.offAll(() => LoginPage());
    } else {
      Get.offAll(() => const NavbarPage());
    }
  }

  String? getFirebaseUserId() {
    return prefs.getString(FirestoreConstants.id);
  }

  Future<bool> isLoggedIn() async {
    bool isLoggedIn = await googleSignIn.isSignedIn();
    if (isLoggedIn &&
        prefs.getString(FirestoreConstants.id)?.isNotEmpty == true) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> handleGoogleSignIn() async {
    // authenticating(인증 중) 상태 변경
    status.value = Status.authenticating;

    // 인증 절차 실행
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    if (googleUser == null) {
      // 사용자가 로그인 프로세스를 취소한 경우
      status.value = Status.authenticateError;
      return false;
    }

    if (googleUser != null) {
      // 인증 상세 정보 받아오기
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // 새로운 증명서 생성
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // 로그인 후 증명서 반환
      UserCredential newUser =
          await FirebaseAuth.instance.signInWithCredential(credential);

      // "uid"로 중복된 사용자인지 확인
      final QuerySnapshot result = await firebaseFirestore
          .collection(FirestoreConstants.pathUserCollection)
          .where(FirestoreConstants.id, isEqualTo: newUser.user?.uid)
          .get();

      final List<DocumentSnapshot> document = result.docs;

      if (document.isEmpty) {
        // 기본 프로필을 제공
        String defaultAvatarImageUrl = await CommonUtils.getDefaultProfileImage();
        // 신규 가입한 사용자라면 "FireStore"에 저장
        firebaseFirestore
            .collection(FirestoreConstants.pathUserCollection)
            .doc(newUser.user?.uid)
            .set({
          FirestoreConstants.id: newUser.user!.uid,
          FirestoreConstants.email: newUser.user!.email,
          FirestoreConstants.photoUrl: defaultAvatarImageUrl,
          FirestoreConstants.nickname: newUser.user!.displayName,
          FirestoreConstants.aboutMe: "",
          FirestoreConstants.gender: "",
          FirestoreConstants.birthDate: "",
          "createdAt: ": DateTime.now(),
        });
        // SharedPreferences 활용하여 사용자 내부 저장소에 저장
        User? currentUser = newUser.user;
        await prefs.setString(FirestoreConstants.id, currentUser!.uid);
        await prefs.setString(
            FirestoreConstants.email, currentUser.email ?? "");
        await prefs.setString(
            FirestoreConstants.nickname, currentUser.displayName ?? "");
        await prefs.setString(
            FirestoreConstants.photoUrl, defaultAvatarImageUrl);
      } else {
        // 기존에 있던 사용자일 경우 사용자 내부 저장소에만 저장
        DocumentSnapshot documentSnapshot = document[0];
        MyUser myUser = MyUser.fromDocument(documentSnapshot);
        await prefs.setString(FirestoreConstants.id, myUser.id);
        await prefs.setString(
            FirestoreConstants.nickname, myUser.nickname ?? "");
        await prefs.setString(FirestoreConstants.aboutMe, myUser.aboutMe ?? "");
      }
      // authenticated(인증 완료)로 상태 변경
      status.value = Status.authenticated;
      return true;
    } else {
      // authenticateError(인증 에러)로 상태 변경
      status.value = Status.authenticateError;
      return false;
    }
  }

  Future<void> googleSignOut() async {
    // uninitialized(인증 되지 않음)으로 상태 변경
    status.value = Status.uninitialized;
    await firebaseAuth.signOut();
    await googleSignIn.disconnect();
    await googleSignIn.signOut();
  }
}
