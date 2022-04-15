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
  List filteredItems = [];
  bool isSearching = false;
// Filter or Search option
  _runFilter(String enteredKeyword) {
    setState(
      () {
        if (enteredKeyword.isEmpty) {
          // if the search field is empty or only contains white-space, we'll display all users
          filteredItems = _items;
        } else {
          filteredItems = _items
              .where((word) => word['en']
                  .toString()
                  .toLowerCase()
                  .contains(enteredKeyword.toLowerCase()))
              .toList();
          // we use the toLowerCase() method to make it case-insensitive
        }
        // Refresh the UI
        _items = filteredItems;
      },
    );
  }

  // Fetch content from the json file
  Future<void> readJson() async {
    final String response =
        await rootBundle.loadString('assets/BengaliDictionary.json');
    final data = await json.decode(response);
    setState(() {
      _items = filteredItems = data['words'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: isSearching
            ? const Text('E2B Dictionary')
            : TextField(
                onChanged: (value) {
                  _runFilter(value);
                },
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                    icon: Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                    hintText: "Search Word",
                    hintStyle: TextStyle(color: Colors.white)),
              ),
        // title: Center(
        //   child: Text(widget.title),
        // ),
        actions: [
          IconButton(
            tooltip: 'Search words',
            onPressed: () {
              print('Pressed Search Button');
            },
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: FutureBuilder(
        future: readJson(),
        builder: (context, dynamic) {
          // TextField(
          //   // onChanged: (value) => null,
          //   onChanged: (value) => _runFilter(value),
          //   decoration: const InputDecoration(
          //       labelText: 'Search', suffixIcon: Icon(Icons.search)),
          // );
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
      drawer: Padding(
        padding: const EdgeInsets.all(0),
        child: Drawer(
          child: ListView(
            children: [
              const UserAccountsDrawerHeader(
                accountName: Text('Rajib Ahmed'),
                accountEmail: Text('rajibdpi@gmail.com'),
                currentAccountPicture: CircleAvatar(
                  radius: 50.0,
                  backgroundImage: AssetImage("assets/images/user.jpg"),
                ),
              ),
              ListTile(
                title: const Text('Dictionary'),
                leading: const Icon(
                  Icons.book,
                  color: Colors.teal,
                ),
                onTap: () => {
                  // Then close the drawer
                  // Navigator.pop(context);
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const HomePage(
                        title: 'E2B Dictionary',
                      ),
                    ),
                  ),
                },
              ),
              ListTile(
                title: const Text('Recent Search'),
                leading: const Icon(Icons.history, color: Colors.blue),
                onTap: () => {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const HomePage(
                        title: 'E2B Dictionary',
                      ),
                    ),
                  ),
                },
              ),
              ListTile(
                title: const Text('Favourites'),
                leading: const Icon(Icons.heart_broken, color: Colors.red),
                onTap: () => {
                  // Update the state of the app
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const HomePage(
                        title: 'E2B Dictionary',
                      ),
                    ),
                  ),
                  // Then close the drawer
                  // Navigator.pop(context),
                },
              ),
              ListTile(
                title: const Text('Add New Word'),
                leading: const Icon(Icons.edit, color: Colors.blue),
                onTap: () {
                  // Update the state of the app
                  // Then close the drawer
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('About'),
                leading: const Icon(Icons.info, color: Colors.green),
                onTap: () {
                  // Update the state of the app
                  // Then close the drawer
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
