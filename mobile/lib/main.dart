import 'package:flutter/material.dart';

void main() {
  runApp(const CrowdegoApp());
}

class CrowdegoApp extends StatelessWidget {
  const CrowdegoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Crowdego Hub',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
      ),
      home: Scaffold(
        appBar: AppBar(title: const Text('Crowdego Hub')),
        body: const Center(
          child: Text(
            'Hello World',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
