import 'package:flutter/material.dart';
import 'package:things_app/things_database.dart';
import 'package:things_app/things_editScreen.dart';

class InfoScreenState extends State<InfoScreen>{
  final TextStyle textStyle = const TextStyle(fontSize: 20.0);


  @override
  Widget build(BuildContext context) {
    // TODO: implement safe area, image etc.
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [buildTopRowButtons(context), buildThingsInfoHeader()],
      )),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDeleteDialog(context, widget.thing);

        },
        child: Icon(Icons.delete_outline),
      ),
      bottomNavigationBar: buildBottomRowButtons(),
    );
  }

  Widget buildTopRowButtons(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          IconButton(icon: Icon(Icons.edit), onPressed: (){_pushThingsEdit(context, widget.thing);}),
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                Navigator.pop(context);
              })
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
                  fit: BoxFit.fill)),),
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

Widget buildBottomRowButtons() {
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

_pushThingsEdit(BuildContext context, ThingsItem thing){
  final result =  Navigator.push(
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
class InfoScreen extends StatefulWidget{
  InfoScreen({Key key, @required this.thing}) : super(key: key);

  final ThingsItem thing;
  @override
  InfoScreenState createState() => InfoScreenState();
}

//placeholder function for non implemented buttons
void _placeholder() {}
