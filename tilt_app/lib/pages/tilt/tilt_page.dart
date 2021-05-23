import 'package:flutter/material.dart';

class TiltPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TiltPageState();
}

class _TiltPageState extends State<TiltPage> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: Text("Tilt"),
      ),
    );
  }
}
