import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'EventAdd.dart';
import 'main.dart';

class EventsPage extends StatefulWidget {
  @override
  _EventsPageState createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  final TextEditingController eventNameController = TextEditingController();
  final TextEditingController eventDescriptionController =
      TextEditingController();
  final TextEditingController eventLeaderController = TextEditingController();

  @override
  void dispose() {
    eventNameController.dispose();
    eventDescriptionController.dispose();
    eventLeaderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/background(temp).png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                margin: const EdgeInsets.all(16.0),
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EventAdd(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    elevation: 2.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: const Text(
                    'Add New Event',
                    style: TextStyle(fontSize: 16.0),
                  ),
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
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (snapshot.hasData) {
                        final List<QueryDocumentSnapshot> documents =
                            snapshot.data!.docs;
                        return ListView.separated(
                          itemCount: documents.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 8.0),
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
                                      eventName: title,
                                      eventDescription: description,
                                      eventLeader: leader,
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                decoration: const BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(
                                        'assets/background(temp).png'),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                child: Card(
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
                            );
                          },
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
              ),
            ],
          ),
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
          if (index == 1) {
            // Navigate to the Home page
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MyHomePage(),
              ),
            );
          }
        },
      ),
    );
  }
}

class EventDetails extends StatefulWidget {
  final String eventName;
  final String eventDescription;
  final String eventLeader;

  const EventDetails({
    required this.eventName,
    required this.eventDescription,
    required this.eventLeader,
  });

  @override
  _EventDetailsState createState() => _EventDetailsState();
}

class _EventDetailsState extends State<EventDetails> {
  double progress = 0.5; // Set the initial progress value (between 0 and 1)

  void increaseProgress() {
    setState(() {
      if (progress < 1.0) {
        progress += 0.1; // Increment the progress by 0.1
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: const AssetImage('assets/background(temp).png'),
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
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context); // Navigate back to the previous page
                    },
                    color: Colors.grey, // Set the color of the back arrow to grey
                  ),
                ),
                Text(
                  'Event Leader: ${widget.eventLeader}',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0, color: Colors.white),
                ),
                const SizedBox(height: 8.0),
                Text(
                  'Event Name: ${widget.eventName}',
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 8.0),
                Text(
                  'Event Description: ${widget.eventDescription}',
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 16.0),
                Slider(
                  value: progress,
                  onChanged: (value) {
                    setState(() {
                      progress = value;
                    });
                  },
                  min: 0.0,
                  max: 1.0,
                  activeColor: Colors.green,
                  inactiveColor: Colors.grey,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}














