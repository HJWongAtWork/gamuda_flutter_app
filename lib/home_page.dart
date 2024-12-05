import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Welcome to My App',
              style: TextStyle(fontSize: 20),
            ),
            ElevatedButton(
              onPressed: () {
                // Add your button's functionality here
              },
              child: const Text('Get Started'),
            ),
          ],
        ),
      ),
    );
  }
}