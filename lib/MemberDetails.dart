import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class MemberDetails extends StatelessWidget {
  final Map<String, dynamic> memberData;

  MemberDetails(this.memberData);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              decoration: const BoxDecoration(
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
            Container(
              padding: const EdgeInsets.only(top: 40.0),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Name: ${memberData['fullName']}',
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Github: ${memberData['githubUsername']}',
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Email: ${memberData['email']}',
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 30),
                    Text(
                      'Desgination: ${memberData['designation']}',
                      style: const TextStyle(color: Colors.white),
                    ),
                    SizedBox(
                      width: 200,
                      height: 200,
                      child: Image.network(memberData['image']),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
