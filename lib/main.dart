import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/search_screen.dart';
import 'providers/publication_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => PublicationProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SearchScreen(),
    );
  }
}