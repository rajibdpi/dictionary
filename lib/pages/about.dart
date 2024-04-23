import 'package:dictionary/components/utils.dart';
import 'package:flutter/material.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        // actions: [],
        title: const Text("About"),
      ),
      body: Center(
        child: FutureBuilder<String>(
          future: lastUpdatedLocalFile(),
          // future: lastUpdatedOnlineFile(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // While waiting for the future to complete, you can display a loading indicator or placeholder text
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              // If there's an error, you can display an error message
              return Text('Error: ${snapshot.error}');
            } else {
              // If the future completes successfully, display the last update time
              return Text('UpdatedAt: ${snapshot.data}');
            }
          },
        ),
      ),
    );
  }
}
