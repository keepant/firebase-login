import 'package:firebase_login/screens/components/social_group_button.dart';
import 'package:firebase_login/screens/home.dart';
import 'package:firebase_login/screens/login/register.dart';
import 'package:firebase_login/screens/login/reset_password.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/route_manager.dart';
import 'package:firebase_login/services/auth.dart' as auth;
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _emailCtrlr = TextEditingController();
  final _passwordCtrlr = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isHidePassword = true;

  _toggleHidePassword() {
    setState(() {
      _isHidePassword = !_isHidePassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: Theme.of(context).primaryColor,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(26.0, 65.0, 0, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.white70,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Sign In',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25.0,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height / 6,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(35.0),
                  topRight: Radius.circular(35.0),
                ),
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(26.0, 56.0, 26.0, 26.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Email',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17.0,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 5.0),
                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          controller: _emailCtrlr,
                          validator: (value) =>
                              value.isEmpty ? 'Email cannot be empty!' : null,
                          decoration: InputDecoration(
                            isDense: true,
                            hintText: 'example@mail.co',
                          ),
                        ),
                        SizedBox(height: 30.0),
                        Text(
                          'Password',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17.0,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 5.0),
                        TextFormField(
                          controller: _passwordCtrlr,
                          obscureText: _isHidePassword,
                          validator: (value) => value.isEmpty
                              ? 'Password cannot be empty!'
                              : value.length <= 5
                                  ? 'Password should be at least 6 characters'
                                  : null,
                          decoration: InputDecoration(
                            isDense: true,
                            hintText: 'Password',
                            suffixIcon: IconButton(
                              icon: Icon(_isHidePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility),
                              onPressed: () => _toggleHidePassword(),
                            ),
                          ),
                        ),
                        SizedBox(height: 30.0),
                        Center(
                          child: InkWell(
                            onTap: () {
                              Get.to(ResetPassword());
                            },
                            child: Text(
                              'Forget password?',
                              style: TextStyle(
                                fontSize: 14.0,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 40.0),
                        InkWell(
                          onTap: () async {
                            FocusScope.of(context).unfocus();
                            SharedPreferences sharedPreferences =
                                await SharedPreferences.getInstance();
                            if (_formKey.currentState.validate()) {
                              String login = await auth.signInWithEmail(
                                email: _emailCtrlr.text,
                                password: _passwordCtrlr.text,
                              );

                              Get.snackbar(
                                'Loading...',
                                'Please wait.',
                                backgroundColor: Colors.black,
                                colorText: Colors.white,
                                showProgressIndicator: true,
                              );

                              if (login == 'Login success!') {
                                Get.off(Home());
                                Get.snackbar(
                                  login,
                                  'Welcome ${sharedPreferences.get('displayName')}.',
                                  backgroundColor: Colors.black,
                                  colorText: Colors.white,
                                );
                              } else {
                                Get.snackbar(
                                  'Login failed!',
                                  login,
                                  backgroundColor: Colors.black,
                                  colorText: Colors.white,
                                );
                              }
                            }
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Center(
                              child: Text(
                                'Sign In',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20.0),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                margin: const EdgeInsets.only(
                                  left: 10.0,
                                  right: 15.0,
                                ),
                                child: Divider(
                                  color: Colors.black,
                                  height: 50,
                                ),
                              ),
                            ),
                            Text(
                              "OR",
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                            Expanded(
                              child: Container(
                                margin: const EdgeInsets.only(
                                  left: 15.0,
                                  right: 10.0,
                                ),
                                child: Divider(
                                  color: Colors.black,
                                  height: 50,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20.0),
                        SocialGroupButton(),
                        SizedBox(height: 50.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Don\'t have an account? '),
                            InkWell(
                              onTap: () => Get.to(Register()),
                              child: Text(
                                'Sign Up',
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20.0),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
