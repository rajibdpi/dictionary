import 'package:flutter/material.dart';

class AboutPage extends StatefulWidget {
  // const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // actions: [],
        title: const Text("About"),
      ),
      body: const Center(
        child: Center(
          child: Text(
              "A Flutter Based English<=>Bangla Dictionary project. E2B is an English<=>Bangla Dictionary. Getting Started This project is a starting point for the Bangladeshi People and want learn English to Bengali and Bengali to English."),
        ),
      ),
    );
  }
}
