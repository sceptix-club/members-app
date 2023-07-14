import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:sceptixapp/events.dart';

class MemberDetails extends StatelessWidget {
  final String documentId;

  MemberDetails(this.documentId);

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
                      style: const TextStyle(color: Colors.black),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Github: ${memberData['githubUsername']}',
                      style: const TextStyle(color: Colors.black),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Email: ${memberData['email']}',
                      style: const TextStyle(color: Colors.black),
                    ),
                    const SizedBox(height: 30),
                    Text(
                      'Designation: ${memberData['designation']}',
                      style: const TextStyle(color: Colors.black),
                    ),
                    SizedBox(
                      width: 200,
                      height: 200,
                      child: Image.network(memberData['image']),
                    ),
                    const SizedBox(height: 30),
                    Text(
                      'Score: ${memberData['score']}',
                      style: const TextStyle(color: Colors.black),
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      'Project Leader in:',
                      style: TextStyle(color: Colors.black, fontSize: 18),
                    ),
                    const SizedBox(height: 10),
                    StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('events')
                          .where('teamLeaders', arrayContains: memberData['id'])
                          .snapshots(),
                      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text('Loading...');
            }

            if (snapshot.hasData && snapshot.data!.exists) {
              final memberData = snapshot.data!.data() as Map<String, dynamic>;

              return Stack(
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
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Name: ${memberData['fullName']}',
                              style: const TextStyle(color: Colors.black),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Github: ${memberData['githubUsername']}',
                              style: const TextStyle(color: Colors.black),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Email: ${memberData['email']}',
                              style: const TextStyle(color: Colors.black),
                            ),
                            const SizedBox(height: 30),
                            Text(
                              'Designation: ${memberData['designation']}',
                              style: const TextStyle(color: Colors.black),
                            ),
                            SizedBox(
                              width: 200,
                              height: 200,
                              child: Image.network(memberData['image']),
                            ),
                            const SizedBox(height: 30),
                            Text(
                              'Score: ${memberData['score']}',
                              style: const TextStyle(color: Colors.black),
                            ),
                            const SizedBox(height: 30),
                            const SizedBox(height: 30),
                            const Text(
                              'Project Leader in:',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 18),
                            ),
                            const SizedBox(height: 10),
                            StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('events')
                                  .where('teamLeaders',
                                      arrayContains: documentId)
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

                                if (snapshot.hasData &&
                                    snapshot.data!.docs.isNotEmpty) {
                                  final List<String> eventIds = snapshot
                                      .data!.docs
                                      .map((doc) => doc.id)
                                      .toList();

                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: eventIds.map((eventId) {
                                      final doc = snapshot.data!.docs
                                          .firstWhere(
                                              (doc) => doc.id == eventId);
                                      final eventData =
                                          doc.data() as Map<String, dynamic>;

                                      return GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  EventDetails(
                                                      eventId: eventId),
                                            ),
                                          );
                                        },
                                        child: Text(
                                          'Event: ${eventData['title']}',
                                          style: const TextStyle(
                                            color: Colors.black,
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  );
                                }

                                return const Text(
                                  'No events found.',
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 30),
                            const Text(
                              'Participating in:',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 18),
                            ),
                            const SizedBox(height: 10),
                            StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('events')
                                  .where('teamMembers',
                                      arrayContains: documentId)
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

                                if (snapshot.hasData &&
                                    snapshot.data!.docs.isNotEmpty) {
                                  final List<String> eventIds = snapshot
                                      .data!.docs
                                      .map((doc) => doc.id)
                                      .toList();

                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: eventIds.map((eventId) {
                                      final doc = snapshot.data!.docs
                                          .firstWhere(
                                              (doc) => doc.id == eventId);
                                      final eventData =
                                          doc.data() as Map<String, dynamic>;

                                      return GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  EventDetails(
                                                      eventId: eventId),
                                            ),
                                          );
                                        },
                                        child: Text(
                                          'Event: ${eventData['title']}',
                                          style: const TextStyle(
                                            color: Colors.black,
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  );
                                }

                                return const Text(
                                  'No events found.',
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }

            return const Text('Member not found.');
          },
        ),
      ),
    );
  }
}