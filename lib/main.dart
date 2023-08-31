import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rive/rive.dart';
import 'package:sceptixapp/ui/screens/login.dart';
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
  int _selectedIndex = 0;
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
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 120.0),
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(8.0), // Add border
                    ),
                    child: DropdownButton<String>(
                      value: sortingField,
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            sortingField = value;
                            sortDescending = value == 'rolePriority';
                          });
                        }
                      },
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
                    ),
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
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: const Color(0xFF222222),
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
          currentIndex: _selectedIndex, // Make sure to set the selected index
          onTap: (int index) {
            setState(() {
              _selectedIndex = index; // Update the selected index
            });

            if (index == 0) {
              // Navigate to the Events page
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EventsPage(),
                ),
              );
            } else if (index == 1) {
              // Navigate to the Members page
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      MyHomePage(), // Make sure you have the MembersPage widget
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

    return StreamBuilder<DocumentSnapshot>(
      stream: members.doc(documentId).snapshots(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text("Something went wrong");
        }
        if (snapshot.connectionState == ConnectionState.active) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MemberDetails(
                    documentId,
                  ),
                ),
              );
            },
            child: Padding(
              padding:
                  const EdgeInsets.only(right: 13, top: 8, bottom: 8, left: 8),
              child: Card(
                color: Colors.grey.withOpacity(0.4),
                elevation: 0, // No shadow
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.black), // Black border
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 25,
                        backgroundImage: NetworkImage(
                            data['image']), // Replace with appropriate image
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data[
                                  'fullName'], // Replace with appropriate full name
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              data[
                                  'designation'], // Replace with appropriate designation
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
                            data['score']
                                .toString(), // Replace with appropriate score
                            style: const TextStyle(
                              fontSize: 20,
                              color: Colors.deepOrange,
                              fontWeight: FontWeight.w900,
                            ),
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
