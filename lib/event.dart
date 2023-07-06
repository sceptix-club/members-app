import 'dart:io';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EventsPage extends StatefulWidget {
  @override
  _EventsPageState createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  final TextEditingController eventNameController = TextEditingController();
  final TextEditingController eventDescriptionController = TextEditingController();
  final TextEditingController eventLeaderController = TextEditingController();

  Future<void> _addEvent() async {
    final String eventName = eventNameController.text;
    final String eventDescription = eventDescriptionController.text;
    final String eventLeader = eventLeaderController.text;

    try {
      await FirebaseFirestore.instance.collection('events').add({
        'title': eventName,
        'description': eventDescription,
        'leader': eventLeader,
      });

      eventNameController.clear();
      eventDescriptionController.clear();
      eventLeaderController.clear();
    } catch (error) {
      // Handle error during event creation
      print('Failed to add event: $error');
    }
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Events'),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
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
                margin: EdgeInsets.all(16.0),
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Add New Event'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextField(
                              controller: eventLeaderController,
                              decoration: InputDecoration(
                                labelText: 'Event Leader',
                              ),
                            ),
                            SizedBox(height: 8.0),
                            TextField(
                              controller: eventNameController,
                              decoration: InputDecoration(
                                labelText: 'Event Name',
                              ),
                            ),
                            SizedBox(height: 8.0),
                            TextField(
                              controller: eventDescriptionController,
                              decoration: InputDecoration(
                                labelText: 'Event Description',
                              ),
                            ),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('Cancel'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              _addEvent();
                              Navigator.pop(context);
                            },
                            child: Text('Add Event'),
                          ),
                        ],
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue,
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    elevation: 2.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: Text(
                    'Add New Event',
                    style: TextStyle(fontSize: 16.0),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                  ),
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance.collection('events').snapshots(),
                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (snapshot.hasData) {
                        final List<QueryDocumentSnapshot> documents = snapshot.data!.docs;
                        return ListView.separated(
                          itemCount: documents.length,
                          separatorBuilder: (context, index) => SizedBox(height: 8.0),
                          itemBuilder: (context, index) {
                            final Map<String, dynamic>? data = documents[index].data() as Map<String, dynamic>?;

                            if (data == null) {
                              return SizedBox.shrink();
                            }

                            final String title = data['title'] ?? '';
                            final String description = data['description'] ?? '';
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
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage('assets/background(temp).png'),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                child: Card(
                                  child: ListTile(
                                    leading: Container(
                                      width: 48,
                                      height: 48,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: AssetImage('assets/calendar.png'),
                                        ),
                                      ),
                                    ),
                                    title: Text(title),
                                    subtitle: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(description),
                                        SizedBox(height: 4.0),
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
                      return SizedBox.shrink();
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class EventDetails extends StatefulWidget {
  final String eventName;
  final String eventDescription;
  final String eventLeader;

  EventDetails({required this.eventName, required this.eventDescription, required this.eventLeader});

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
      appBar: AppBar(
        title: Text('Event Details'),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background(temp).png'),
            fit: BoxFit.cover,
          ),
        ),
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Event Leader: ${widget.eventLeader}',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0, color: Colors.white),
            ),
            SizedBox(height: 8.0),
            Text(
              'Event Name: ${widget.eventName}',
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 8.0),
            Text(
              'Event Description: ${widget.eventDescription}',
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 16.0),
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
    );
  }
}












