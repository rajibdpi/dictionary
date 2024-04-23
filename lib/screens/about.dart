import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  //check updated?
  Future<String> lastUpdate() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/BengaliDictionary.json');
    // Get metadata of the local file
    final localFileStat = await file.stat();
    DateTime localUpdatedDateTime = localFileStat.modified;
    String updatedAt = localUpdatedDateTime.toString();
    // print('Last Update $localUpdatedDateTime');
    return updatedAt;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // actions: [],
        title: const Text("About"),
      ),
      body: Center(
        child: FutureBuilder<String>(
          future: lastUpdate(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // While waiting for the future to complete, you can display a loading indicator or placeholder text
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              // If there's an error, you can display an error message
              return Text('Error: ${snapshot.error}');
            } else {
              // If the future completes successfully, display the last update time
              return Text('Last Update: ${snapshot.data}');
            }
          },
        ),
      ),
    );
  }
}
