import 'dart:io';
import 'package:flutter/material.dart';
import 'package:things_app/main.dart' as main;
import 'package:things_app/things_database.dart';
import 'package:things_app/things_infoScreen.dart';

class ThingsListView extends StatefulWidget {
  ThingsListView({Key key}) : super(key: key);

  @override
  _ThingsListViewState createState() => _ThingsListViewState();
}

class _ThingsListViewState extends State<ThingsListView> {
  @override
  Widget build(BuildContext context) {
    if (main.possessions.isEmpty) return _emptyListDisclaimer();
    return ListView.builder(
        itemCount: main.possessions.length,
        itemBuilder: (context, index) {
          return _thingListItem(main.possessions[index]);
        });
  }

  Widget _thingListItem(ThingsItem thing) {
    return ListTile(
        title: Text(thing.name),
        subtitle: Text(thing.value.toString()),
        leading: thingListImage(image: thing.image),
        onTap: () {
          navigateToInfoPage(context, thing);
        });
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
          borderRadius: BorderRadius.circular(16.0),
          shape: BoxShape.rectangle,
          image: new DecorationImage(
              image: image == null
                  ? new AssetImage('assets/graphics/add_icon.jpg')
                  : new FileImage(image),
              fit: BoxFit.fill)),
    );
  }

  navigateToInfoPage(BuildContext context, ThingsItem thing) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => InfoScreen(thing: thing)),
    );
    if (result == "Deleted") {
      //readAll();
    }
  }

  readAll() async {
    DatabaseHelper helper = DatabaseHelper.instance;
    List<ThingsItem> tList = await helper.queryAllThings();
    if (tList == null) {
      print('read list returned null');
    } else if (tList.isEmpty) {
      print('read list is empty');
    } else {
      tList.forEach((element) => print(element));
    }
    main.possessions = tList;
    setState(() {});
  }
}
