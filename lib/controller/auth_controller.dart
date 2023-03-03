import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:good_game_duo/controller/navbar_controller.dart';
import 'package:good_game_duo/models/my_user.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart' as kakao;
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/firestore_constants.dart';
import '../screens/login/login_page.dart';
import '../screens/navbar_page.dart';
import '../utilities/common_utils.dart';

enum AuthStatus {
  uninitialized,
  authenticated,
  authenticating,
  authenticateError,
  authenticateCanceled,
}

class AuthController extends GetxController {
  AuthController({required this.prefs});

  static AuthController instance = Get.find();

  final SharedPreferences prefs;
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // 로그인 확인을 위해 사용되는 멤버 변수
  late final Rx<User?> _user;
  final Rx<bool> isLocalDataLoaded = false.obs;

  AuthStatus _authStatus = AuthStatus.uninitialized;

  AuthStatus get authStatus => _authStatus;

  // 컨트롤러가 초기화 되고나서 실행되는 콜백 함수
  @override
  void onReady() {
    _user = Rx<User?>(firebaseAuth.currentUser);
    _user.bindStream(firebaseAuth.userChanges());
    ever(_user, _moveToPageByUser);
    ever(isLocalDataLoaded, _moveToPageByLocalData);
    super.onReady();
  }

  _moveToPageByUser(User? user) {
    _moveToLoginPageOrNavbarPage(user, isLocalDataLoaded.value);
    print(
        "AuthController -> isLocalDataLoaded.value : ${isLocalDataLoaded.value}");
  }

  _moveToPageByLocalData(bool value) {
    _moveToLoginPageOrNavbarPage(_user.value, value);
  }

  _moveToLoginPageOrNavbarPage(User? user, bool isLoaded) {
    if (user != null && isLoaded) {
      Get.offAll(() => const NavbarPage());
    } else {
      Get.offAll(() => LoginPage());
    }
  }

  String? getFirebaseUserId() {
    return prefs.getString(FirestoreConstants.id);
  }

  void checkUid() {
    if (prefs.getString(FirestoreConstants.id)?.isNotEmpty == true) {
      isLocalDataLoaded.value = true;
    } else {
      isLocalDataLoaded.value = false;
    }
  }

  Future<void> clearUserData() async {
    await prefs.remove(FirestoreConstants.id);
    await prefs.remove(FirestoreConstants.gender);
    await prefs.remove(FirestoreConstants.aboutMe);
    await prefs.remove(FirestoreConstants.photoUrl);
    await prefs.remove(FirestoreConstants.nickname);
    await prefs.remove(FirestoreConstants.birthDate);
  }

  // 파이어베이스 "Authentication"에 존재하는 사용자인지 확인
  Future<bool> checkUserExists(String email) async {
    try {
      var signInMethods =
          await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);
      if (signInMethods.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } on PlatformException catch (err) {
      if (kDebugMode) {
        print(err);
      }
      return false;
    }
  }

  // 파이어스토어에 유저 추가
  addNewUserToFirestore({
    required uid,
    required email,
    required photoUrl,
    required provider,
    required nickname,
  }) async {
    firestore.collection(FirestoreConstants.pathUserCollection).doc(uid).set(
      {
        FirestoreConstants.id: uid,
        FirestoreConstants.email: email,
        FirestoreConstants.provider: provider,
        FirestoreConstants.photoUrl: photoUrl,
        FirestoreConstants.nickname: nickname,
        FirestoreConstants.aboutMe: "",
        FirestoreConstants.gender: "",
        FirestoreConstants.birthDate: "",
        "createAt": DateTime.now(),
      },
    );
  }

  Future<void> logout(String loginPlatform) async {
    _authStatus = AuthStatus.uninitialized;
    try {
      await clearUserData();
      await firebaseAuth.signOut();
      switch (loginPlatform) {
        case FirestoreConstants.google:
          print("구글 로그아웃 진행");
          await GoogleSignIn().disconnect();
          await GoogleSignIn().signOut();
          break;

        case FirestoreConstants.kakao:
          print("카카오 로그아웃 진행");
          await firebaseAuth.signOut();
          // await kakao.UserApi.instance.unlink();
          await kakao.UserApi.instance.logout();
          break;
      }

      Get.offAll(LoginPage());
    } catch (err) {
      if (kDebugMode) {
        print("로그아웃 에러 : $err");
      }
    }
  }

  Future<bool> handleGoogleSignIn() async {
    // authenticating(인증 중) 인증 상태 변경
    _authStatus = AuthStatus.authenticating;

    try {
      // 구글 인증이 완료되면 인증된 사용자의 기본 정보를 전달 받음
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // 로그인을 취소한 경우
      if (googleUser == null) {
        // authenticateCanceled(인증 취소) 인증 상태 변경
        _authStatus = AuthStatus.authenticateCanceled;
        return false;
      }

      // "access token" 토큰과 "id token"을 담고 있는 객체
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // 파이어 베이스 새로운 증명서 생성
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // 로그인 후 증명서 반환
      UserCredential newUser =
          await FirebaseAuth.instance.signInWithCredential(credential);

      // 컬렉션에서 "uid"와 일치하는 id 필드를 가진 문서(Document)를 가져옴
      final QuerySnapshot result = await firestore
          .collection(FirestoreConstants.pathUserCollection)
          .where(FirestoreConstants.id, isEqualTo: newUser.user?.uid)
          .get();

      // 전달 받은 객체 저장
      final List<DocumentSnapshot> document = result.docs;
      final snapshot = document[0];

      if (document.isEmpty) {
        // 기본 프로필을 제공
        String defaultAvatarImageUrl =
            await CommonUtils.getDefaultProfileImage();

        // 신규 가입한 사용자라면 "FireStore"에 저장
        addNewUserToFirestore(
          uid: newUser.user!.uid,
          email: newUser.user!.email,
          photoUrl: defaultAvatarImageUrl,
          provider: FirestoreConstants.google,
          nickname: newUser.user!.displayName,
        );

        // SharedPreferences 활용하여 사용자 내부 저장소에 저장
        User? currentUser = newUser.user;
        await prefs.setString(FirestoreConstants.id, currentUser!.uid);
        await prefs.setString(
            FirestoreConstants.email, currentUser.email ?? "");
        await prefs.setString(
            FirestoreConstants.provider, FirestoreConstants.google);
        await prefs.setString(
            FirestoreConstants.nickname, currentUser.displayName ?? "");
        await prefs.setString(
            FirestoreConstants.photoUrl, defaultAvatarImageUrl);

        // 실행 결과를 반환
        return true;
      } else {
        // 기존에 있던 사용자일 경우 사용자 내부 저장소에만 저장
        DocumentSnapshot documentSnapshot = document[0];
        MyUser myUser = MyUser.fromDocument(documentSnapshot);
        await prefs.setString(FirestoreConstants.id, myUser.id);
        await prefs.setString(FirestoreConstants.aboutMe, myUser.aboutMe ?? "");
        await prefs.setString(
            FirestoreConstants.nickname, myUser.nickname ?? "");
        await prefs.setString(
            FirestoreConstants.provider, FirestoreConstants.google);

        // 실행 결과를 반환
        return true;
      }
    } catch (error) {
      // authenticateError(인증 에러) 인증 상태 변경
      _authStatus = AuthStatus.authenticateError;
      return false;
    }
  }

  Future<bool> handleKakaoSignIn() async {
    // authenticating(인증 중) 인증 상태 변경
    _authStatus = AuthStatus.authenticating;

    try {
      // 카카오 설치 여부 확인
      bool isInstalled = await kakao.isKakaoTalkInstalled();

      try {
        if (isInstalled) {
          // 앱이 설치되어 있다면 앱을 통해 인증 진행
          await kakao.UserApi.instance.loginWithKakaoTalk();
        } else {
          // 앱이 설치되어 있지 않다면 웹 브라우저를 통해 인증 진행
          await kakao.UserApi.instance.loginWithKakaoAccount();
        }
      } catch (error) {
        // 사용자가 카카오톡 설치 후 디바이스 권한 요청 화면에서 로그인을 취소한 경우,
        // 의도적인 로그인 취소로 보고 카카오계정으로 로그인 시도 없이 로그인 취소로 처리 (예: 뒤로 가기)
        if (error is PlatformException && error.code == 'CANCELED') {
          // authenticateCanceled(인증 취소) 인증 상태 변경
          _authStatus = AuthStatus.authenticateCanceled;
          return false;
        }
      }

      // 회원정보를 가져옴
      final kakaoUser = await kakao.UserApi.instance.me();

      // 회원가입 여부 확인 및 프로필 설정을 위해 추출
      String email = kakaoUser.kakaoAccount!.email!;
      String password = kakaoUser.id.toString();
      String kakaoNickname = kakaoUser.kakaoAccount!.profile!.nickname!;

      // "Firebase Auth"에 등록되어 있는 사용자인지 확인
      bool isExistingUser = await checkUserExists(email);

      if (isExistingUser) {
        // 회원가입이 되어 있는 사용자 처리 로직
        UserCredential existingUser =
            await firebaseAuth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        // 컬렉션에서 "uid"와 일치하는 id 필드를 가진 문서(Document)를 가져옴
        final QuerySnapshot result = await firestore
            .collection(FirestoreConstants.pathUserCollection)
            .where(FirestoreConstants.id, isEqualTo: existingUser.user?.uid)
            .get();
        // 쿼리 결과로부터 문서(Document) 목록(List)을 가져옴
        final List<DocumentSnapshot> document = result.docs;

        // 전달 받은 객체 저장
        DocumentSnapshot documentSnapshot = document[0];

        // 로컬 저장소에 사용자 정보 저장
        MyUser myUser = MyUser.fromDocument(documentSnapshot);
        await prefs.setString(FirestoreConstants.id, myUser.id);
        await prefs.setString(FirestoreConstants.photoUrl, myUser.photoUrl);
        await prefs.setString(FirestoreConstants.gender, myUser.gender ?? "");
        await prefs.setString(FirestoreConstants.aboutMe, myUser.aboutMe ?? "");
        await prefs.setString(
            FirestoreConstants.provider, myUser.provider ?? "");
        await prefs.setString(
            FirestoreConstants.birthDate, myUser.birthDate ?? "");
        await prefs.setString(
            FirestoreConstants.nickname, myUser.nickname ?? "");

        // 로컬 저장소에 모든 데이터가 저장 되었음을 알림
        isLocalDataLoaded.value = true;

        // authenticated(인증 완료) 인증 상태 변경
        _authStatus = AuthStatus.authenticated;

        // 실행 결과를 반환
        return true;
      } else {
        // 신규 사용자 처리 로직

        // 사용자 생성 후 증명서 발급
        UserCredential newUser =
            await firebaseAuth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        // 기본 프로필 제공
        String defaultAvatarImageUrl =
            await CommonUtils.getDefaultProfileImage();

        // 파이어스토어에 사용자 정보 추가
        addNewUserToFirestore(
          uid: newUser.user!.uid,
          email: newUser.user!.email,
          photoUrl: defaultAvatarImageUrl,
          provider: FirestoreConstants.kakao,
          nickname: kakaoNickname,
        );

        // 로컬 저장소에 사용자 정보 저장
        User? currentUser = newUser.user;
        await prefs.setString(FirestoreConstants.id, currentUser!.uid);
        await prefs.setString(FirestoreConstants.nickname, kakaoNickname);
        await prefs.setString(
            FirestoreConstants.photoUrl, defaultAvatarImageUrl);
        await prefs.setString(
            FirestoreConstants.provider, FirestoreConstants.kakao);

        // 로컬 저장소에 모든 데이터가 저장 되었음을 알림
        isLocalDataLoaded.value = true;

        // authenticated(인증 완료) 인증 상태 변경
        _authStatus = AuthStatus.authenticated;
        return true;
      }
    } on PlatformException catch (err) {
      // authenticateError(인증 오류) 인증 상태 변경
      _authStatus = AuthStatus.authenticateError;
      if (kDebugMode) {
        print(err);
      }
      return false;
    }
  }
}
