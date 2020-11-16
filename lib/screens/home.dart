import 'package:firebase_login/screens/login/login.dart';
import 'package:firebase_login/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_login/services/auth.dart' as auth;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  SharedPreferences sharedPreferences;
  String displayName = '';
  String email;
  bool isVerified = false;

  @override
  void initState() {
    super.initState();
    _getInitData();
  }

  void _getInitData() async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      displayName = sharedPreferences.getString('displayName') ?? '';
      email = sharedPreferences.getString('email');
      isVerified = sharedPreferences.getBool('isVerified') ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: InkWell(
        onTap: () async {
          await auth.signOut();
          Get.off(Login());
          Get.snackbar(
            'Logout success!',
            'Thanks for using app.',
            backgroundColor: Colors.black,
            colorText: Colors.white,
          );
        },
        child: Container(
          margin: EdgeInsets.fromLTRB(46.0, 16.0, 46.0, 36.0),
          width: MediaQuery.of(context).size.width,
          height: 50,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Center(
            child: Text(
              'Sign Out',
              style: TextStyle(
                color: Colors.white,
                fontSize: 17.0,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: displayName == null
          ? Loading()
          : SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipPath(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height / 2.5,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                        image: AssetImage('assets/images/profile.png'),
                        fit: BoxFit.cover,
                      )),
                    ),
                    clipper: ClipShape(),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 36.0, 16.0, 0.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          displayName == ''
                              ? 'Phone Number User'
                              : displayName.toUpperCase(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 19.0,
                          ),
                        ),
                        _verificationBadge(
                          onTap: () {
                            if (isVerified) {
                              Get.dialog(
                                AlertDialog(
                                  title: Text(
                                    'Your account is verified.',
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              );
                            } else {
                              Get.dialog(
                                AlertDialog(
                                  title: Text(
                                    'Verified your account',
                                    textAlign: TextAlign.center,
                                  ),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'We will send verification link to your email.',
                                        textAlign: TextAlign.center,
                                      ),
                                      SizedBox(height: 20.0),
                                      InkWell(
                                        onTap: () async {
                                          auth.sendVerification();
                                          Get.back();
                                          Get.snackbar(
                                            'Email verification successfully sent to your email!',
                                            'Check your email to verify your acount.',
                                            backgroundColor: Colors.black,
                                            colorText: Colors.white,
                                          );
                                        },
                                        child: Container(
                                          margin: EdgeInsets.fromLTRB(
                                              46.0, 16.0, 46.0, 0.0),
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: 50,
                                          decoration: BoxDecoration(
                                            color:
                                                Theme.of(context).primaryColor,
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          child: Center(
                                            child: Text(
                                              'Send verification link',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 17.0,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }
                          },
                          isVerified: isVerified,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    child: Text(
                      email ?? 'Unknown',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Divider(
                      thickness: 2.0,
                      color: Colors.black,
                    ),
                  )
                ],
              ),
            ),
    );
  }
}

class ClipShape extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height);
    path.quadraticBezierTo(
        size.width / 1.7, size.height - 90, size.width / 1.4, size.height - 20);
    path.quadraticBezierTo(
        3 / 4 * size.width, size.height, size.width, size.height - 35);
    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

Widget _verificationBadge({GestureTapCallback onTap, bool isVerified}) {
  return Material(
    child: InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
        decoration: BoxDecoration(
          color: isVerified ? Colors.green : Colors.red,
          border: Border.all(color: isVerified ? Colors.green : Colors.red),
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Icon(
              isVerified ? Icons.check_circle_sharp : Icons.close_sharp,
              color: Colors.white,
            ),
            SizedBox(
              width: 5,
            ),
            Text(
              isVerified ? 'Verified' : 'Not Verified',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
