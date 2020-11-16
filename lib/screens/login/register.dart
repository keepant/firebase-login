import 'package:firebase_login/screens/components/social_group_button.dart';
import 'package:firebase_login/screens/login/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/route_manager.dart';
import 'package:firebase_login/services/auth.dart' as auth;

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _emailCtrlr = TextEditingController();
  final _passwordCtrlr = TextEditingController();
  final _nameCtrlr = TextEditingController();
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
                    'Sign Up',
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
                          'Name',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17.0,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 5.0),
                        TextFormField(
                          keyboardType: TextInputType.text,
                          controller: _nameCtrlr,
                          validator: (value) =>
                              value.isEmpty ? 'Name cannot be empty!' : null,
                          decoration: InputDecoration(
                            isDense: true,
                            hintText: 'John Cena',
                          ),
                        ),
                        SizedBox(height: 30.0),
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
                            errorStyle: TextStyle(
                              color: Colors.red,
                            ),
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
                        SizedBox(height: 40.0),
                        InkWell(
                          onTap: () async {
                            FocusScope.of(context).unfocus();
                            if (_formKey.currentState.validate()) {
                              String register = await auth.registerUser(
                                displayName: _nameCtrlr.text,
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

                              if (register == 'Register success!') {
                                Get.to(Login());
                                Get.snackbar(
                                  register,
                                  'Sign in with your account now.',
                                  backgroundColor: Colors.black,
                                  colorText: Colors.white,
                                );
                              } else {
                                Get.snackbar(
                                  'Register failed!',
                                  register,
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
                                'Sign Up',
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
