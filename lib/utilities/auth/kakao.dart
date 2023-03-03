import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:good_game_duo/utilities/auth/social_login.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';

class Kakao implements SocialLogin {
  @override
  Future<bool> login() async {
    try {
      OAuthToken token;
      // 카카오톡 설치 여부를 확인
      bool isInstalled = await isKakaoTalkInstalled();


      if (isInstalled) {
        token = await UserApi.instance.loginWithKakaoTalk();
      } else {
        token = await UserApi.instance.loginWithKakaoAccount();
        // debugPrint("카카오 accessToken : ${token.accessToken}");
        // debugPrint("카카오 idToken : ${token.idToken}");

        // Kakao 유저 정보를 가져옴
        final kakaoUser = await UserApi.instance.me();
        String id = kakaoUser.id.toString();
        debugPrint("카카오 uid : $id");
        String email = kakaoUser.kakaoAccount!.email!;
        debugPrint("카카오 email : $email");
        String nickname = kakaoUser.kakaoAccount!.profile!.nickname!;
        debugPrint("카카오 nickname : $nickname");

        // FirebaseAuth 인스턴스를 사용하여 사용자를 생성합니다.
        final userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: "kakao_$email",
          password: id,
        );
        debugPrint("카카오 userCredential : $userCredential");

        // 사용자의 이름을 설정합니다.
        final displayName = kakaoUser.kakaoAccount?.profile?.nickname ??
            kakaoUser.kakaoAccount!.email!;
        await userCredential.user!.updateDisplayName(displayName);
        debugPrint("카카오 displayName : $displayName");

        // 사용자의 metadata 에 제공업체 정보를 설정합니다.
        final firebaseAuthProvider = OAuthProvider('kakao.com');
        await userCredential.user!.linkWithCredential(
          firebaseAuthProvider.credential(
            accessToken: token.accessToken,
            idToken: token.idToken,
          ),
        );
      }

      return true;
    } catch (err) {
      debugPrint("Err 메세지 : $err");
      return false;
    }
  }

  @override
  Future<bool> logout() async {
    try {
      await UserApi.instance.unlink();
      return true;
    } catch (err) {
      Fluttertoast.showToast(msg: err.toString());
      return false;
    }
  }
}
