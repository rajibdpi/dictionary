import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Word {
  String en;
  String bn;

  Word({required this.en, required this.bn});

  factory Word.fromJson(Map<String, dynamic> json) {
    return Word(
      en: json['en'],
      bn: json['bn'],
    );
  }
}

class WordList {
  List<Word> words;

  WordList({required this.words});

  factory WordList.fromJson(List<dynamic> json) {
    List<Word> words = json.map((word) => Word.fromJson(word)).toList();
    return WordList(words: words);
  }
}

class WordPage extends StatefulWidget {
  @override
  _WordPageState createState() => _WordPageState();
}

class _WordPageState extends State<WordPage> {
  late List<Word> allwords;
  late List<Word> filteredWords =
      []; // Initialize filteredWords as an empty list

  @override
  void initState() {
    super.initState();
    _fetchWords();
  }

  Future<void> _fetchWords() async {
    final url = Uri.parse(
        'https://raw.githubusercontent.com/rajibdpi/dictionary/master/assets/E2Bdatabase.json');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final List<dynamic> wordListData = data['words'];
      setState(() {
        allwords = WordList.fromJson(wordListData).words;
        filteredWords = allwords;
      });
    } else {
      throw Exception('Failed to load words');
    }
  }

  void _filterWords(String query) {
    setState(() {
      filteredWords = allwords
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
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: _filterWords,
              decoration: const InputDecoration(
                labelText: 'Search',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredWords.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(filteredWords[index].en),
                  subtitle: Text(filteredWords[index].bn),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(
    MaterialApp(
      home: WordPage(),
    ),
  );
}
