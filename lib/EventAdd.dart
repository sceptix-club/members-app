import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EventAdd extends StatefulWidget {
  @override
  _EventsAddState createState() => _EventsAddState();
}

class _EventsAddState extends State<EventAdd> {
  var db = FirebaseFirestore.instance;
  String _title = '';
  String _description = '';
  List<Member> _members = [];
  List<String?> _teamLeaders = [];
  List<String?> _teamMembers = [];

  @override
  void initState() {
    super.initState();
    fetchMembers();
  }

  Future<void> fetchMembers() async {
    final QuerySnapshot querySnapshot = await db.collection('members').get();
    final List<QueryDocumentSnapshot> documents = querySnapshot.docs;

    final List<Member> members = documents
        .map((doc) {
          final String name = doc['fullName'] as String;
          final String id = doc.id;
          return Member(name: name, id: id);
        })
        .where((member) => member.name.isNotEmpty)
        .toList();

    setState(() {
      _members = members;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Events'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Event Title',
              ),
              onChanged: (value) {
                setState(() {
                  _title = value;
                });
              },
            ),
            const SizedBox(height: 16.0),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Event Description',
              ),
              onChanged: (value) {
                setState(() {
                  _description = value;
                });
              },
            ),
            const SizedBox(height: 16.0),
            if (_members.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Select Team Leader(s):'),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _teamLeaders.length + 1,
                    itemBuilder: (context, index) {
                      if (index == _teamLeaders.length) {
                        return Row(
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _teamLeaders.add(null);
                                });
                              },
                              child: const Text('Add Team Leader'),
                            ),
                            if (index > 0)
                              IconButton(
                                icon: const Icon(Icons.remove),
                                onPressed: () {
                                  setState(() {
                                    _teamLeaders.removeAt(index);
                                  });
                                },
                              ),
                          ],
                        );
                      }
                      return Row(
                        children: [
                          DropdownButton<String>(
                            value: _teamLeaders[index],
                            items: _members.map((member) {
                              return DropdownMenuItem<String>(
                                value: member.id,
                                child: Text(member.name),
                              );
                            }).toList(),
                            onChanged: (String? value) {
                              setState(() {
                                _teamLeaders[index] = value;
                              });
                            },
                          ),
                          if (index > 0)
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: () {
                                setState(() {
                                  _teamLeaders.removeAt(index);
                                });
                              },
                            ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 16.0),
                  const Text('Select Team Member(s):'),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _teamMembers.length + 1,
                    itemBuilder: (context, index) {
                      if (index == _teamMembers.length) {
                        return Row(
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _teamMembers.add(null);
                                });
                              },
                              child: const Text('Add Team Member'),
                            ),
                            if (index > 0)
                              IconButton(
                                icon: const Icon(Icons.remove),
                                onPressed: () {
                                  setState(() {
                                    _teamMembers.removeAt(index);
                                  });
                                },
                              ),
                          ],
                        );
                      }
                      return Row(
                        children: [
                          DropdownButton<String>(
                            value: _teamMembers[index],
                            items: _members.map((member) {
                              return DropdownMenuItem<String>(
                                value: member.id,
                                child: Text(member.name),
                              );
                            }).toList(),
                            onChanged: (String? value) {
                              setState(() {
                                _teamMembers[index] = value;
                              });
                            },
                          ),
                          if (index > 0)
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: () {
                                setState(() {
                                  _teamMembers.removeAt(index);
                                });
                              },
                            ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                addEventToFirestore();
              },
              child: const Text('Add Event'),
            ),
          ],
        ),
      ),
    );
  }

  void addEventToFirestore() {
    if (_title.isEmpty) {
      return;
    }

    final List<String?> selectedTeamLeaders = _teamLeaders
        .where((leader) => leader != null)
        .map((leader) => leader!)
        .toList();

    final List<String?> selectedTeamMembers = _teamMembers
        .where((leader) => leader != null)
        .map((leader) => leader!)
        .toList();
    // Convert to JSON string

    db.collection('events').add({
      'title': _title,
      'description': _description,
      'teamLeaders': selectedTeamLeaders,
      'teamMembers': selectedTeamMembers,
    }).then((value) {
      print('Event added to Firestore');
      setState(() {
        _title = '';
        _description = '';
        _teamLeaders = [];
        _teamMembers = [];
      });
    }).catchError((error) {
      print('Failed to add event: $error');
    });
  }
}

class Member {
  final String name;
  final String id;

  Member({required this.name, required this.id});
}
