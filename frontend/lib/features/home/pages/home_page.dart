import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  static MaterialPageRoute<HomePage> route() {
    return MaterialPageRoute(
      builder: (context) => const HomePage(),
    );
  }
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: Center(
        child: Text(
          'Welcome to the Home Page!',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
    );
  }
}