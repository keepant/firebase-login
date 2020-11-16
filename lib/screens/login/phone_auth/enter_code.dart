import 'dart:async';
import 'package:firebase_login/screens/home.dart';
import 'package:firebase_login/screens/login/login.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:firebase_login/services/auth.dart' as auth;

class EnterCode extends StatefulWidget {
  final String verificationId;
  final int resendToken;

  const EnterCode({
    Key key,
    this.verificationId,
    this.resendToken,
  }) : super(key: key);

  @override
  _EnterCodeState createState() => _EnterCodeState();
}

class _EnterCodeState extends State<EnterCode> {
  TextEditingController _codeCtrlr = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  // ignore: close_sinks
  StreamController<ErrorAnimationType> _errorController;
  bool hasError = false;

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
                          'Enter OTP Code',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17.0,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 15.0),
                        PinCodeTextField(
                          appContext: context,
                          pastedTextStyle: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                          length: 6,
                          obscureText: false,
                          obscuringCharacter: '*',
                          animationType: AnimationType.fade,
                          pinTheme: PinTheme(
                            shape: PinCodeFieldShape.circle,
                            borderRadius: BorderRadius.circular(5),
                            inactiveFillColor: Colors.white,
                            selectedFillColor: Colors.white,
                            selectedColor: Colors.orange,
                            fieldHeight: 60,
                            fieldWidth: 50,
                            activeFillColor:
                                hasError ? Colors.red : Colors.white,
                          ),
                          cursorColor: Colors.black,
                          animationDuration: Duration(milliseconds: 300),
                          textStyle: TextStyle(fontSize: 20, height: 1.6),
                          enableActiveFill: true,
                          errorAnimationController: _errorController,
                          controller: _codeCtrlr,
                          keyboardType: TextInputType.number,
                          boxShadows: [
                            BoxShadow(
                              offset: Offset(0, 1),
                              color: Colors.black12,
                              blurRadius: 10,
                            )
                          ],
                          onCompleted: (v) {
                            print("Completed");
                          },
                          onChanged: (value) {
                            print(value);
                          },
                          beforeTextPaste: (text) {
                            print("Allowing to paste $text");
                            return true;
                          },
                        ),
                        SizedBox(height: 40.0),
                        InkWell(
                          onTap: () async {
                            FocusScope.of(context).unfocus();

                            if (_formKey.currentState.validate()) {
                              var user = await auth.authPhone(
                                verificationId: widget.verificationId,
                                resendToken: widget.resendToken,
                                smsCode: _codeCtrlr.text,
                              );

                              if (user != null) {
                                Get.off(Home());
                                Get.snackbar(
                                  'Login Success!',
                                  'Welcome to app.',
                                  backgroundColor: Colors.black,
                                  colorText: Colors.white,
                                );
                              } else {
                                Get.snackbar(
                                  'Login Failed!',
                                  'Check your OTP code.',
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

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<StreamController<ErrorAnimationType>>(
        '_errorController', _errorController));
  }
}
