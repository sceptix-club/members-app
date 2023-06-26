import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class memdetails extends StatelessWidget {
  final Map<String, dynamic> memberData;

  memdetails(this.memberData);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Member Details'),
      ),
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
    );
  }
}
