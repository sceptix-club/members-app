import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import '../Components/animated_btn.dart';
import '../main.dart';
//import 'login.dart';

class OnbodingScreen extends StatefulWidget {
  const OnbodingScreen({super.key});

  @override
  State<OnbodingScreen> createState() => _OnbodingScreenState();
}

class _OnbodingScreenState extends State<OnbodingScreen> {
  late RiveAnimationController _btnAnimationController;

  bool isShowSignInDialog = false;

  @override
  void initState() {
    _btnAnimationController = OneShotAnimation(
      "active",
      autoplay: false,
    );
    super.initState();
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
          AnimatedPositioned(
            top: isShowSignInDialog ? -50 : 0,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            duration: const Duration(milliseconds: 260),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Spacer(),
                    SizedBox(
                      width: 300,
                      child: Column(
                        children: [
                          RichText(
                            text: TextSpan(
                              text: 'The ',
                              style: TextStyle(
                                fontSize: 60,
                                fontWeight: FontWeight.w700,
                                fontFamily: "Poppins",
                                color: Colors.black,
                                height: 1.2,
                              ),
                              children: [
                                TextSpan(
                                  text: 's',
                                  style: TextStyle(
                                    color: Colors.pinkAccent,
                                  ),
                                ),
                                TextSpan(
                                  text: 'c',
                                  style: TextStyle(
                                    color: Colors.blue,
                                  ),
                                ),
                                TextSpan(
                                  text: 'e',
                                  style: TextStyle(
                                    color: Colors.pinkAccent,
                                  ),
                                ),
                                TextSpan(
                                  text: 'p',
                                  style: TextStyle(
                                    color: Colors.blue,
                                  ),
                                ),
                                TextSpan(
                                  text: 't',
                                  style: TextStyle(
                                    color: Colors.pinkAccent,
                                  ),
                                ),
                                TextSpan(
                                  text: 'i',
                                  style: TextStyle(
                                    color: Colors.blue,
                                  ),
                                ),
                                TextSpan(
                                  text: 'x',
                                  style: TextStyle(
                                    color: Colors.pinkAccent,
                                  ),
                                ),
                                TextSpan(
                                  text: ' club',
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 16),
                          Text(
                            "Welcome to The sceptix club, where freedom and innovation converge. We are a open source software club. Together, we have witnessed the transformative power of collaboration and the limitless possibilities it brings. Join us at The sceptix club and let's celebrate the journey of freedom, creativity, and boundless minds.",
                            textAlign: TextAlign.justify,
                          ),
                        ],
                      ),
                    ),
                    const Spacer(flex: 2),
                    AnimatedBtn(
                      btnAnimationController: _btnAnimationController,
                      press: () {
                        _btnAnimationController.isActive = true;

                        Future.delayed(
                          const Duration(milliseconds: 800),
                          () {
                            setState(() {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (cxt) => MyHomePage()),
                              );
                            });
                          },
                        );
                      },
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 24),
                      child: Text(
                        "A college-level club in St Joseph Engineering College that promotes the use of Free and Open Source Software."),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
