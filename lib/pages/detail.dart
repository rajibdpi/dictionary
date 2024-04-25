import 'package:flutter/material.dart';

class WordDetails extends StatefulWidget {
  final String worden;
  final String wordbn;
  // final String wordbn;
  const WordDetails({super.key, required this.worden, required this.wordbn});

  @override
  State<WordDetails> createState() => _WordDetailsState();
}

class _WordDetailsState extends State<WordDetails> {
  // get word => null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 18),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            onPressed: () {
              print("Share Button Pressed");
            },
            icon: const Icon(Icons.share),
          ),
          IconButton(
            onPressed: () {
              print("Copy Button Pressed");
            },
            icon: const Icon(Icons.copy),
          ),
          IconButton(
            onPressed: () {
              print("Speaker Button Pressed");
            },
            icon: const Icon(Icons.volume_up),
          ),
        ],
        title: const Text('E2B Dictionary'),
      ),
      body: Center(
        child: Center(
          child: Text(
            '${widget.worden}\n${widget.wordbn}',
            style: const TextStyle(color: Colors.teal),
          ),
        ),
      ),
    );
  }
}
