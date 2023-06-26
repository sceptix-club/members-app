import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class memberDetails extends StatelessWidget {
  final Map<String, dynamic> memberData;

  memberDetails(this.memberData);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Name: ${memberData['Name']}'),
              SizedBox(height: 10),
              Text('Number: ${memberData['Number']}'),
              SizedBox(height: 10),
              Text('Score: ${memberData['Score']}'),
            ],
          ),
        ),
      ),
    );
  }
}
