import 'package:flutter/material.dart';
import 'package:things_app/things_database.dart';
import 'package:things_app/things_editScreen.dart';
import 'package:things_app/things_helperClass.dart';

class InfoScreenState extends State<InfoScreen> {
  final TextStyle textStyle = const TextStyle(fontSize: 20.0);

  @override
  Widget build(BuildContext context) {
    // TODO: implement safe area, image etc.
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
            padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 0.0),
                    child: IconButton(
                        icon: ThingsSpecialsMethods.thingsIcon('assets/graphics/pen-icon.png'),
                        onPressed: () {
                          _pushThingsEdit(context, widget.thing);
                        }),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 0.0),
                    child: IconButton(
                        icon: ThingsSpecialsMethods.thingsIcon('assets/graphics/trash-icon.png'),
                        onPressed: () {
                          showDeleteDialog(context, widget.thing);
                        }),
                  ),
                ],
                
              )),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 0.0),
            child: IconButton(
                icon: ThingsSpecialsMethods.thingsIcon('assets/graphics/down-arrow.png', height: 15),
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
        padding: const EdgeInsets.all(32),
        child: Row(
          //TODO fix being unable to get a thing.value from database
          children: <Widget>[
            Container(
              width: 70.0,
              height: 70.0,
              decoration: new BoxDecoration(
                  shape: BoxShape.circle,
                  image: new DecorationImage(
                      image: widget.thing.image == null
                          ? new AssetImage('assets/graphics/no-photo.png')
                          : new FileImage(widget.thing.image),
                      fit: BoxFit.fill)),
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

//placeholder function for non implemented buttons
void _placeholder() {}
