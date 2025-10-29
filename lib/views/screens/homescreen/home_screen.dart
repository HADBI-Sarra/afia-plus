import 'package:afia_plus_app/views/themes/style_simple/styles.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: gradientBackgroundDecoration,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(
            'Home Page',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        body: Center(
          child: Text('Home Page Content'),
        ),
      ),
    );
  }
}