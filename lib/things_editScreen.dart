import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:things_app/things_database.dart';
import 'package:things_app/things_infoScreen.dart';

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
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDeleteDialog(context, widget.thing);
          },
          child: Icon(Icons.delete_outline),
        ),
        bottomNavigationBar: BottomAppBar(
          shape: CircularNotchedRectangle(),
          notchMargin: 4.0,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              RaisedButton(
                onPressed: () async {
                  widget.thing.quickEdit(
                      name: editItemNameController.text,
                      value: double.tryParse(editItemValueController.text));
                  await DatabaseHelper.instance.update(thing: widget.thing);
                  Navigator.of(context).pop();
                },
                child: Text('Save changes'),
              ),
            ],
          ),
        ));
  }

  Widget buildTopRowButtons(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
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
      child: Form(
          key: _formKey,
          child: Row(
            //TODO fix being unable to get a thing.value from database
            children: <Widget>[
              GestureDetector(
                child: Container(
                  width: 70.0,
                  height: 70.0,
                  decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      image: new DecorationImage(
                          image: widget.thing.image == null
                              ? new AssetImage('graphics/add_icon.jpg')
                              : new FileImage(widget.thing.image),
                          fit: BoxFit.fill)),
                ),
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
                                  widget.thing.image =
                                      await ImagePicker.pickImage(
                                          source: ImageSource.gallery);
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
