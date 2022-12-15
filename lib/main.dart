import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future getData() async {
    var result = await http.get(Uri.https(
      'meowfacts.herokuapp.com',
    ));
    var json = jsonDecode(result.body);
    print(json);
    return json['data'][0];
  }

  String res = '';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Cat Facts',
          ),
        ),
        body: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(90, 220, 80, 70),
                child: Builder(builder: (context) {
                  return Text(res, style: const TextStyle(fontSize: 20));
                }),
              ),
              SizedBox(
                width: 157,
                child: ElevatedButton(
                  onPressed: (() async {
                    res = await getData();
                    setState(() {});
                  }),
                  child: Row(
                    children: const [
                      Text('Get New Fact'),
                      SizedBox(
                        width: 10,
                      ),
                      Icon(Icons.pets),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
