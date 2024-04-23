import 'dart:convert';
import 'dart:io';
import 'package:dictionary/components/utils.dart';
import 'package:dictionary/models/word.dart';
import 'package:dictionary/pages/about.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

Future<void> main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'E2B Dictionary',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: const WordPage(),
    );
  }
}

class WordPage extends StatefulWidget {
  const WordPage({Key? key}) : super(key: key);

  @override
  _WordPageState createState() => _WordPageState();
}

class _WordPageState extends State<WordPage> {
  late List<Word> allWords;
  late List<Word> filteredWords = [];
  late String updateAtDateTime;
  bool isLoading = true; // Track loading state
  bool isSearchBarOpen = false;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadWords();
    // isSearchBarOpen = !isSearchBarOpen;
  }

  Future<void> loadWords() async {
    try {
      // Check if the JSON file exists locally
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/BengaliDictionary.json');
      // print(file);
      if (await file.exists()) {
        // If the file exists locally, load data from it
        final jsonString = await file.readAsString();
        final List<dynamic> jsonData = jsonDecode(jsonString);
        setState(() {
          allWords =
              jsonData.map((wordJson) => Word.fromJson(wordJson)).toList();
          filteredWords = allWords;
          isLoading = false;
        });
      } else {
        // If the file doesn't exist, fetch data from the network and save it locally
        final response = await http.get(Uri.parse(
            'https://raw.githubusercontent.com/rajibdpi/dictionary/master/assets/BengaliDictionary.json'));
        if (response.statusCode == 200) {
          final jsonString = response.body;
          final List<dynamic> jsonData = jsonDecode(jsonString);
          setState(() {
            allWords =
                jsonData.map((wordJson) => Word.fromJson(wordJson)).toList();
            filteredWords = allWords;
            isLoading = false;
          });
          // Save JSON data locally with a custom file name
          await File('${directory.path}/BengaliDictionary.json')
              .writeAsString(jsonString);
          // print(jsonString);
        } else {
          throw Exception('Failed to load words');
        }
      }
    } catch (e) {
      print('Error loading JSON: $e');
      // Handle error
    }
  }

  void searchWords(String query) {
    setState(() {
      filteredWords = allWords
          .where((word) =>
              word.en.toLowerCase().contains(query.toLowerCase()) ||
              word.bn.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  Widget withSearchBar() {
    return Column(
      children: [
        TextField(
          onChanged: searchWords,
          controller: searchController,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.search),
            suffixIcon: IconButton(
              onPressed: () {
                searchController.clear();
                searchWords('');
              },
              icon: const Icon(Icons.clear),
            ),
            labelText: 'Search-খুঁজুন',
            border: const OutlineInputBorder(),
          ),
        ),
        Expanded(
          child: isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : ListView.builder(
                  itemCount: filteredWords.length,
                  itemBuilder: (context, index) {
                    final word = filteredWords[index];
                    return ListTile(
                      title: Text(
                        '${word.en} - ${word.bn}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (word.pron.isNotEmpty)
                            Text('Pronunciation: ${word.pron.join(", ")}'),
                          if (word.bnSyns.isNotEmpty)
                            Text('Bengali Synonyms: ${word.bnSyns.join(", ")}'),
                          if (word.enSyns.isNotEmpty)
                            Text('English Synonyms: ${word.enSyns.join(", ")}'),
                          if (word.sents.isNotEmpty)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Example Sentences:',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                ...word.sents
                                    .map((sent) => Text('- ${sent ?? ""}')),
                              ],
                            ),
                        ],
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget withOutSearchBar() {
    return Column(
      children: [
        Expanded(
          child: isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : ListView.builder(
                  itemCount: filteredWords.length,
                  itemBuilder: (context, index) {
                    final word = filteredWords[index];
                    return ListTile(
                      title: Text(
                        '${word.en} - ${word.bn}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (word.pron.isNotEmpty)
                            Text('Pronunciation: ${word.pron.join(", ")}'),
                          if (word.bnSyns.isNotEmpty)
                            Text('Bengali Synonyms: ${word.bnSyns.join(", ")}'),
                          if (word.enSyns.isNotEmpty)
                            Text('English Synonyms: ${word.enSyns.join(", ")}'),
                          if (word.sents.isNotEmpty)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Example Sentences:',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                ...word.sents
                                    .map((sent) => Text('- ${sent ?? ""}')),
                              ],
                            ),
                        ],
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('E2B Dictionary'),
        // leading: IconButton(onPressed: () {}, icon: const Icon(Icons.menu)),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                isSearchBarOpen = !isSearchBarOpen;
              });
            },
            icon: const Icon(Icons.search),
          )
        ],
        backgroundColor: Colors.teal,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.teal,
              ),
              child: Text(
                'E2B Dictionary',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.update),
              title: const Text('Last Update'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const AboutPage()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                // Navigate to settings page or perform settings related actions
              },
            ),
            ListTile(
              leading: const Icon(Icons.update),
              title: FutureBuilder<String>(
                future: lastUpdatedLocalFile(),
                // future: lastUpdatedLocalFile(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator(
                      semanticsLabel: 'Loading..',
                    );
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return Text('Updated at: ${snapshot.data}');
                  }
                },
              ),
              onTap: () {
                Navigator.pop(context); // Close the drawer
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: isSearchBarOpen
            ? withSearchBar()
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: withOutSearchBar(),
              ),
      ),
    );
  }
}
