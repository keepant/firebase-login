import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_login/screens/login/phone_auth/enter_code.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_twitter_login/flutter_twitter_login.dart';
import 'package:get/route_manager.dart';
import 'package:github_sign_in/github_sign_in.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

FirebaseAuth auth = FirebaseAuth.instance;
SharedPreferences sharedPreferences;

Future<String> registerUser({
  String displayName,
  String email,
  String password,
}) async {
  String _errorMessage;
  User _user;
  try {
    _user = (await auth.createUserWithEmailAndPassword(
            email: email, password: password))
        .user;

    _user.updateProfile(displayName: displayName);
    _user.sendEmailVerification();
  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      _errorMessage = 'The password provided is too weak.';
    } else if (e.code == 'email-already-in-use') {
      _errorMessage = 'The account already exists for that email.';
    } else if (e.code == 'invalid-email') {
      _errorMessage = 'The email address is badly formatted.';
    } else {
      _errorMessage = e.message;
    }
  }

  if (_errorMessage != null) {
    return _errorMessage;
  }

  return 'Register success!';
}

Future<String> signInWithEmail({
  String email,
  String password,
}) async {
  String _errorMessage;
  User _user;
  sharedPreferences = await SharedPreferences.getInstance();
  try {
    _user = (await auth.signInWithEmailAndPassword(
            email: email, password: password))
        .user;
    sharedPreferences.setBool('isLogin', true);
    sharedPreferences.setString('displayName', _user.displayName);
    sharedPreferences.setString('email', _user.email);
    sharedPreferences.setBool('isVerified', _user.emailVerified);
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      _errorMessage = 'No user found with the credential.';
    } else if (e.code == 'wrong-password') {
      _errorMessage = 'The password is wrong.';
    } else if (e.code == 'invalid-email') {
      _errorMessage = 'The email address is badly formatted.';
    } else {
      _errorMessage = e.message;
    }
  }

  if (_errorMessage != null) {
    return _errorMessage;
  }

  return 'Login success!';
}

Future<String> resetPassword({String email}) async {
  String _errorMessage;
  try {
    await auth.sendPasswordResetEmail(email: email);
  } on FirebaseAuthException catch (e) {
    _errorMessage = e.message;
  }

  if (_errorMessage != null) {
    return _errorMessage;
  }

  return 'Success!';
}

Future<void> sendVerification() async {
  User user = auth.currentUser;
  await user.sendEmailVerification();
}

Future<dynamic> signInWithPhone({
  String phoneNumber,
}) async {
  String _errorMessage;
  UserCredential userCredential;
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  try {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        userCredential = await auth.signInWithCredential(credential);

        sharedPreferences.setBool('isLogin', true);
        sharedPreferences.setString(
            'displayName', userCredential.user.displayName);
        sharedPreferences.setString('email', userCredential.user.phoneNumber);
        sharedPreferences.setBool(
            'isVerified', userCredential.user.emailVerified);
      },
      verificationFailed: (FirebaseAuthException e) {
        print(e.message);
        _errorMessage = e.message;
        Get.snackbar(
          'Login failed!',
          e.message,
          backgroundColor: Colors.black,
          colorText: Colors.white,
        );
      },
      codeSent: (String verificationId, int resendToken) {
        Get.to(
          EnterCode(
            verificationId: verificationId,
            resendToken: resendToken,
          ),
        );
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  } on FirebaseAuthException catch (e) {
    _errorMessage = e.message;
  }

  if (_errorMessage != null) {
    return _errorMessage;
  }

  return userCredential;
}

Future<UserCredential> authPhone({
  String verificationId,
  String smsCode,
  int resendToken,
}) async {
  PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
      verificationId: verificationId, smsCode: smsCode);
  return await auth.signInWithCredential(phoneAuthCredential);
}

Future<dynamic> signInWithGoogle() async {
  String _errorMessage;
  UserCredential userCredential;
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  try {
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final GoogleAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);

    sharedPreferences.setBool('isLogin', true);
    sharedPreferences.setString('displayName', userCredential.user.displayName);
    sharedPreferences.setString('email', userCredential.user.email);
    sharedPreferences.setBool('isVerified', userCredential.user.emailVerified);
  } on FirebaseAuthException catch (e) {
    _errorMessage = e.message;
  }

  if (_errorMessage != null) {
    return _errorMessage;
  }

  return userCredential;
}

Future<dynamic> signInWithTwitter() async {
  String _errorMessage;
  UserCredential userCredential;
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

  try {
    final TwitterLogin twitterLogin = new TwitterLogin(
      consumerKey: 'consumer-key',
      consumerSecret: 'consumer-secret',
    );
    final TwitterLoginResult loginResult = await twitterLogin.authorize();

    final TwitterSession twitterSession = loginResult.session;

    final AuthCredential twitterAuthCredential = TwitterAuthProvider.credential(
        accessToken: twitterSession.token, secret: twitterSession.secret);
    userCredential =
        await FirebaseAuth.instance.signInWithCredential(twitterAuthCredential);

    sharedPreferences.setBool('isLogin', true);
    sharedPreferences.setString('displayName', userCredential.user.displayName);
    sharedPreferences.setString('email', userCredential.user.email);
    sharedPreferences.setBool('isVerified', userCredential.user.emailVerified);
  } on FirebaseAuthException catch (e) {
    _errorMessage = e.message;
  }

  if (_errorMessage != null) {
    return _errorMessage;
  }

  return userCredential;
}

Future<dynamic> signInWithFacebook() async {
  String _errorMessage;
  UserCredential userCredential;
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

  try {
    final result = await FacebookAuth.instance.login();

    final FacebookAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(result.token);

    userCredential = await FirebaseAuth.instance
        .signInWithCredential(facebookAuthCredential);

    sharedPreferences.setBool('isLogin', true);
    sharedPreferences.setString('displayName', userCredential.user.displayName);
    sharedPreferences.setString('email', userCredential.user.email);
    sharedPreferences.setBool('isVerified', userCredential.user.emailVerified);
  } on FirebaseAuthException catch (e) {
    _errorMessage = e.message;
  }

  if (_errorMessage != null) {
    return _errorMessage;
  }

  return userCredential;
}

Future<dynamic> signInWithGithub(context) async {
  String _errorMessage;
  UserCredential userCredential;
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

  try {
    final GitHubSignIn gitHubSignIn = GitHubSignIn(
      clientId: 'client-id',
      clientSecret: 'client-secret',
      redirectUrl: 'https://yourapp.firebaseapp.com/__/auth/handler',
    );

    final result = await gitHubSignIn.signIn(context);

    final AuthCredential githubAuthCredential =
        GithubAuthProvider.credential(result.token);

    userCredential =
        await FirebaseAuth.instance.signInWithCredential(githubAuthCredential);

    sharedPreferences.setBool('isLogin', true);
    sharedPreferences.setString('displayName', userCredential.user.displayName);
    sharedPreferences.setString('email', userCredential.user.email);
    sharedPreferences.setBool('isVerified', userCredential.user.emailVerified);
  } on FirebaseAuthException catch (e) {
    _errorMessage = e.message;
  }

  if (_errorMessage != null) {
    return _errorMessage;
  }

  return userCredential;
}

Future<void> signOut() async {
  sharedPreferences = await SharedPreferences.getInstance();
  sharedPreferences.clear();
  await auth.signOut();
  await GoogleSignIn().signOut();
}
