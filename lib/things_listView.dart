import 'dart:io';
import 'package:flutter/material.dart';
import 'package:things_app/things_database.dart';

class ThingsListView extends StatefulWidget {
  ThingsListView({Key key, @required this.possessions}) : super(key: key);

  final List<ThingsItem> possessions;

  @override
  _ThingsListViewState createState() => _ThingsListViewState();
}

class _ThingsListViewState extends State<ThingsListView> {
  List<ThingsItem> poss;

  @override
  Widget build(BuildContext context) {
    if (widget.possessions.isEmpty) return _emptyListDisclaimer();
    return ListView.builder(
        itemCount: widget.possessions.length,
        itemBuilder: (context, index) {
          return _thingListItem(widget.possessions[index]);
        });
  }

  Widget _thingListItem(ThingsItem thing) {
    return ListTile(
        title: Text(thing.name),
        subtitle: Text(thing.value.toString()),
        leading: thingListImage(image: thing.image));
  }

  Widget _emptyListDisclaimer() {
    return Center(
      child: Text('Your list is empty, try adding something'),
    );
  }

  Widget thingListImage(
      {@required File image, double width = 50.0, double height = 50.0}) {
    return Container(
      width: width,
      height: height,
      decoration: new BoxDecoration(
          shape: BoxShape.circle,
          image: new DecorationImage(
              image: image == null
                  ? new AssetImage('graphics/add_icon.jpg')
                  : new FileImage(image),
              fit: BoxFit.fill)),
    );
  }
}
