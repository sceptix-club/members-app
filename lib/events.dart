import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'EventAdd.dart';
import 'main.dart';
import 'package:intl/intl.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({Key? key}) : super(key: key);

  @override
  _EventsPageState createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  final TextEditingController eventNameController = TextEditingController();
  final TextEditingController eventDescriptionController =
      TextEditingController();
  final TextEditingController eventLeaderController = TextEditingController();

  int completedEventsCount = 5;
  int ongoingEventsCount = 10;

  void updateCompletedEventsCount(int count) {
    setState(() {
      completedEventsCount = count;
    });
  }

  void updateOngoingEventsCount(int count) {
    setState(() {
      ongoingEventsCount = count;
    });
  }

  @override
  void dispose() {
    eventNameController.dispose();
    eventDescriptionController.dispose();
    eventLeaderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentDate = DateTime.now();
    final dayFormat = DateFormat('EEEE');
    final dateFormat = DateFormat('MMM dd, yyyy');

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
              const SizedBox(height: 16.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dayFormat.format(currentDate),
                    style: const TextStyle(
                      fontSize: 36.0,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    dateFormat.format(currentDate),
                    style: const TextStyle(
                      fontSize: 16.0,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Handle completed events button press
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CompletedEventsPage(
                            updateCompletedEventsCount:
                                updateCompletedEventsCount,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.grey,
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      elevation: 2.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'Completed Events',
                          style: TextStyle(fontSize: 16.0),
                        ),
                        Text(
                          completedEventsCount.toString(),
                          style: const TextStyle(
                              fontSize: 24.0, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Handle ongoing events button press
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OngoingEventsPage(
                            updateOngoingEventsCount: updateOngoingEventsCount,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.grey,
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      elevation: 2.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Ongoing Events',
                          style: const TextStyle(fontSize: 16.0),
                        ),
                        Text(
                          ongoingEventsCount.toString(),
                          style: const TextStyle(
                              fontSize: 24.0, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
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
                                          image:
                                              AssetImage('assets/calendar.png'),
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
              const SizedBox(height: 16.0),
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
                  child: const Text('Add New Event',
                      style: TextStyle(fontSize: 16.0)),
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
        selectedItemColor: Colors.grey,
        unselectedItemColor: const Color(0xFFFFFFFF),
        onTap: (int index) {
          if (index == 1) {
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

class EventDetails extends StatelessWidget {
  final String eventName;
  final String eventDescription;
  final String eventLeader;

  const EventDetails({
    Key? key,
    required this.eventName,
    required this.eventDescription,
    required this.eventLeader,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
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
                      Navigator.pop(
                          context); // Navigate back to the previous page
                    },
                    color:
                        Colors.grey, // Set the color of the back arrow to grey
                  ),
                ),
                const SizedBox(height: 16.0),
                Text(
                  eventName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16.0),
                Text(
                  'Event Description: $eventDescription',
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
                      children: const [
                        CircleAvatar(
                          radius: 24.0,
                          backgroundImage: AssetImage('assets/lead.jpg'),
                        ),
                        SizedBox(width: 8.0),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                Slider(
                  value: 0.5,
                  onChanged: (value) {
                    // Handle slider value change
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

class CompletedEventsPage extends StatefulWidget {
  final Function(int) updateCompletedEventsCount;

  const CompletedEventsPage(
      {Key? key, required this.updateCompletedEventsCount})
      : super(key: key);

  @override
  _CompletedEventsPageState createState() => _CompletedEventsPageState();
}

class _CompletedEventsPageState extends State<CompletedEventsPage> {
  int completedEventsCount = 5;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Completed Events'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Completed Events Count: $completedEventsCount',
              style: const TextStyle(fontSize: 24.0),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  completedEventsCount++; // Increment the completed events count
                  widget.updateCompletedEventsCount(completedEventsCount);
                });
              },
              child: const Text('Increment Count'),
            ),
          ],
        ),
      ),
    );
  }
}

class OngoingEventsPage extends StatefulWidget {
  final Function(int) updateOngoingEventsCount;

  const OngoingEventsPage({Key? key, required this.updateOngoingEventsCount})
      : super(key: key);

  @override
  _OngoingEventsPageState createState() => _OngoingEventsPageState();
}

class _OngoingEventsPageState extends State<OngoingEventsPage> {
  int ongoingEventsCount = 10;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ongoing Events'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Ongoing Events Count: $ongoingEventsCount',
              style: const TextStyle(fontSize: 24.0),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  ongoingEventsCount++; // Increment the ongoing events count
                  widget.updateOngoingEventsCount(ongoingEventsCount);
                });
              },
              child: const Text('Increment Count'),
            ),
          ],
        ),
      ),
    );
  }
}
