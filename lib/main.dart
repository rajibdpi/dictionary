import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'E2B Dictionary',
      theme: ThemeData(
        // This is the theme of the application.
        primarySwatch: Colors.teal,
      ),
      home: const HomePage(
        title: 'E2B Dictionary',
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);

  final String title;
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List _items = [];

  // Fetch content from the json file
  Future<void> readJson() async {
    final String response =
        await rootBundle.loadString('assets/BengaliDictionary.json');
    final data = await json.decode(response);
    setState(() {
      _items = data['words'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            tooltip: 'Search words',
            onPressed: () {
              print('Search Button Pressed');
            },
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: FutureBuilder(
        future: readJson(),
        builder: (context, dynamic) {
          if (_items.isNotEmpty) {
            return ListView.builder(
              itemCount: _items.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    leading: Text(_items[index]["en"]),
                    title: Text(_items[index]["bn"]),
                    subtitle: Text('en_syns-${_items[index]["en_syns"]} -- '
                        'bn_syns-${_items[index]["bn_syns"]}'),
                  ),
                );
              },
            );
          } else {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [CircularProgressIndicator(), Text('Loading')],
              ),
            );
          }
        },
      ),
    );
  }
}
