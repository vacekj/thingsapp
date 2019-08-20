import 'package:flutter/material.dart';
import 'package:things_app/things_database.dart';
import 'package:things_app/things_infoScreen.dart';

class EditScreen extends InfoScreen{
  final _formKey = GlobalKey<FormState>();

  EditScreen({Key key, @required ThingsItem thing}):super(key:key, thing: thing);

  @override
  Widget buildTopRowButtons(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
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
  @override
  Widget buildThingsInfoHeader() {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Form(
        key: _formKey,
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
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(thing.name,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                    ),
                    Text(
                      thing.value.toString(),
                      style: textStyle,
                    )
                  ],
                ),
              ),
            ],
          )),
    );
  }

}