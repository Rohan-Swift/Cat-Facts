import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart'
    as check;

import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: CatFactsPage(),
    );
  }
}

class CatFactsPage extends StatefulWidget {
  const CatFactsPage({Key? key}) : super(key: key);

  @override
  State<CatFactsPage> createState() => _CatFactsPageState();
}

class _CatFactsPageState extends State<CatFactsPage> {
  Future<String> getData() async {
    final result = await http.get(Uri.https('meowfacts.herokuapp.com'));
    final json = jsonDecode(result.body);
    return json['data'][0];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cat Facts'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(90, 220, 80, 70),
                child: FutureBuilder<String>(
                  future: getData(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      final fact = snapshot.data!;
                      return Text(
                        fact,
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                      );
                    }
                  },
                ),
              ),
              SizedBox(
                width: 157,
                child: ElevatedButton(
                  onPressed: () async {
                    final hasConnection =
                        await check.InternetConnectionChecker().hasConnection;
                    if (hasConnection) {
                      setState(() {});
                    } else {
                      print('No internet :(');
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please check your network connection'),
                        ),
                      );
                    }
                  },
                  child: const Row(
                    children: [
                      Text('Get New Fact'),
                      SizedBox(
                        width: 10,
                      ),
                      Icon(Icons.pets),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 50,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
