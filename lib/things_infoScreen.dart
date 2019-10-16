import 'package:flutter/material.dart';
import 'package:DClutter/things_database.dart';
import 'package:DClutter/things_editScreen.dart';
import 'package:DClutter/dflutter.dart';

class InfoScreenState extends State<InfoScreen> {
  final TextStyle textStyle = const TextStyle(fontSize: 20.0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [buildTopRowButtons(context), buildThingsInfoHeader()],
      )),
    );
  }

  Widget buildTopRowButtons(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 0.0),
                    child: IconButton(
                        icon: DFlutter.thingsIcon(
                            'assets/graphics/pen-icon.png'),
                        onPressed: () {
                          _pushThingsEdit(context, widget.thing);
                        }),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 0.0),
                    child: IconButton(
                        icon: DFlutter.thingsIcon(
                            'assets/graphics/trash-icon.png'),
                        onPressed: () {
                          showDeleteDialog(context, widget.thing);
                        }),
                  ),
                ],
              )),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 0.0),
            child: IconButton(
                icon: DFlutter.thingsIcon(
                    'assets/graphics/down-arrow.png',
                    height: 15),
                onPressed: () {
                  Navigator.pop(context);
                }),
          )
        ],
      ),
    );
  }

  Widget buildThingsInfoHeader() {
    return Container(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: <Widget>[
            DFlutter.thingsListImage(
              image: widget.thing.image,
              width: 150,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(bottom: 8),
                    child: Text(widget.thing.name,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                  ),
                  Text(
                    widget.thing.value.toString(),
                    style: textStyle,
                  )
                ],
              ),
            ),
          ],
        ));
  }
}

_pushThingsEdit(BuildContext context, ThingsItem thing) {
  final result = Navigator.push(
    context,
    EditPageRoute(builder: (context) => EditScreen(thing: thing)),
  );
}

deleteThing(ThingsItem T) {
  DatabaseHelper helper = DatabaseHelper.instance;
  helper.delete(T);
}

showDeleteDialog(BuildContext context, ThingsItem thing) {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          //title: Text("Confirmation"),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          //titlePadding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
          content: Text(
            "Are you sure you want to delete " + thing.name + "?",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.red),
          ),
          actions: <Widget>[
            FlatButton(
                child: Text("Close"),
                onPressed: () {
                  Navigator.of(context).pop();
                }),
            FlatButton(
              child: Text("Delete"),
              onPressed: () {
                deleteThing(thing);
                Navigator.of(context).pop();
                Navigator.of(context).pop("Deleted");
              },
            ),
          ],
        );
      });
}

class InfoScreen extends StatefulWidget {
  InfoScreen({Key key, @required this.thing}) : super(key: key);

  final ThingsItem thing;

  @override
  InfoScreenState createState() => InfoScreenState();
}

