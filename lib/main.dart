import 'dart:convert';
import 'dart:io';
import 'package:dictionary/models/word.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

void main() {
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
  bool isLoading = true; // Track loading state
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadWords();
  }

  Future<void> loadWords() async {
    try {
      // Check if the JSON file exists locally
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/BengaliDictionary.json');
      print(directory.path);
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
          print(jsonString);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('E2B Dictionary'),
        leading: IconButton(onPressed: () {}, icon: const Icon(Icons.menu)),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
          )
        ],
        backgroundColor: Colors.teal,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
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
                              Text(
                                  'Bengali Synonyms: ${word.bnSyns.join(", ")}'),
                            if (word.enSyns.isNotEmpty)
                              Text(
                                  'English Synonyms: ${word.enSyns.join(", ")}'),
                            if (word.sents.isNotEmpty)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Example Sentences:',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
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
      ),
    );
  }
}
