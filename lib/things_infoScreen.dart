import 'package:flutter/material.dart';
import 'package:things_app/things_database.dart';

class InfoScreen extends StatelessWidget {
  final TextStyle _textStyle = const TextStyle(fontSize: 20.0);

  final ThingsItem thing;

  InfoScreen({Key key, @required this.thing}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement safe area, image etc.
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [_buildTopRowButtons(context), _buildThingsInfoHeader()],
      )),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showDeleteDialog(context, thing);

        },
        child: Icon(Icons.delete_outline),
      ),
      bottomNavigationBar: _buildBottomRowButtons(),
    );
  }

  Widget _buildTopRowButtons(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          IconButton(icon: Icon(Icons.edit), onPressed: _pushThingsEdit),
          //TODO make a working edit page transition
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                Navigator.pop(context);
              })
        ],
      ),
    );
  }

  Widget _buildThingsInfoHeader() {
    return Container(
        padding: const EdgeInsets.all(32),
        child: Row(
          //TODO fix being unable to get a thing.value from database
          children: <Widget>[
            Icon(Icons.picture_in_picture),
            Text('Add'),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(bottom: 8),
                    child: Text(thing.name,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                  ),
                  Text(
                    thing.value.toString(),
                    style: _textStyle,
                  )
                ],
              ),
            ),
          ],
        ));
  }
}

Widget _buildBottomRowButtons() {
  return BottomAppBar(
    shape: CircularNotchedRectangle(),
    notchMargin: 4.0,
    child: Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        RaisedButton(
          onPressed: _placeholder,
          child: Text('Sell'),
        ),
      ],
    ),
  );
}

//TODO make an edit page
void _pushThingsEdit() {}

_deleteThing(ThingsItem T) {
  DatabaseHelper helper = DatabaseHelper.instance;
  helper.delete(T);
}

_showDeleteDialog(BuildContext context, ThingsItem thing) {
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
                _deleteThing(thing);
                Navigator.of(context).pop();
                Navigator.of(context).pop("Deleted");
              },
            ),
          ],
        );
      });
}

//placeholder function for non implemented buttons
void _placeholder() {}
