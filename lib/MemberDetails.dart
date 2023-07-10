import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'Events.dart';

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
                      'Designation: ${memberData['designation']}',
                      style: const TextStyle(color: Colors.white),
                    ),
                    SizedBox(
                      width: 200,
                      height: 200,
                      child: Image.network(memberData['image']),
                    ),
                    const SizedBox(height: 30),
                    Text(
                      'Score: ${memberData['score']}',
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      'Project Leader in:', 
                      style: TextStyle(color: Colors.white, fontSize: 18),
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

                        if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                          final List<String> eventIds = snapshot.data!.docs.map((doc) => doc.id).toList();

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: eventIds.map((eventId) {
                              final doc = snapshot.data!.docs.firstWhere((doc) => doc.id == eventId);
                              final eventData = doc.data() as Map<String, dynamic>;

                              return GestureDetector(
                                onTap: () {
                                  // Navigate to the event details page
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EventDetails(
                                        eventName: eventData['title'],
                                        eventDescription: eventData['description'],
                                        eventLeader: memberData['fullName'],
                                      ),
                                    ),
                                  );
                                },
                                child: Text(
                                  'Event: ${eventData['title']}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              );
                            }).toList(),
                          );
                        }

                        return const Text(
                          'No events found.',
                          style: TextStyle(
                            color: Colors.white,
                            decoration: TextDecoration.underline,
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      'Participating in:',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    const SizedBox(height: 10),
                    StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('events')
                          .where('teamMembers', arrayContains: memberData['id'])
                          .snapshots(),
                      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        }

                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Text('Loading...');
                        }

                        if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                          final List<String> eventIds = snapshot.data!.docs.map((doc) => doc.id).toList();

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: eventIds.map((eventId) {
                              final doc = snapshot.data!.docs.firstWhere((doc) => doc.id == eventId);
                              final eventData = doc.data() as Map<String, dynamic>;
                              final List<dynamic> teamLeaders = eventData['teamLeaders'] ?? [];

                              if (!teamLeaders.contains(memberData['id'])) {
                                return GestureDetector(
                                  onTap: () {
                                    // Navigate to the event details page
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => EventDetails(
                                          eventName: eventData['title'],
                                          eventDescription: eventData['description'],
                                          eventLeader: teamLeaders.isNotEmpty ? teamLeaders[0].toString() : '',
                                        ),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    'Event: ${eventData['title']}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                );
                              }

                              return SizedBox(); // Return an empty container if the member is a team leader for this event
                            }).toList(),
                          );
                        }

                        return const Text(
                          'No events found.',
                          style: TextStyle(
                            color: Colors.white,
                            decoration: TextDecoration.underline,
                          ),
                        );
                      },
                    ),
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
