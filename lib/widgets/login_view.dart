import 'package:flutter/material.dart';
import '../controller/auth_controller.dart';

class LoginView extends StatelessWidget {
  LoginView({super.key});

  final AuthController authCtl = AuthController.instance;

  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      backgroundColor: Colors.white,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                authCtl.handleGoogleSignIn();
              },
              child: const Text("구글 로그인"),
            ),
            ElevatedButton(
              onPressed: () {},
              child: const Text("카카오 로그인"),
            ),
          ],
        ),
      ),
    );
  }
}
