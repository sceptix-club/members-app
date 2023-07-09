import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:rive/rive.dart';
import 'package:sceptixapp/ui/widgets/auth_widget.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'MemberDetails.dart';
import 'Events.dart';

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
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthWidget(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String sortingField = 'rolePriority'; // Default sorting field
  bool sortDescending = true; // Default sorting order
  var db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
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
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      DropdownButtonFormField<String>(
                        value: sortingField,
                        decoration: const InputDecoration(
                          filled: true,
                          fillColor: Colors
                              .white, // You can further customize the appearance using other InputDecoration properties
                        ),
                        items: const [
                          DropdownMenuItem<String>(
                            value: 'rolePriority',
                            child: Text('Sort by Role'),
                          ),
                          DropdownMenuItem<String>(
                            value: 'score',
                            child: Text('Sort by Score'),
                          ),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            // Update the sorting fie ld
                            setState(() {
                              sortingField = value;
                              // Update the sorting order
                              sortDescending = value == 'rolePriority';
                            });
                          }
                        },
                      ),
                      StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('members')
                            .orderBy(sortingField, descending: sortDescending)
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          }

                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
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
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor:
              const Color(0xFF222222), // Set the overall background color
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.account_tree_outlined),
              label: 'Events',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Members',
            ),
          ],
          selectedItemColor: Colors.grey,
          unselectedItemColor: const Color(0xFFFFFFFF),
          onTap: (int index) {
            if (index == 0) {
              // Navigate to the Events page
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EventsPage(),
                ),
              );
            }
          },
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
                  builder: (context) => MemberDetails(
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
                      CircleAvatar(
                        radius: 25,
                        backgroundImage: NetworkImage(data['image']),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data['fullName'],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              data['designation'],
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
                            data['score'].toString(),
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
