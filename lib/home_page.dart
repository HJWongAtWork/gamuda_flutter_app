import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My App'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // Add your logout functionality here (e.g., show confirmation dialog)
              print('Logout button pressed (placeholder)');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Welcome to My App',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Flexible(
                  child: Container(
                    width: 150,
                    height: 150,
                    color: Colors.blue,
                    // Replace with your first chart widget
                  ),
                ),
                Flexible(
                  child: Container(
                    width: 150,
                    height: 300,
                    color: Colors.green,
                    // Replace with your second chart widget
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity, // Expands to full width
              height: 300,
              color: Colors.red,
              // Replace with your chart widget
            ),
          ],
        ),
      ),
    );
  }
}