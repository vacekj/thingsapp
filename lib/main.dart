import 'package:flutter/material.dart';
import 'package:things_app/things_database.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'THINGS',
      theme: ThemeData(
        primaryColor: Colors.white,
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
      home: StartUpPage(title: 'THINGS'),
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
  final _formKey = GlobalKey<FormState>();

  final addItemNameController =
      TextEditingController(); //Used to retrieve user data from text fields
  final addItemValueController = TextEditingController();

  List<ThingsItem> _possessions = <ThingsItem>[];

  final TextStyle _fontSize = const TextStyle(fontSize: 20.0);

  bool _emptyThingsList = true;

  @override
  void dispose() {
    addItemNameController.dispose();
    addItemValueController.dispose();
    super.dispose();
  }

  //database
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _readAll();
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
        // Here we take the value from the StartUpPage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.add), onPressed: _pushAddThings)
        ],
      ),
      body: _buildThingsList(),
    );
  }

  Widget _buildThingsList() {
    FutureBuilder<List<ThingsItem>>(
      future: DatabaseHelper.instance.queryAllThings(),
      builder:
          (BuildContext context, AsyncSnapshot<List<ThingsItem>> snapshot) {
        if (snapshot.hasData) {
          snapshot.data.forEach((element) => print(element));
          _possessions.forEach((element) => print(element));
        }
        return null;
      },
    );
    if (_possessions.isEmpty && _emptyThingsList) {
      ThingsItem T = new ThingsItem();
      T.id = -1;
      T.name = 'Your list is empty! Try adding something.';
      T.value = 0;
      print("Pre add:");
      _possessions.forEach((element) => print(element));
      _possessions.add(T);
      print("post add:");
      _possessions.forEach((element) => print(element));
    }
    return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: _possessions.length * 2 - 1,
        itemBuilder: (context, index) {
          if (index.isOdd) return Divider();

          return _buildRow(_possessions[(index + 1) ~/ 2]);
        });
  }

  Widget _buildRow(ThingsItem thing) {
    return ListTile(
      title: Text(
        thing.name,
        style: _fontSize,
      ),
      trailing: Icon(Icons.navigate_next),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          //TODO deleting from list and database
          //Name
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3.0),
            child: new ListTile(
              title: new Text('Name'),
              onTap: () => {},
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: TextFormField(
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
            padding: const EdgeInsets.symmetric(horizontal: 3.0),
            child: new ListTile(
              title: new Text('Value'),
              onTap: () => {},
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: TextFormField(
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
                child: RaisedButton(
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      //_read();
                      if (_emptyThingsList && _possessions.length == 1) {
                        _possessions.clear();
                        ThingsItem T = new ThingsItem();
                        print(
                            'Adding new thing to possessions; printing possessions length');
                        print(_possessions.length);
                        T.id = _possessions.length;
                        T.name = addItemNameController.text;
                        T.value = double.parse(addItemValueController.text);
                        _possessions.add(T);
                        _save(T);
                        _emptyThingsList = false;
                      } else {
                        ThingsItem T = new ThingsItem();
                        print(
                            'Adding new thing to possessions; printing possessions length');
                        print(_possessions.length);
                        T.id = _possessions.length;
                        T.name = addItemNameController.text;
                        T.value = double.parse(addItemValueController.text);
                        _possessions.add(T);
                        _save(T);
                      }
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

  void _pushAddThings() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
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

  _readAll() async {
    DatabaseHelper helper = DatabaseHelper.instance;
    List<ThingsItem> tList = await helper.queryAllThings();
    if (tList == null) {
      print('read list returned null');
    } else if (tList.isEmpty) {
      print('read list is empty');
    } else {
      tList.forEach((element) => print(element));
    }
    _possessions = tList;
    setState(() {});
  }
}
