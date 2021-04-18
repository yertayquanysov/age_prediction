import 'package:flutter/material.dart';

class ScanResult extends StatelessWidget {
  final String age;

  ScanResult({required this.age});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Visibility(
        visible: age.isNotEmpty,
        child: Text(
          age,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
