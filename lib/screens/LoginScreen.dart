import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nitkazez/screens/HomeScreen.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

enum MobileVerificationState {
  SHOW_MOBILE_FORM_STATE,
  SHOW_OTP_FORM_STATE,
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  MobileVerificationState currentState =
      MobileVerificationState.SHOW_MOBILE_FORM_STATE;

  // final phoneController = TextEditingController();
  String verificationCode = '';
  String phoneNumber = '';

  FirebaseAuth _auth = FirebaseAuth.instance;

  String verificationId = '';

  bool showLoading = false;

  void signInWithPhoneAuthCredential(
      PhoneAuthCredential phoneAuthCredential) async {
    setState(() {
      showLoading = true;
    });

    try {
      final authCredential =
          await _auth.signInWithCredential(phoneAuthCredential);

      setState(() {
        showLoading = false;
      });

      if (authCredential.user != null) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomeScreen()));
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        showLoading = false;
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text((e.message)!)));
    }
  }

  getMobileFormWidget(BuildContext context) {
    return Column(
      children: [
        Spacer(),
        // TextField(
        //   controller: phoneController,
        //   decoration: InputDecoration(
        //     hintText: "Phone Number",
        //   ),
        // ),
        IntlPhoneField(
          decoration: InputDecoration(
            labelText: 'Phone Number',
            border: OutlineInputBorder(
              borderSide: BorderSide(),
            ),
          ),
          initialCountryCode: 'IL',
          onChanged: (phone) {
            setState(() {
              phoneNumber = phone.completeNumber;
            });
          },
        ),
        SizedBox(
          height: 16,
        ),
        TextButton(
            onPressed: () async {
              setState(() {
                showLoading = true;
              });

              await _auth.verifyPhoneNumber(
                // phoneNumber: phoneController.text,
                phoneNumber: phoneNumber,
                verificationCompleted: (phoneAuthCredential) async {
                  setState(() {
                    showLoading = false;
                  });
                  //signInWithPhoneAuthCredential(phoneAuthCredential)
                },
                verificationFailed: (verificationFailed) async {
                  setState(() {
                    showLoading = false;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text((verificationFailed.message)!)));
                },
                codeSent: (verificatoinId, resendingToken) async {
                  setState(() {
                    showLoading = false;
                    currentState = MobileVerificationState.SHOW_OTP_FORM_STATE;
                    this.verificationId = verificatoinId;
                  });
                },
                codeAutoRetrievalTimeout: (verificationId) async {},
              );
            },
            child: Text("Send")),
        Spacer(),
      ],
    );
  }

  getOtpFormWidget(BuildContext context) {
    return Column(
      children: [
        Spacer(),
        PinCodeTextField(
          appContext: context,
          length: 6,
          onChanged: (String value) {
            setState(() {
              verificationCode = value;
            });
          },
          keyboardType: TextInputType.number,
        ),
        // TextField(
        //   controller: otpController,
        //   decoration: InputDecoration(
        //     hintText: "Verification Code",
        //   ),
        //   keyboardType: TextInputType.number,
        // ),
        SizedBox(
          height: 16,
        ),
        TextButton(
            onPressed: () async {
              PhoneAuthCredential phoneAuthCredential =
                  PhoneAuthProvider.credential(
                      verificationId: this.verificationId,
                      smsCode: this.verificationCode);

              signInWithPhoneAuthCredential(phoneAuthCredential);
            },
            child: Text("Verify")),
        Spacer(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      child: showLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : currentState == MobileVerificationState.SHOW_MOBILE_FORM_STATE
              ? getMobileFormWidget(context)
              : getOtpFormWidget(context),
      padding: const EdgeInsets.all(16),
    ));
  }
}
