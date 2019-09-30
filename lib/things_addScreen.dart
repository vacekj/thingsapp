import 'package:flutter/material.dart';

class AddScreen extends StatefulWidget {
  AddScreen({Key key}) : super(key: key);

  @override
  _AddScreenState createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  final _formKey = GlobalKey<
      FormState>(); //TODO make a working form that save a thing and passes it to the main screen for saving

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(),
      ),
    );
  }

  Widget buildTopRowButtons(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[],
      ),
    );
  }
}
