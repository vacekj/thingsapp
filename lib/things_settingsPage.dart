import 'package:flutter/material.dart';
import 'package:DClutter/dflutter.dart';

class SettingsScreen extends StatefulWidget {
  SettingsScreen({Key key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
//TODO add complete functionality of settings screen
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[_buildTopRowButtons(context)],
        ),
      ),
    );
  }

  Widget _buildTopRowButtons(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Container(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 0.0),
                child: IconButton(
                  icon: DFlutter.thingsIcon('assets/graphics/down-arrow.png', height: 15),
                  onPressed: Navigator.of(context).pop,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
