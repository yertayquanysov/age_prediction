import 'package:flutter/material.dart';

class ScanResult extends StatelessWidget {
  final String age;

  ScanResult({@required this.age});

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: age != null,
      child: Text(
        age,
        style: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
