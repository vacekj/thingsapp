import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:things_app/things_database.dart';
import 'package:things_app/things_infoScreen.dart';
import 'package:things_app/things_listView.dart';

void main() => runApp(MyApp());

 List<ThingsItem> possessions = <ThingsItem>[];


class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DClutter',
      theme: ThemeData(
        primaryColor: Color(0xFF253336),
        primaryTextTheme: TextTheme(title: TextStyle(color: Color(0xFFC2DFE3))),

        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blueGrey,
      ),
      home: StartUpPage(title: 'DClutter'),
    );
  }
}

class StartUpPage extends StatefulWidget {
  StartUpPage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _StartUpPageState createState() => _StartUpPageState();
}

class _StartUpPageState extends State<StartUpPage> {
  File thingImage;
  final _formKey = GlobalKey<FormState>();

  final addItemNameController =
      TextEditingController(); //Used to retrieve user data from text fields
  final addItemValueController = TextEditingController();

  //List<ThingsItem> possessions = <ThingsItem>[];

  final TextStyle _fontSize = const TextStyle(fontSize: 20.0);

  bool _emptyThingsList = true;
  int _selectedIndex = 0;

//TODO image picker perms for IOS
  @override
  void dispose() {
    addItemNameController.dispose();
    addItemValueController.dispose();
    super.dispose();
  }

  //database
  @override
  void initState() {
    super.initState();
    readAll();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        leading:
            IconButton(icon: Icon(Icons.settings), onPressed: _placeholder),
        // Here we take the value from the StartUpPage object that was created by
        // the App.build method, and use it to set our appbar title.
        iconTheme: IconThemeData(color: Color(0xFFC2DFE3)),
        title: Text(widget.title),
        centerTitle: true,
        actions: <Widget>[
          IconButton(icon: Icon(Icons.add), onPressed: _pushThingsAdd)
        ],
      ),
      bottomNavigationBar: _bottomBar(),
      body: ThingsListView(),
    );
  }


  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: TextFormField(
              decoration: const InputDecoration(
                  hintText: 'Please enter a name', labelText: 'Name'),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter a name';
                }
                return null;
              },
              controller: addItemNameController,
            ),
          ),
          //Value
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: TextFormField(
              decoration: const InputDecoration(
                hintText: 'Please enter an estimated value',
                labelText: 'Value',
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter a value';
                }
                return null;
              },
              controller: addItemValueController,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Center(
              //TODO ditch modal sheet, cant set state while it is shown
              child: RaisedButton(
                child: Text('Select image'),
                onPressed: () async {
                  await imageSelector();
                  setState(() {});
                },
              ),
            ),
          ),
          Center(
            child: circleImage(image: thingImage),
          ),
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Center(
                child: RaisedButton(
                  onPressed: () async {
                    Directory appDocDir =
                        await getApplicationDocumentsDirectory();
                    String appDocDirPath = appDocDir.path;
                    if (_formKey.currentState.validate()) {
                      //_read();
                      if (_emptyThingsList && possessions.length == 1) {
                        possessions.clear();
                        ThingsItem T = new ThingsItem();
                        print(
                            'Adding new thing to possessions; printing possessions length');
                        print(possessions.length);
                        //T.id = _possessions.length;
                        T.name = addItemNameController.text;
                        T.value = double.parse(addItemValueController.text);

                        T.image = thingImage == null
                            ? null
                            : await thingImage.copy('$appDocDirPath/$T.id');
                        //_possessions.add(T);
                        _save(T);
                        _emptyThingsList = false;
                        readAll();
                      } else {
                        ThingsItem T = new ThingsItem();
                        print(
                            'Adding new thing to possessions; printing possessions length');
                        print(possessions.length);
                        //T.id = _possessions.length;
                        T.name = addItemNameController.text;
                        T.value = double.parse(addItemValueController.text);
                        T.image = thingImage == null
                            ? null
                            : await thingImage.copy('$appDocDirPath/$T.id');
                        //_possessions.add(T);
                        _save(T);
                        readAll();
                      }
                      Navigator.of(context).pop();
                      setState(() {});
                    }
                  },
                  child: new Text('Add'),
                ),
              ))
        ],
      ),
    );
  }

  void _pushThingsAdd() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            child: new Wrap(
              children: <Widget>[
                new ListTile(
                  title: new Text('Add a thing',
                      style: new TextStyle(fontSize: 30.0)),
                  trailing: new IconButton(
                      icon: new Icon(Icons.close),
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                ),
                new Divider(),
                _buildForm(),
              ],
            ),
          );
        });
  }

  Widget _bottomBar() {
    return BottomNavigationBar(
      currentIndex: 1,
      items: [
        BottomNavigationBarItem(
            icon: Icon(Icons.dashboard), title: Text("Dashboard")),
        BottomNavigationBarItem(
            icon: Icon(Icons.format_list_bulleted), title: Text("List")),
      ],
    );
  }

  Widget circleImage(
      {@required File image, double width = 50.0, double height = 50.0}) {
    return Container(
      width: width,
      height: height,
      decoration: new BoxDecoration(
          shape: BoxShape.circle,
          image: new DecorationImage(
              image: image == null
                  ? new AssetImage('graphics/add_icon.jpg')
                  : new FileImage(thingImage),
              fit: BoxFit.fill)),
    );
  }

  navigateToInfoPage(BuildContext context, ThingsItem thing) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => InfoScreen(thing: thing)),
    );
    if (result == "Deleted") {
      readAll();
    }
  }

  _read() async {
    DatabaseHelper helper = DatabaseHelper.instance;
    int rowId = 1;
    ThingsItem thing = await helper.queryThing(rowId);
    if (thing == null) {
      print('read row $rowId: empty');
    } else {
      print('read row $rowId: ${thing.name} ${thing.value}');
    }
  }

  _save(ThingsItem thing) async {
    DatabaseHelper helper = DatabaseHelper.instance;
    int id = await helper.insert(thing);
    print('inserted row: $id');
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
    possessions = tList;
    setState(() {});
  }

  imageSelector() async {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: new Wrap(
              children: <Widget>[
                new ListTile(
                  title: new Text('Take a picture'),
                  leading: new Icon(Icons.camera),
                  onTap: () async {
                    thingImage =
                        await ImagePicker.pickImage(source: ImageSource.camera);
                    Navigator.of(context).pop();
                  },
                ),
                new ListTile(
                  title: new Text('Select from gallery'),
                  leading: new Icon(Icons.image),
                  onTap: () async {
                    thingImage = await ImagePicker.pickImage(
                        source: ImageSource.gallery);
                    print(
                        'You have selected gallery image :' + thingImage.path);
                    Navigator.of(context).pop();
                  },
                )
              ],
            ),
          );
        });
  }

  _placeholder() {}
}
