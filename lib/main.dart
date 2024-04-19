import 'package:dictionary/screens/about.dart';
import 'package:dictionary/screens/detail.dart';
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
  late List words = []; // Initialize words as an empty list
  late List filteredWords = [];
  TextEditingController searchController = TextEditingController();
  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    // Fetch data and update words list
    readJson();
    words = words;
  }

  // Fetch content from the json file
  Future<void> readJson() async {
    final jsonResponse = await rootBundle.loadString('assets/E2Bdatabase.json');
    var jsonData = json.decode(jsonResponse);
    // print(jsonData);
    setState(() {
      words = jsonData['words'];
    });
    // return 'Success';
  }

// Filter or Search option
  void filterWords(String enteredKeyword) {
    if (enteredKeyword.isNotEmpty) {
      List<Map> searchWords = [];
      words.forEach((word) {
        if (word['en']
                .toString()
                .toLowerCase()
                .contains(enteredKeyword.toLowerCase()) ||
            word['bn']
                .toString()
                .toLowerCase()
                .contains(enteredKeyword.toLowerCase())) {
          searchWords.add(word);
        }
      });
      // if the search field is empty or only contains white-space, we'll display all users
      setState(
        () {
          filteredWords = searchWords;
        },
      );
    } else {
      setState(() {
        filteredWords = words; // Assign original list when query is empty
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 18),
        iconTheme: const IconThemeData(color: Colors.white),
        title: !isSearching
            ? const Text('E2B Dictionary')
            : TextField(
                onChanged: (value) {
                  filterWords(value);
                },
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  icon: Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                  hintText: "Search....",
                  hintStyle: TextStyle(color: Colors.white),
                ),
              ),
        backgroundColor: Colors.teal,
        actions: <Widget>[
          isSearching
              ? IconButton(
                  icon: const Icon(Icons.cancel),
                  color: Colors.white,
                  onPressed: () {
                    setState(() {
                      isSearching = false;
                      filteredWords = words;
                    });
                  },
                )
              : IconButton(
                  icon: const Icon(Icons.search),
                  color: Colors.white,
                  onPressed: () {
                    setState(() {
                      isSearching = true;
                    });
                  },
                )
        ],
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              onChanged: (searchKeyword) {
                filterWords(searchKeyword);
              },
              decoration: InputDecoration(
                labelText: 'Search',
                hintText: 'Search words...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  onPressed: () {
                    searchController.clear();
                    filterWords('');
                  },
                  icon: const Icon(Icons.clear),
                ),
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(25.0),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredWords.length,
              itemBuilder: (context, index) {
                final word = filteredWords[index];
                return ListTile(
                  leading: Text(
                    word['en'][0],
                    style: const TextStyle(fontSize: 14),
                  ),
                  trailing: Row(
                    mainAxisSize:
                        MainAxisSize.min, // To restrict the width of the row
                    children: [
                      IconButton(
                        onPressed: () {
                          // Navigator.of(context).push(
                          //   MaterialPageRoute(
                          //     builder: (context) =>
                          //         wordEditPage(word: word),
                          //   ),
                          // );
                        },
                        icon: const Icon(Icons.edit_document),
                      ),
                      const SizedBox(
                        width: 04,
                      ),
                      IconButton(
                        onPressed: () {
                          // showDialogMessage(context, word.name,
                          //     'Do you want to delete ${word.name}?');
                        },
                        icon: const Icon(Icons.delete),
                        style: const ButtonStyle(
                            iconColor: MaterialStatePropertyAll(Colors.red)),
                      ),
                      const SizedBox(
                        width: 04,
                      ),
                    ],
                  ),
                  title: Text(
                    word['en'],
                  ),
                  subtitle: Text('${word['bn']}'),
                  isThreeLine: false,
                  hoverColor: Colors.teal.shade50,
                  mouseCursor: MaterialStateMouseCursor.clickable,
                  selectedTileColor: Colors.brown,
                  onTap: () async {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WordDetails(
                            worden: words[index]['en'],
                            wordbn: words[index]['bn'],
                          ),
                        ));
                  },
                );
              },
            ),
          ),
        ],
      ),

      // Container(
      //   padding: const EdgeInsets.all(10),
      //   child: words.isNotEmpty
      //       ? ListView.builder(
      //           itemCount: words.length,
      //           itemBuilder: (BuildContext context, int index) {
      //             return Column(
      //               children: [
      //                 ListTile(
      //                   leading: CircleAvatar(
      //                     child: Text(
      //                         words[index]['en'][0].toString().toUpperCase()),
      //                   ),
      //                   title: Text(words[index]['en']),
      //                   subtitle: Text(words[index]['bn']),
      //                   onTap: () async {
      //                     // print(data[index]);
      //                     Navigator.push(
      //                       context,
      //                       MaterialPageRoute(
      //                         builder: (context) => WordDetails(
      //                           worden: words[index]['en'],
      //                           wordbn: words[index]['bn'],
      //                         ),
      //                       ),
      //                     );
      //                   },
      //                 ),
      //               ],
      //             );
      //           },
      //         )
      //       : const Center(
      //           child: CircularProgressIndicator(),
      //         ),
      // ),
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
                title: const Text('Home'),
                leading: const Icon(
                  Icons.home,
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
                onTap: () => {
                  // Update the state of the app
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => AboutPage(),
                    ),
                  ) //: Navigator.pop(context)
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
