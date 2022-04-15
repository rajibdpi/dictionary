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
  List data = [];
  List filteredItems = [];
  bool isSearching = false;

  // Fetch content from the json file
  Future<void> readJson() async {
    final jsonResponse =
        await rootBundle.loadString('assets/BengaliDictionary.json');
    var jsonData = json.decode(jsonResponse);
    // print(jsonData);
    setState(() {
      data = jsonData['words'];
    });
    // return 'Success';
  }

// Filter or Search option
  _runFilter(String enteredKeyword) {
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      filteredItems = data;
    } else {
      filteredItems = data
          .where((word) => word['en']
              .toString()
              .toLowerCase()
              .contains(enteredKeyword.toLowerCase()))
          .toList();
      // we use the toLowerCase() method to make it case-insensitive
    }
    // Refresh the UI
    setState(
      () {
        data = filteredItems;
      },
    );
  }

  @override
  void initState() {
    readJson();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: !isSearching
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
                  hintStyle: TextStyle(color: Colors.white),
                ),
              ),
        // title: Center(
        //   child: Text(widget.title),
        // ),
        actions: <Widget>[
          if (isSearching) IconButton(
                  icon: const Icon(Icons.cancel),
                  onPressed: () {
                    setState(() {
                      isSearching = false;
                      // filteredItems = data;
                    });
                  },
                ) else IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    setState(() {
                      isSearching = true;
                    });
                  },
                )
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: data.isNotEmpty
            ? ListView.builder(
                itemCount: data.length,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    children: [
                      ListTile(
                        leading: CircleAvatar(
                          child: Text(
                              data[index]['en'][0].toString().toUpperCase()),
                        ),
                        title: Text(data[index]['en']),
                        subtitle: Text(data[index]['bn']),
                        onTap: () => {
                          print(data[index]),
                        },
                      ),
                    ],
                  );
                },
              )
            : const Center(
                child: CircularProgressIndicator(),
              ),
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

class ( {
}

class ( {
}

class ( {
}
