import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';


class GitAuthPage extends StatefulWidget {
  @override
  _GitAuthPageState createState() => _GitAuthPageState();
}

class _GitAuthPageState extends State<GitAuthPage> {
  final String clientId = 'YOUR_CLIENT_ID';
  final String clientSecret = 'YOUR_CLIENT_SECRET';
  final String redirectUri = 'YOUR_REDIRECT_URI';
  final String githubAuthUrl =
      'https://github.com/login/oauth/authorize?client_id=YOUR_CLIENT_ID&redirect_uri=YOUR_REDIRECT_URI';

  Future<void> _launchGitHubAuth() async {
    if (await canLaunch(githubAuthUrl)) {
      await launch(githubAuthUrl);
    } else {
      throw 'Could not launch $githubAuthUrl';
    }
  }

  Future<String> _getToken(String code) async {
    final response = await http.post(
      Uri.parse('https://github.com/login/oauth/access_token'),
      headers: {'Accept': 'application/json'},
      body: {
        'client_id': clientId,
        'client_secret': clientSecret,
        'code': code,
        'redirect_uri': redirectUri,
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final String token = data['access_token'];
      return token;
    } else {
      throw Exception('Failed to get access token');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('GitHub SSO Example')),
      body: Center(
        child: ElevatedButton(
          onPressed: _launchGitHubAuth,
          child: Text('Log in with GitHub'),
        ),
      ),
    );
  }
}
