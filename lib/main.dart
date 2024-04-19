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
      home: WordPage(),
    );
  }
}

class WordPage extends StatefulWidget {
  @override
  _WordPageState createState() => _WordPageState();
}

class _WordPageState extends State<WordPage> {
  late List<Word> _allWords;
  late List<Word> _filteredWords = [];

  @override
  void initState() {
    super.initState();
    _fetchWords();
  }

  Future<void> _fetchWords() async {
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
          _allWords = data.map((wordJson) => Word.fromJson(wordJson)).toList();
          _filteredWords = _allWords;
        });
      } else {
        throw Exception('Invalid JSON format');
      }
    } else {
      throw Exception('Failed to load words');
    }
  }

  void _filterWords(String query) {
    setState(() {
      _filteredWords = _allWords
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
              onChanged: _filterWords,
              decoration: const InputDecoration(
                labelText: 'Search-খুঁজুন',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredWords.length,
              itemBuilder: (context, index) {
                final word = _filteredWords[index];
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
                                style: TextStyle(fontWeight: FontWeight.bold)),
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
