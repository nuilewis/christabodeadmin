import 'package:flutter/material.dart';

class DevotionalScreen extends StatelessWidget {
  static const id = "devotional_screen";
  const DevotionalScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        child: Center(
            child: Column(
          children: [
            TextFormField(),
            TextFormField(),
            TextFormField(),
            TextFormField(),
            TextFormField(),
          ],
        )),
      ),
    );
  }
}
