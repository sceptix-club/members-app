import 'dart:io';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:sceptixapp/memdetails.dart';
import 'memdetails.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String sortingField = 'RolePriority'; // Default sorting field
  bool sortAscending = true; // Default sorting order

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background(temp).png'),
                fit: BoxFit
                    .cover, // Ensure the image covers the entire container
              ),
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  DropdownButtonFormField<String>(
                    value: sortingField,
                    items: const [
                      DropdownMenuItem<String>(
                        value: 'RolePriority',
                        child: Text('Sort by Role'),
                      ),
                      DropdownMenuItem<String>(
                        value: 'Score',
                        child: Text('Sort by Score'),
                      ),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        // Update the sorting field
                        setState(() {
                          sortingField = value;
                          // Update the sorting order
                          sortAscending = value ==
                              'RolePriority'; // Set sortAscending to true for 'Role' field, false otherwise
                        });
                      }
                    },
                  ),
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('members')
                        .orderBy(sortingField, descending: !sortAscending)
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Text('Loading...');
                      }

                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (BuildContext context, int index) {
                          DocumentSnapshot document =
                              snapshot.data!.docs[index];
                          String documentId = document.id;
                          return GetStudentName(documentId);
                        },
                      );
                    },
                  ),
                ],
              ),
            )),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor:
              Color(0xFF222222), // Set the overall background color
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Members',
            ),
          ],
          selectedItemColor: Colors.grey,
          unselectedItemColor: const Color(0xFFFFFFFF),
        ),
      ),
    );
  }
}

class GetStudentName extends StatelessWidget {
  final String documentId;

  GetStudentName(this.documentId);

  @override
  Widget build(BuildContext context) {
    CollectionReference members =
        FirebaseFirestore.instance.collection('members');

    return FutureBuilder<DocumentSnapshot>(
      // Fetching data from the documentId specified for the student
      future: members.doc(documentId).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        // Error Handling conditions
        if (snapshot.hasError) {
          return const Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return const Text("Document does not exist");
        }

        // Data is output to the user
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;

          return GestureDetector(
            onTap: () {
              // Navigate to the desired page when the box is clicked
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => memberDetails(
                      data), // Pass the data to the member details page
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Card(
                color: Colors.grey[200],
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data['Name'],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              data['Role'],
                              style: const TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const SizedBox(height: 8),
                          Text(
                            data['Score'].toString(),
                            style: const TextStyle(
                                fontSize: 20,
                                color: Colors.deepOrange,
                                fontWeight: FontWeight.w900),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }

        return const Text("Loading...");
      },
    );
  }
}
