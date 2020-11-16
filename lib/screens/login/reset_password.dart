import 'package:firebase_login/screens/login/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/route_manager.dart';
import 'package:firebase_login/services/auth.dart' as auth;

class ResetPassword extends StatefulWidget {
  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final _emailCtrlr = TextEditingController();
  final _formKey = GlobalKey<FormState>();

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
                    'Reset Password',
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
                            hintText: 'enter your email to reset',
                          ),
                        ),
                        SizedBox(height: 40.0),
                        InkWell(
                          onTap: () async {
                            FocusScope.of(context).unfocus();

                            if (_formKey.currentState.validate()) {
                              String reset = await auth.resetPassword(
                                  email: _emailCtrlr.text);
                              Get.snackbar(
                                'Loading...',
                                'Please wait.',
                                backgroundColor: Colors.black,
                                colorText: Colors.white,
                                showProgressIndicator: true,
                              );

                              if (reset == 'Success!') {
                                Get.to(Login());
                                Get.snackbar(
                                  'Reset password successfully sent to your email!',
                                  'Check your email to reset your password.',
                                  backgroundColor: Colors.black,
                                  colorText: Colors.white,
                                );
                              } else {
                                Get.snackbar(
                                  'Reset password failed!',
                                  reset,
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
                                'Reset Password',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 50.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Already have an account? '),
                            InkWell(
                              onTap: () => Get.to(Login()),
                              child: Text(
                                'Sign In',
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
