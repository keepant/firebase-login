import 'package:firebase_login/screens/login/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/route_manager.dart';
import 'package:firebase_login/services/auth.dart' as auth;

class PhoneAuth extends StatefulWidget {
  @override
  _PhoneAuthState createState() => _PhoneAuthState();
}

class _PhoneAuthState extends State<PhoneAuth> {
  final _phoneNumberCtrlr = TextEditingController();
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
                          'Phone number',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17.0,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 5.0),
                        TextFormField(
                          keyboardType: TextInputType.phone,
                          controller: _phoneNumberCtrlr,
                          validator: (value) => value.isEmpty
                              ? 'Phone number cannot be empty!'
                              : null,
                          decoration: InputDecoration(
                            isDense: true,
                            hintText: 'enter your phone number with country code',
                          ),
                        ),
                        SizedBox(height: 40.0),
                        InkWell(
                          onTap: () async {
                            FocusScope.of(context).unfocus();

                            if (_formKey.currentState.validate()) {
                              auth.signInWithPhone(phoneNumber: _phoneNumberCtrlr.text.trim());
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
                                'Continue',
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
