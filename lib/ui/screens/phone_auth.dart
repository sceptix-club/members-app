import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rive/rive.dart';
import 'package:sceptixapp/main.dart';
import 'package:sceptixapp/ui/screens/login.dart';
import '../../globals/colors.dart';
import '../../globals/common.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';

String hashPassword(String password) {
  final bytes = utf8.encode(password);
  final digest = sha256.convert(bytes);
  return digest.toString();
}

class PhoneAuth extends StatefulWidget {
  const PhoneAuth({Key? key});

  @override
  State<PhoneAuth> createState() => _PhoneAuthState();
}

class _PhoneAuthState extends State<PhoneAuth> {
  final _phoneCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  String? lastVerificationId;
  String? phoneNumber;

  void _sendOtp() async {
    try {
      final phone = '+${_phoneCtrl.text}';
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phone,
        verificationCompleted: (PhoneAuthCredential credentials) async {
          final firebaseCredential =
              await FirebaseAuth.instance.signInWithCredential(credentials);
          final user = firebaseCredential.user;
          if (user == null) {
            if (mounted) {
              showSnackBar(context, "Sign in error", Duration(seconds: 3));
            }
          } else {
            if (mounted) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (cxt) => MyHomePage()),
                (route) => false,
              );
            }
          }
        },
        verificationFailed: (FirebaseAuthException error) {
          print(error);
        },
        codeSent: (String verificationId, int? forceResendingToken) {
          setState(() {
            lastVerificationId = verificationId;
          });
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          if (mounted) {
            setState(() {
              lastVerificationId = verificationId;
            });
          }
        },
      );
    } catch (e) {
      print(e);
    }
  }

  void _verifyOtp(String? smsCode) async {
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: lastVerificationId!,
        smsCode: smsCode!,
      );
      final firebaseCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      final user = firebaseCredential.user;
      if (user == null) {
        if (mounted) {
          showSnackBar(context, "Error", const Duration(seconds: 3));
        }
      } else {
        if (mounted) {
          phoneNumber = _phoneCtrl.text;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (cxt) => PasswordSetup(user, phoneNumber!, lastVerificationId!, smsCode!),
            ),
          );
        }
      }
    } on FirebaseAuthException catch (e) {
      print(e.code);
      showSnackBar(context, e.code, const Duration(seconds: 3));
    } catch (e) {
      print(e);
      showSnackBar(context, e.toString(), const Duration(seconds: 3));
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Phone Auth'),
          backgroundColor: Colors.transparent,
          //elevation: 0,
        ),
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    "assets/images/podium-abstract-splines-on-white-260nw-2121765374.jpg",
                  ),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: const SizedBox(),
              ),
            ),
            RiveAnimation.asset(
              "assets/RiveAssets/shapes.riv",
            ),
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                child: const SizedBox(),
              ),
            ),
            SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: 20, right: 20, top: 80, bottom: 40),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Sign up',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.darkGrey1,
                            ),
                          ),
                          Text(
                            "Enter your phone number",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: AppColors.darkGrey1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Form(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: Colors.white,
                            ),
                            child: TextFormField(
                              controller: _phoneCtrl,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Enter phone number',
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 16.0),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          InkWell(
                            onTap: _sendOtp,
                            child: Container(
                              padding: const EdgeInsets.only(top: 12, bottom: 12),
                              margin: const EdgeInsets.only(top: 8, bottom: 8, left: 15, right: 15),
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(25),
                                  bottomRight: Radius.circular(25),
                                  bottomLeft: Radius.circular(25),
                                ),
                                color: const Color(0xFFF77D8E),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    CupertinoIcons.arrow_right,
                                    color: Color(0xFFFE0037),
                                  ),
                                  const SizedBox(width: 8),
                                  const Text(
                                    'Send OTP',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  lastVerificationId == null
                      ? Container()
                      : Container(
                          padding: const EdgeInsets.only(top: 30, bottom: 0),
                          child: const Text(
                            'Enter OTP',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.darkGrey1,
                            ),
                          ),
                        ),
                  lastVerificationId == null
                      ? Container()
                      : Container(
                          padding: const EdgeInsets.only(top: 12, bottom: 12),
                          margin: const EdgeInsets.only(
                              top: 20, bottom: 20, left: 15, right: 15),
                          child: Center(
                            child: Pinput(
                              length: 6,
                              defaultPinTheme: PinTheme(
                                width: 45,
                                height: 45,
                                textStyle: const TextStyle(
                                  fontSize: 20,
                                  color: Color.fromRGBO(30, 60, 87, 1),
                                  fontWeight: FontWeight.w600,
                                ),
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.white, width: 3),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              focusedPinTheme: PinTheme(
                                width: 45,
                                height: 45,
                                textStyle: const TextStyle(
                                  fontSize: 20,
                                  color: Color.fromRGBO(30, 60, 87, 1),
                                  fontWeight: FontWeight.w600,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.lightBlue, width: 3),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              errorPinTheme: PinTheme(
                                width: 45,
                                height: 45,
                                textStyle: const TextStyle(
                                  fontSize: 20,
                                  color: Color.fromRGBO(30, 60, 87, 1),
                                  fontWeight: FontWeight.w600,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: AppColors.red, width: 3),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              pinputAutovalidateMode:
                                  PinputAutovalidateMode.onSubmit,
                              showCursor: true,
                              onCompleted: (pin) {
                                _verifyOtp(pin);
                              },
                            ),
                          ),
                        ),
                ],
              ),
            )
          ],
        ));
  }
}

class PasswordSetup extends StatefulWidget {
  final User user;
  final String phoneNumber;
  final String verificationId;
  final String smsCode;

  PasswordSetup(this.user, this.phoneNumber, this.verificationId, this.smsCode);

  @override
  _PasswordSetupState createState() => _PasswordSetupState();
}


class _PasswordSetupState extends State<PasswordSetup> {
  final _passwordCtrl = TextEditingController();
  final _confirmPasswordCtrl = TextEditingController();

  void _handleSavePassword() async {
    final password = _passwordCtrl.text;
    final confirmPassword = _confirmPasswordCtrl.text;

    if (password.isEmpty || confirmPassword.isEmpty) {
      showSnackBar(
        context,
        'Please fill in all fields.',
        const Duration(seconds: 3),
      );
      return;
    }

    if (password != confirmPassword) {
      showSnackBar(
        context,
        'Passwords do not match.',
        const Duration(seconds: 3),
      );
      return;
    }

    try {
      final phoneAuthCredential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId, // Verification ID from phone verification
        smsCode: widget.smsCode, // SMS code from phone verification
      );

      final firebaseCredential = await FirebaseAuth.instance
          .signInWithCredential(phoneAuthCredential);

      final user = firebaseCredential.user;

      if (user == null) {
        showSnackBar(
          context,
          'Error signing in with phone number.',
          const Duration(seconds: 3),
        );
        return;
      }

      // Update the user's password
      await user.updatePassword(password);

      // Navigate to the desired screen after successful authentication
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Login()),
      );
    } catch (e) {
      print(e);
      showSnackBar(context, 'An error occurred.', const Duration(seconds: 3));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Password Setup'),
        backgroundColor: Colors.transparent,
        // elevation: 0,
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  "assets/images/podium-abstract-splines-on-white-260nw-2121765374.jpg",
                ),
                fit: BoxFit.fill,
              ),
            ),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: const SizedBox(),
            ),
          ),
          RiveAnimation.asset(
            "assets/RiveAssets/shapes.riv",
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
              child: const SizedBox(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Set a password',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: _passwordCtrl,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Password',
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: _confirmPasswordCtrl,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Confirm Password',
                  ),
                ),
                SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.only(right: 63, left: 64),
                  child: ElevatedButton.icon(
                    onPressed: _handleSavePassword,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 46),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(25),
                          bottomRight: Radius.circular(25),
                          bottomLeft: Radius.circular(25),
                        ),
                      ),
                    ),
                    icon: const Icon(
                      CupertinoIcons.arrow_right,
                      color: Color(0xFFFE0037),
                    ),
                    label: const Text("Save Password"),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
