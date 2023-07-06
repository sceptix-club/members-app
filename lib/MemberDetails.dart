import 'package:flutter/material.dart';

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
                  image: AssetImage('assets/background(temp).png'),
                  fit: BoxFit.cover,
                ),
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
