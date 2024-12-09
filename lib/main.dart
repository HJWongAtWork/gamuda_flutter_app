import 'package:flutter/material.dart';
import 'package:provider/provider.dart';  // Add this import
import 'services/auth_service.dart';      // Add this import
import 'pages/login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
      ],
      child: const MaterialApp(
        title: 'Gamuda Flutter App',
        home: LoginPage(),
      ),
    );
  }
}