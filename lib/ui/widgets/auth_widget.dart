import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:rive/rive.dart';
import 'package:sceptixapp/Events.dart';
import '../screens/About.dart';
// import '../screens/home.dart';
// import '../screens/login.dart';

class AuthWidget extends StatefulWidget {
  const AuthWidget({Key? key});

  @override
  State<AuthWidget> createState() => _AuthWidgetState();
}

class _AuthWidgetState extends State<AuthWidget> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 4), () {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (cxt) => const OnbodingScreen()));
      } else {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (cxt) => const EventsPage()));
      }
      //EventsPage
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    "assets/images/podium-abstract-splines-on-white-260nw-2121765374.jpg"),
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
          const RiveAnimation.asset(
            "assets/RiveAssets/shapes.riv",
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
              child: const SizedBox(),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 180,
                  padding: const EdgeInsets.all(8.0),
                  child:
                      Image.asset("assets/images/sceptix_logo_mini_black.png"),
                ),
                Container(
                  width: 180,
                  padding: const EdgeInsets.all(8.0),
                  child: const SpinKitSpinningLines(
                    color: Colors.black,
                    size: 100.0,
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
