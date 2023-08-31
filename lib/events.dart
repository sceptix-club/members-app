import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rive/rive.dart';
import 'package:sceptixapp/MemberDetails.dart';
import 'EventAdd.dart';
import 'main.dart';

class EventsPage extends StatefulWidget {
  @override
  _EventsPageState createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final currentDate = DateTime.now();
    final dayFormat = DateFormat('EEEE');
    final dateFormat = DateFormat('MMM dd, yyyy');

    return Scaffold(
      appBar: AppBar(
        elevation: 0, // No elevation
        backgroundColor: Colors.transparent, // Transparent background
        title: Text(
          'Events',
          style: TextStyle(
              color: Colors.black,
          fontSize: 30,
          fontWeight: FontWeight.bold), // Set color for the text
        ),
        centerTitle: true,
      ),
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
          RiveAnimation.asset("assets/RiveAssets/shapes.riv"),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
              child: const SizedBox(),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding:
                    const EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dayFormat.format(currentDate),
                      style: const TextStyle(
                          fontSize: 36.0,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      dateFormat.format(currentDate),
                      style:
                          const TextStyle(fontSize: 16.0, color: Colors.black),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Column(
                          children: const [
                            Text('Completed Events',
                                style: TextStyle(fontSize: 16.0)),
                            Text('0',
                                style: TextStyle(
                                    fontSize: 24.0,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Column(
                          children: const [
                            Text('Ongoing Events',
                                style: TextStyle(fontSize: 16.0)),
                            Text('0',
                                style: TextStyle(
                                    fontSize: 24.0,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16.0),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => EventAdd()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF77D8E),
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    elevation: 2.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: const Text('Add New Event',
                      style: TextStyle(fontSize: 16.0)),
                ),
              ),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.transparent,
                  ),
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('events')
                        .orderBy('date')
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasData) {
                        final List<QueryDocumentSnapshot> documents =
                            snapshot.data!.docs;
                        return ListView.builder(
                          itemCount: documents.length,
                          itemBuilder: (context, index) {
                            final Map<String, dynamic>? data = documents[index]
                                .data() as Map<String, dynamic>?;

                            if (data == null) {
                              return const SizedBox.shrink();
                            }

                            final String title = data['title'] ?? '';
                            final String description =
                                data['description'] ?? '';
                            final String leader = data['leader'] ?? '';

                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EventDetails(
                                        eventId: documents[index].id),
                                  ),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 10.0, right: 10.0),
                                child: Column(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.transparent,
                                        border: Border.all(color: Colors.black),
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      child: Card(
                                        color: Colors.transparent,
                                        child: ListTile(
                                          leading: Container(
                                            width: 48,
                                            height: 48,
                                            decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              image: DecorationImage(
                                                fit: BoxFit.cover,
                                                image: AssetImage(
                                                    'assets/calendar.png'),
                                              ),
                                            ),
                                          ),
                                          title: Text(title),
                                          subtitle: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(description),
                                              const SizedBox(height: 4.0),
                                              Text('Leader: $leader'),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      }
                      return const SizedBox();
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
            ],
          ),
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
        selectedItemColor: const Color(0xFFFFFFFF),
        unselectedItemColor: Colors.grey,
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
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (_selectedIndex == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => EventsPage()),
      );
    } else if (_selectedIndex == 1) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (cxt) => MyHomePage()),
        (route) => false,
      );
    }
  }
}

class EventDetails extends StatelessWidget {
  final String eventId;

  const EventDetails({
    Key? key,
    required this.eventId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('events')
            .doc(eventId)
            .snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text('Loading...');
          }

          if (snapshot.hasData && snapshot.data!.exists) {
            final eventData = snapshot.data!.data() as Map<String, dynamic>;
            final eventName = eventData['title'] as String?;
            final eventDescription = eventData['description'] as String?;
            final eventLeader = eventData['leader'] as String?;

            return Stack(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/background(temp).png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      Text(
                        eventName ?? '',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      Text(
                        'Event Description: ${eventDescription ?? ''}',
                        style: const TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 16.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Event Leader:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const CircleAvatar(
                                radius: 24.0,
                                backgroundImage: AssetImage('assets/lead.jpg'),
                              ),
                              const SizedBox(width: 8.0),
                              Text(
                                eventLeader ?? '',
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16.0),
                      Slider(
                        value: 0.5,
                        onChanged: (value) {},
                        min: 0.0,
                        max: 1.0,
                        activeColor: Colors.green,
                        inactiveColor: Colors.grey,
                      ),
                    ],
                  ),
                ),
              ],
            );
          }

          return const Text('Event not found.');
        },
      ),
    );
  }
}
