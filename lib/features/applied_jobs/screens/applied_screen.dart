import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppliedScreen extends StatefulWidget {
  const AppliedScreen({super.key});

  @override
  State<AppliedScreen> createState() => _AppliedScreenState();
}

class _AppliedScreenState extends State<AppliedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text('Applied work'),
    );
  }
}
