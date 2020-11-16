import 'package:firebase_login/screens/home.dart';
import 'package:firebase_login/screens/login/phone_auth/phone_auth.dart';
import 'package:firebase_login/widgets/social_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_login/services/auth.dart' as auth;

class SocialGroupButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SocialButton(
          assetName: 'phone',
          onPressed: () => Get.to(PhoneAuth()),
        ),
        SocialButton(
          assetName: 'google',
          onPressed: () async {
            SharedPreferences sharedPreferences =
                await SharedPreferences.getInstance();
            await auth.signInWithGoogle();

            Get.snackbar(
              'Loading...',
              'Please wait.',
              backgroundColor: Colors.black,
              colorText: Colors.white,
              showProgressIndicator: true,
            );

            Get.off(Home());
            Get.snackbar(
              'Login Success!',
              'Welcome ${sharedPreferences.get('displayName')}.',
              backgroundColor: Colors.black,
              colorText: Colors.white,
            );
          },
        ),
        SocialButton(
          assetName: 'facebook',
          onPressed: () async {
            SharedPreferences sharedPreferences =
                await SharedPreferences.getInstance();
            var login = await auth.signInWithFacebook();

            Get.snackbar(
              'Loading...',
              'Please wait.',
              backgroundColor: Colors.black,
              colorText: Colors.white,
              showProgressIndicator: true,
            );

            if (login is String) {
              Get.snackbar(
                'Login failed!',
                '$login',
                backgroundColor: Colors.black,
                colorText: Colors.white,
              );
            } else {
              Get.off(Home());
              Get.snackbar(
                'Login Success!',
                'Welcome ${sharedPreferences.get('displayName')}.',
                backgroundColor: Colors.black,
                colorText: Colors.white,
              );
            }
          },
        ),
        SocialButton(
          assetName: 'twitter',
          onPressed: () async {
            SharedPreferences sharedPreferences =
                await SharedPreferences.getInstance();
            var login = await auth.signInWithTwitter();

            Get.snackbar(
              'Loading...',
              'Please wait.',
              backgroundColor: Colors.black,
              colorText: Colors.white,
              showProgressIndicator: true,
            );

            if (login is String) {
              Get.snackbar(
                'Login failed!',
                '$login',
                backgroundColor: Colors.black,
                colorText: Colors.white,
              );
            } else {
              Get.off(Home());
              Get.snackbar(
                'Login Success!',
                'Welcome ${sharedPreferences.get('displayName')}.',
                backgroundColor: Colors.black,
                colorText: Colors.white,
              );
            }
          },
        ),
        SocialButton(
          assetName: 'github',
          onPressed: () async {
            SharedPreferences sharedPreferences =
                await SharedPreferences.getInstance();
            var login = await auth.signInWithGithub(context);

            Get.snackbar(
              'Loading...',
              'Please wait.',
              backgroundColor: Colors.black,
              colorText: Colors.white,
              showProgressIndicator: true,
            );

            if (login is String) {
              Get.snackbar(
                'Login failed!',
                '$login',
                backgroundColor: Colors.black,
                colorText: Colors.white,
              );
            } else {
              Get.off(Home());
              Get.snackbar(
                'Login Success!',
                'Welcome ${sharedPreferences.get('displayName')}.',
                backgroundColor: Colors.black,
                colorText: Colors.white,
              );
            }
          },
        ),
      ],
    );
  }
}
