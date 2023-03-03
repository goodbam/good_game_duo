import 'package:flutter/material.dart';
import 'package:good_game_duo/controller/auth_controller.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);

  final AuthController authCtl = AuthController.instance;

  Widget googleLoginButton() {
    return InkWell(
      onTap: () async {
        await authCtl.handleGoogleSignIn();
      },
      splashColor: Colors.white,
      child: Container(
        height: 50,
        width: 200,
        padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: const Color(0xFF4285F4),
        ),
        child: Row(
          children: [
            Image.asset(
              "assets/btn_google_light_normal_ios.png",
              fit: BoxFit.cover,
            ),
            const Expanded(
              child: Text(
                'Sign in with Google',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget kakaoLoginButton() {
    return InkWell(
      onTap: () async {
        await authCtl.handleKakaoSignIn();
      },
      splashColor: Colors.red,
      child: Container(
        height: 50,
        width: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
        ),
        child: Image.asset(
          "assets/kakao_login_medium_narrow.png",
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.blue.shade100, Colors.blue.shade500])),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                googleLoginButton(),
                const SizedBox(height: 10.0),
                kakaoLoginButton(),
                const SizedBox(height: 10.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
