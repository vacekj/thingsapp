import 'package:flutter/material.dart';

import 'package:DClutter/dflutter.dart';
import 'package:DClutter/things_database.dart';

class AddScreen extends StatefulWidget {
  AddScreen({Key key}) : super(key: key);

  @override
  _AddScreenState createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  final addThingNameController = TextEditingController();
  final addThingValueController = TextEditingController();
  final addThingDateController = TextEditingController();
  ThingsItem thing = new ThingsItem();
  final _formKey = GlobalKey<
      FormState>(); //TODO make a working form that save a thing and passes it to the main screen for saving

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            buildTopRowButtons(context),
            buildImage(),
            buildForm(context)
          ],
        ),
      ),
    );
  }

  Widget buildTopRowButtons(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 0.0),
            child: IconButton(
              icon: DFlutter.thingsIcon('assets/graphics/tick-icon.png'),
              onPressed: () {
                saveThing();
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 0.0),
            child: const Text(
              'Add Item',
              style: TextStyle(fontSize: 20.0),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 0.0),
            child: IconButton(
                icon: DFlutter.thingsIcon('assets/graphics/down-arrow.png',
                    height: 15),
                onPressed: () {
                  Navigator.pop(context);
                }),
          )
        ],
      ),
    );
  }

  Widget buildImage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        GestureDetector(
            child: DFlutter.thingsListImage(
                height: 80,
                width: 80,
                image: thing.image,
                noImagePath: 'assets/graphics/add-photo.png'))
      ],
    );
  }

  //TODO auto open modal sheet for image input
  Widget buildForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          TextFormField(
            decoration: const InputDecoration(
                hintText: 'Please enter a name', labelText: 'Name'),
            validator: (value) {
              if (value.isEmpty) {
                return 'Reeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee';
              }
              return null;
            },
            autovalidate: false,
            controller: addThingNameController,
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: TextFormField(
                  decoration: const InputDecoration(
                      hintText: 'Please estimate value', labelText: 'Value'),
                  keyboardType: TextInputType.number,
                ),
              ),
              Expanded(child: TextFormField(onTap: ()async{
                FocusScope.of(context).requestFocus(new FocusNode());
                final result =  await showDatePicker(context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.utc(1900),
                    lastDate: DateTime.now(),
                    builder: (BuildContext context, Widget child){
                      return Theme(data: ThemeData(),child: child,);
                    });
                addThingDateController.text=result.toString();
              }, decoration: const InputDecoration(
                  hintText: 'Please enter a date', labelText: 'Last used'),
                  controller: addThingDateController,
                  keyboardType: TextInputType.datetime),)
            ],
          ),
          RaisedButton(onPressed: ()async{
final result = await showDatePicker(context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime.utc(1900),
    lastDate: DateTime.now(),
    builder: (BuildContext context, Widget child){
      return Theme(data: ThemeData(),child: child,);
    });
    },)
        ],
      ),
    );
  }


  //TODO implement saving functionality
  saveThing() async {}
}
