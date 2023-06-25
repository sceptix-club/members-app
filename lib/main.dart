import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}
class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Home Page'
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('members').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text('Loading...');
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (BuildContext context, int index) {
              DocumentSnapshot document = snapshot.data!.docs[index];
              String documentId = document.id;
              return GetStudentName(documentId);
            },
          );
        },
      ),
    );
  }
}

class GetStudentName extends StatelessWidget {
  final String documentId;

  GetStudentName(this.documentId);

  @override
  Widget build(BuildContext context) {
    CollectionReference members = FirebaseFirestore.instance.collection('members');

    return FutureBuilder<DocumentSnapshot>(
      //Fetching data from the documentId specified of the student
      future: members.doc(documentId).get(),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        //Error Handling conditions
        if (snapshot.hasError) {
          return const Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return const Text("Document does not exist");
        }

        //Data is output to the user
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
          dynamic dobValue = data['DOB'];
          String sDOB = dobValue.toString();

          return ListTile(
            title: Text(data['Name']),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(data['Number'].toString()),
              ],
            ),
          );
        }

        return const Text("Loading...");
      },
    );
  }
}