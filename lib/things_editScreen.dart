import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as prefix0;
import 'package:path_provider/path_provider.dart';
import 'package:DClutter/things_database.dart';
import 'package:DClutter/dflutter.dart';

class EditScreen extends StatefulWidget {
  final ThingsItem thing;

  EditScreen({Key key, @required this.thing}) : super(key: key);

  @override
  EditScreenState createState() => EditScreenState();
}

class EditScreenState extends State<EditScreen> {
  final _formKey = GlobalKey<FormState>();

  final editItemNameController = TextEditingController();
  final editItemValueController = TextEditingController();

  @override
  void initState() {
    super.initState();
    editItemNameController.text = widget.thing.name;
    editItemValueController.text = widget.thing.value.toString();
  }

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

  saveThing() async {
    widget.thing.quickEdit(
        name: editItemNameController.text,
        value: double.tryParse(editItemValueController.text));
    await DatabaseHelper.instance.update(thing: widget.thing);
    Navigator.of(context).pop();
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
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 0.0),
                  child: IconButton(
                    icon: DFlutter.thingsIcon('assets/graphics/tick-icon.png'),
                    onPressed: () {
                      saveThing();
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 0.0),
                  child: IconButton(
                    icon: DFlutter.thingsIcon('assets/graphics/cross-icon.png'),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ),
          //TODO center the text
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 0.0),
            child: Center(
              child: const Text(
                'Edit Item',
                style: TextStyle(fontSize: 20.0),
              ),
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

  Widget buildThingsInfoHeader() {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Form(
          key: _formKey,
          child: Row(
            //TODO fix being unable to get a thing.value from database
            children: <Widget>[
              GestureDetector(
                child: DFlutter.thingsListImage(image: widget.thing.image),
                onTap: () async {
                  await showModalBottomSheet(
                      context: context,
                      builder: (BuildContext bc) {
                        return Container(
                          child: new Wrap(
                            children: <Widget>[
                              new ListTile(
                                title: new Text('Take a picture'),
                                leading: new Icon(Icons.camera),
                                onTap: () async {
                                  widget.thing.image =
                                      await ImagePicker.pickImage(
                                          source: ImageSource.camera);
                                  Navigator.of(context).pop();
                                },
                              ),
                              new ListTile(
                                title: new Text('Select from gallery'),
                                leading: new Icon(Icons.image),
                                onTap: () async {
                                  File image = await ImagePicker.pickImage(
                                      source: ImageSource.gallery);
                                  if (image == null) return;
                                  Directory appDocDir =
                                      await getApplicationDocumentsDirectory();
                                  String appDocDirPath = appDocDir.path;
                                  var fileName = prefix0.basename(image.path);
                                  widget.thing.image = await image
                                      .copy('$appDocDirPath/$fileName');
                                  print('You have selected gallery image :' +
                                      widget.thing.image.path);
                                  Navigator.of(context).pop();
                                },
                              )
                            ],
                          ),
                        );
                      });
                  setState(() {});
                  print('you pressed da button');
                },
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      child: TextFormField(
                        textAlign: TextAlign.center,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter a name';
                          }
                          return null;
                        },
                        controller: editItemNameController,
                      ),
                    ),
                    Container(
                      child: TextFormField(
                        textAlign: TextAlign.center,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter an estimated value';
                          }
                          return null;
                        },
                        controller: editItemValueController,
                      ),
                    )
                  ],
                ),
              ),
            ],
          )),
    );
  }
}

class EditPageRoute<T> extends MaterialPageRoute<T> {
  EditPageRoute({
    @required WidgetBuilder builder,
    RouteSettings setting,
    bool maintainState = true,
    bool fullscreenDialog = false,
  }) : super(
            builder: builder,
            maintainState: maintainState,
            settings: setting,
            fullscreenDialog: fullscreenDialog);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return child;
  }
}
