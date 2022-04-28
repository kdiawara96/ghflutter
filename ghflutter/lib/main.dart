import 'package:flutter/material.dart';
//import 'strings.dart' as strings;
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  runApp(const GHFlutterApp());
}

class GHFlutterApp extends StatelessWidget {
  const GHFlutterApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "GHFlutter",
      theme: ThemeData(primarySwatch: Colors.orange),
      home: const GHFlutter(),
    );
  }
}

class GHFlutter extends StatefulWidget {
  const GHFlutter({Key? key}) : super(key: key);

  @override
  _GHFlutterState createState() => _GHFlutterState();
}

const _biggerFont = TextStyle(fontSize: 20, fontStyle: FontStyle.italic);

class _GHFlutterState extends State<GHFlutter> {
  final _membre = <Member>[];

  Future<void> _loadData() async {
    final response = await http
        .get(Uri.parse('https://api.github.com/orgs/raywenderlich/members'));
    setState(() {
      final dataList = json.decode(response.body) as List;
      for (final item in dataList) {
        final login = item['login'] as String? ?? '';
        final url = item['avatar_url'] as String? ?? '';
        final member = Member(login, url);
        _membre.add(member);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Widget _buildRow(int i) {
    return ListTile(
      title: Text('${_membre[i].login}', style: _biggerFont),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(_membre[i].avatar_url),
      ),
      textColor: Colors.grey,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "GHFlutter",
          style: TextStyle(
              fontSize: 30,
              color: Colors.white,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: ListView.separated(
            padding: const EdgeInsets.all(16.0),
            itemCount: _membre.length,
            itemBuilder: (BuildContext conssstext, int position) {
              return _buildRow(position);
            },
            separatorBuilder: (context, index) {
              return const Divider();
            }),
      ),
    );
  }
}

class Member {
  final String login;
  final String avatar_url;
  Member(this.login, this.avatar_url);
}
