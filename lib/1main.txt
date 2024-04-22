import 'dart:convert';
import 'package:dictionary/models/word.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
  const WordPage({super.key});

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
    fetchWords();
  }

  Future<void> fetchWords() async {
    final response = await http.get(
      Uri.parse(
        'https://raw.githubusercontent.com/rajibdpi/dictionary/master/assets/BengaliDictionary.json',
      ),
    );

    if (response.statusCode == 200) {
      final List<dynamic>? jsonData = jsonDecode(response.body);
      if (jsonData != null) {
        final List<dynamic> data = jsonData;
        setState(() {
          allWords = data.map((wordJson) => Word.fromJson(wordJson)).toList();
          filteredWords = allWords;
          isLoading = false;
        });
      } else {
        throw Exception('Invalid JSON format');
      }
    } else {
      throw Exception('Failed to load words');
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
              controller:
                  searchController, // Assign the controller to the TextField
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                    onPressed: () {
                      searchController.clear();
                      searchWords('');
                    },
                    icon: const Icon(Icons.clear)),
                labelText: 'Search-খুঁজুন',
                border: const OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: isLoading
                ? const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(), // Show loading indicator
                      SizedBox(height: 16),
                      Text('Loading...'), // Show loading label
                    ],
                  ) // Show loading indicator
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
